# https://developers.google.com/appengine/docs/python/gettingstartedpython27/usingdatastore
# building relationships: https://developers.google.com/appengine/articles/modeling

'''
	Datastore entities required by the API. Entities are organized in a hierarchy much like a filesystem, with entity groups 
	specified in order to create transactional domains, within which queries are strongly consistent. The root entity is the 
	'campaign', with sub entities such as 'greenup' being its children. 
'''

from google.appengine.ext import db
from handlerBase import *
from google.appengine.api import memcache # import memcache
from google.appengine.datastore import entity_pb

import logging 

from datetime import date

from constants import *

TYPES_AVAILABLE = ['General Message', 'Help Needed', 'Trash Pickup']
MEMCACHED_WRITE_KEY = "write_key"
STALE_CACHE_LIMIT = 20

class Campaign(db.Model):
	pass

class Greenup(Campaign):	
	@classmethod
	def app_key(cls):
	    return db.Key.from_path('apps', 'greenup')

class Pins(Greenup):
	message = db.TextProperty()
	pinType = db.StringProperty(choices=PIN_TYPES)
	# these must be stored precisely
	lat = db.FloatProperty()
	lon = db.FloatProperty()

	@classmethod
	def by_id(cls, pinId):
		return Pins.get_by_id(pinId, parent = app_key())

	@classmethod
	def by_message(cls, message):
		bc = Pins.all().filter('message =', message).get()
		return bc

	@classmethod
	def by_type(cls, pinType):
		bt = Pins.all().filter('pinType =', pinType).get()
		return bt

	@classmethod
	def by_lat(cls,lat, precision=5):
		latitudes = Pins.all().filter('lat =', lat).get()		
		return latitudes

	@classmethod
	def by_lon(cls,lon, precision=5):
		longitudes = Pins.all().filter('lon =', lon).get()
		return longitudes

class Comments(Greenup):

	commentType = db.StringProperty(choices=COMMENT_TYPES)
	message = db.TextProperty()
	timeSent = db.DateTimeProperty(auto_now_add = True)	
	pin = db.ReferenceProperty(Pins, collection_name ='pins')

	@classmethod
	def by_id(cls, commentId):
		return Comments.get_by_id(commentId, parent = app_key())
	
	@classmethod
	def by_type(cls,cType):
		ct = Comments.all().filter('commentType =', cType).get()	
		return ct

class GridPoints(Greenup):
	lat = db.FloatProperty()
	lon = db.FloatProperty()
	secondsWorked = db.FloatProperty()

	@classmethod
	def by_id(cls, gridId):
		return GridPoints.get_by_id(gridId, parent = app_key())

	@classmethod
	def by_lat(cls,lat):
		latitudes = GridPoints.all().filter('lat =', lat).get()
		return latitudes

	@classmethod
	def by_lon(cls,lon):
		longitudes = GridPoints.all().filter('lon =', lon).get()
		return longitudes

	@classmethod
	def by_latOffset(cls, latDegrees, offset):
		# query all points with a latitude between latDegrees and offset
		# this defines a chunk of the map containing the desired points
		q = GridPoints().all().filter('lat >=', latDegrees).filter('lat <=', latDegrees + offset).get()
		return q

	@classmethod
	def by_lonOffset(cls, lonDegrees, offset):
		# query all points with a latitude between lonDegrees and offset
		q = GridPoints().all().filter('lon >=', lonDegrees).filter('lon <=', lonDegrees + offset).get()
		return q

	# then we need to make a function that runs through that chunk and bucket-izes each point by rounding it (and stores the 
	# seconds worked for each of those points that went into the bucket) [see bucket sort or alpha sort]. this could be a function
	# separate from the datastore. 
	# we are returing these buckets (the rounded center of each of those buckets, and the total seconds worked corresponding to
	# each of those buckets).

'''
	Abstraction Layer between the user and the datastore, containing methods to processes requests by the endpoints.
'''
class AbstractionLayer():
	appKey = ""

	def __init__(self):
		app = Greenup()
		self.appKey = Greenup.app_key()

	def getComments(self, cType=None, page=None):
		# memcache or datastore read
		comments=  paging(page,cType)
		#Convert comments to simple dictionaries for the comments endpoint to use
		dictComments = []
		for comment in comments:
			dictComments.append({'commentType' : comment.commentType, 'message' : comment.message, 'pin' : comment.pin, 'timestamp' : comment.timeSent.ctime(), 'id' : comment.key().id()})
		return dictComments

	def submitComments(self, commentType, message, pin=None):
		# datastore write
		cmt = Comments(parent=self.appKey, commentType=commentType, message=message, pin=pin).put()
		updateCachedWrite(MEMCACHED_WRITE_KEY)

	def getHeatmap(self, latDegrees=None, latOffset=None, lonDegrees=None, lonOffset=None, precision=None):
		# memcache or datastore read
		pass

	def updateHeatmap(self, latDegrees, lonDegrees, secondsWorked):
		# datastore write
		gp = GridPoints(parent=self.appKey, lat=latDegrees, lon=lonDegrees, secondsWorked=secondsWorked).put()

	def getPins(self, latDegrees=None, latOffset=None, lonDegrees=None, lonOffset=None, precision=None):
		# memcache or datastore read
		pass

	def submitPin(self, latDegrees, lonDegrees, pinType, message):
		# datastore write
		p = Pins(parent=self.appKey, lat=latDegrees, lon=lonDegrees, pinType=pinType, message=message).put()

'''
	Memecache layer, used to perform necessary methods for interaction with cache. Note that the cache becomes stale after X 
	datastore writes have been performed.
'''
def serialize_entities(models):
	# http://blog.notdot.net/2009/9/Efficient-model-memcaching
	if models is None:
		return None
	elif isinstance(models, db.Model):
		# Just one instance
		return db.model_to_protobuf(models).Encode()
	else:
		# A list
		return [db.model_to_protobuf(x).Encode() for x in models]

def deserialize_entities(data):
	# http://blog.notdot.net/2009/9/Efficient-model-memcaching
	 if data is None:
		 return None
	 elif isinstance(data, str):
		 # Just one instance
		 return db.model_from_protobuf(entity_pb.EntityProto(data))
	 else:
		 return [db.model_from_protobuf(entity_pb.EntityProto(x)) for x in data]

def setCachedData(key, val):
	# simple wrapper for memcache.set, in case we need to extend it.
	memcache.set(key, val)

def getCachedData(key):
	# wrapper for memcache get, will return none if the data wasn't found
	result = memcache.get(key)

	if not result:
		return None

	return result

def updateCachedWrite(key):
	'''
		Check and see if a key has been created in memecached to store the number of writes.
		If it has, increment the amount of writes corresponding to that key, and check that number against some constant X.
		If the number of writes exceeds X, then flush the cache and repopulate it (if it doesn't, then do nothing).

		If the key hasn't been created, create it and update the writes saved to 1.
	'''
	result = getCachedData(key)

	if(not result):
		setCachedData(key, 1)
		return True

	result = int(result)
	if(result+1 > STALE_CACHE_LIMIT):
		# flush, then repopulate the cache with the first page of comment data from the datastore
		logging.info("20 writes exceeded, resetting cache. Total writes == " + str(result+1))
		memcache.flush_all()
		initialPage()
		setCachedData(key, 1)
	else:
		setCachedData(key, result+1)

def initialPage():
	'''
		set up initial page in memecache and the initial cursor. This will guarantee that at least one key and page will be 
		in the cache (the first one).
	'''
	querySet = Comments.all()
	initialCursorKey = 'greeunup_comment_paging_cursor_%s_%s' %(1,None)
	initialPageKey = 'greenup_comments_page_%s_%s' %(1,None)

	results = querySet[0:20]
	# results = querySet.run(batch_size=20)

	memcache.set(initialPageKey, serialize_entities(results))
	# entities = deserialize_entities(memcache.get("somekey"))

	commentsCursor = querySet.cursor()
	memcache.set(initialCursorKey, commentsCursor)

def paging(page,typeFilter):
	'''
		Paging works thusly:
		Try to find the cursor key for the page passed in. If you find it, look it up in cache and return it.
		If this cursor doesn't exist, look through all of the cursors down to 1. 
		When a hit occurs (and a hit must occur, as the first cursor and page is always read into memcache), build each page
		and their cursors up until we reach the page requested. Then, return that page of results.
	'''
	resultsPerPage = 20
	querySet = None
	if typeFilter is not None:
		querySet = Comments.by_type(typeFilter)
	else:
		querySet = Comments.all()
	if page is None:
		page = 1

	currentCursorKey = 'greeunup_comment_paging_cursor_%s_%s' %(page,typeFilter)
	pageInCache = memcache.get(currentCursorKey)
	misses = []

	if not memcache.get('greeunup_comment_paging_cursor_1'):
		# make sure the initial page is in cache
		initialPage()

	if not pageInCache:
		# if there is no such item in memecache. we must build up all pages up to 'page' in memecache
		for x in range(page - 1,0, -1):
			# check to see if the page key x is in cache
			prevCursorKey = 'greeunup_comment_paging_cursor_%s' %(x,typeFilter)
			prevPageInCache = memcache.get(prevCursorKey)

			if not prevPageInCache:
				# if it isn't, then add it to the list of pages we need to create
				misses.append(prevCursorKey)

		# build all the pages we have in the misses stack 
		while misses:
			# get the cursor of the previous page
			cursorKey = misses.pop()
			oldNum = int(cursorKey[-1]) - 1
			oldKey = 'greeunup_comment_paging_cursor_%s_%s' %(oldNum,typeFilter)
			cursor = memcache.get(oldKey)

			# get 20 results from where we left off
			results = querySet.with_cursor(start_cursor=cursor)
			results = results.run(limit=resultsPerPage)

			items = [item for item in results]

			# save an updated cursor in cache 
			commentsCursor = querySet.cursor()
			memcache.set(cursorKey, commentsCursor)

			# save those results in memecache with thier own key
			pageKey = 'greenup_comments_page_%s_%s' %(cursorKey[-1],typeFilter)
			memcache.set(pageKey, serialize_entities(items))

		# here is where we return the results for page = 'page', now that we've built all the pages up to 'page'
		prevCursor = 'greeunup_comment_paging_cursor_%s_%s' %(page-1,typeFilter)
		cursor = memcache.get(prevCursor)
		#This causes an error on initial write. Not sure how to fix it, the querySet is None
		#Phelan can you fix this?
		results = querySet.with_cursor(start_cursor=cursor)
		results = results.run(limit=resultsPerPage)

		items = [item for item in results]

		# save updated cursor
		commentsCursor = querySet.cursor()
		memcache.set(currentCursorKey, commentsCursor)

		# save results in memecache with key
		pageKey = 'greenup_comments_page_%s_%s' %(page,typeFilter)
		memcache.set(pageKey, serialize_entities(results))

		return items

	# otherwise, just get the page out of memcache
	print "did this instead, cause it was in the cache"
	pageKey = "greenup_comments_page_%s_%s" %(page,typeFilter)
	results = deserialize_entities(memcache.get(pageKey))
	return results