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

# TYPES_AVAILABLE = ['General Message', 'Help Needed', 'Trash Pickup']
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
	def by_lat(cls,lat, offset=None):
		if not offset:
			latitudes = Pins.all().filter('lat =', lat)
			return latitudes
		else:
			latitudes = Pins.all().filter('lat >=', lat).filter('lat <=', lat + offset)
		return latitudes

	@classmethod
	def by_lon(cls,lon, offset=None):
		if not offset:
			longitudes = Pins.all().filter('lon =', lon)
		else:
			longitudes = Pins.all().filter('lon >=', lon).filter('lon <=', lon + offset)
		return longitudes

	@classmethod
	def get_all_pins(cls):
		pins = Pins.all()
		return pins

	@classmethod
	def by_lat_and_lon(cls, lat, latOffset, lon, lonOffset):
		if not latOffset:
			both = Pins.all().filter('lon =', lon).filter('lat =', lat)
			return both
		else:
			longitudes = Pins.all().filter('lon >=', lon).filter('lon <=', lon + offset)
			latitudes = Pins.all().filter('lat >=', lat).filter('lat <=', lat + offset)
		return longitudes, latitudes

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

	@classmethod
	def by_type_pagination(cls, cType):
		ct = Comments.all().filter('commentType =', cType)
		return ct

class GridPoints(Greenup):
	lat = db.FloatProperty()
	lon = db.FloatProperty()
	secondsWorked = db.IntegerProperty()

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

	@classmethod
	def get_all_delayed(cls):
		return GridPoints.all()

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
		comments=  paging(page,cType.upper())
		#Convert comments to simple dictionaries for the comments endpoint to use
		dictComments = []
		for comment in comments:
			dictComments.append({'type' : comment.commentType, 'message' : comment.message, 'pin' : comment.pin, 'timestamp' : comment.timeSent.ctime(), 'id' : comment.key().id()})
		return dictComments

	def submitComments(self, commentType, message, pin=None):
		# datastore write
		cmt = Comments(parent=self.appKey, commentType=commentType, message=message, pin=pin).put()
		updateCachedWrite(MEMCACHED_WRITE_KEY)

	def getHeatmap(self, latDegrees=None, latOffset=None, lonDegrees=None, lonOffset=None, precision=None):
		return heatmapFiltering(latDegrees,lonDegrees,latOffset,lonOffset,precision)

	def updateHeatmap(self, heatmapList):
		# datastore write
		for point in heatmapList:
			#We may want to consider some error checking here.
			gp = GridPoints(parent=self.appKey, lat=float(point['latDegrees']), lon=float(point['lonDegrees']), secondsWorked=point['secondsWorked']).put()

	def getPins(self, latDegrees=None, latOffset=None, lonDegrees=None, lonOffset=None):
		# datastore read
		return pinsFiltering(latDegrees, latOffset, lonDegrees, lonOffset)

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

def initialPage(typeFilter=None):
	'''
		set up initial page in memecache and the initial cursor. This will guarantee that at least one key and page will be 
		in the cache (the first one).
	'''
	querySet = Comments.all()
	initialCursorKey = 'greeunup_comment_paging_cursor_%s_%s' %(typeFilter,1)
	initialPageKey = 'greenup_comments_page_%s_%s' %(typeFilter,1)

	results = querySet[0:20]
	# results = querySet.run(batch_size=20)

	memcache.set(initialPageKey, serialize_entities(results))
	# entities = deserialize_entities(memcache.get("somekey"))

	commentsCursor = querySet.cursor()
	memcache.set(initialCursorKey, commentsCursor)

def paging(page=1,typeFilter=None):
	'''
		Paging works thusly:
		Try to find the cursor key for the page passed in. If you find it, look it up in cache and return it.
		If this cursor doesn't exist, look through all of the cursors down to 1. 
		When a hit occurs (and a hit must occur, as the first cursor and page is always read into memcache), build each page
		and their cursors up until we reach the page requested. Then, return that page of results.
	'''
	resultsPerPage = 20
	querySet = None
	if typeFilter is not None and typeFilter is not "":
		querySet = Comments.by_type_pagination(typeFilter)
	else:
		querySet = Comments.all()

	currentCursorKey = 'greeunup_comment_paging_cursor_%s_%s' %(typeFilter, page)
	pageInCache = memcache.get(currentCursorKey)

	misses = []

	if not memcache.get('greeunup_comment_paging_cursor_%s_%s' %(typeFilter, 1) ):
		# make sure the initial page is in cache
		initialPage(typeFilter)

	if not pageInCache:
		# if there is no such item in memecache. we must build up all pages up to 'page' in memecache
		for x in range(page - 1,0, -1):
			# check to see if the page key x is in cache
			prevCursorKey = 'greeunup_comment_paging_cursor_%s_%s' %(typeFilter, x)
			prevPageInCache = memcache.get(prevCursorKey)

			if not prevPageInCache:
				# if it isn't, then add it to the list of pages we need to create
				misses.append(prevCursorKey)

		# build all the pages we have in the misses stack 
		while misses:
			# get the cursor of the previous page
			cursorKey = misses.pop()			
			oldNum = int(cursorKey[-1]) - 1
			oldKey = 'greeunup_comment_paging_cursor_%s_%s' %(typeFilter, oldNum)
			cursor = memcache.get(oldKey)

			# get 20 results from where we left off
			results = querySet.with_cursor(start_cursor=cursor)
			results = results.run(limit=resultsPerPage)

			items = [item for item in results]

			# save an updated cursor in cache 
			commentsCursor = querySet.cursor()
			memcache.set(cursorKey, commentsCursor)

			# save those results in memecache with thier own key
			pageKey = 'greenup_comments_page_%s_%s' %(typeFilter, cursorKey[-1])
			memcache.set(pageKey, serialize_entities(items))

		# here is where we return the results for page = 'page', now that we've built all the pages up to 'page'
		prevCursor = 'greeunup_comment_paging_cursor_%s_%s' %(typeFilter, page-1)
		cursor = memcache.get(prevCursor)

		results = querySet.with_cursor(start_cursor=cursor)
		results = results.run(limit=resultsPerPage)

		items = [item for item in results]

		# save updated cursor
		commentsCursor = querySet.cursor()
		memcache.set(currentCursorKey, commentsCursor)

		# save results in memecache with key
		pageKey = 'greenup_comments_page_%s_%s' %(typeFilter, page)
		memcache.set(pageKey, serialize_entities(items))

		return items

	# otherwise, just get the page out of memcache
	# print "did this instead, cause it was in the cache"
	pageKey = "greenup_comments_page_%s_%s" %(typeFilter, page)
	results = deserialize_entities(memcache.get(pageKey))
	return results


def heatmapFiltering(latDegrees=None,lonDegrees=None,latOffset=1,lonOffset=1,precision=DEFAULT_ROUNDING_PRECISION):
	#Make sure offsets are set to default if not specified (consider putting in constants)
	if latOffset is None:
		latOffset = 1
	if lonOffset is None:
		lonOffset = 1

	#Get all unfiltered gridpoints
	toBeFiltered = GridPoints.get_all_delayed()
	toBeBucketSorted = []

	combined = False
	if latDegrees is None and lonDegrees is None:
		#Code in calling function must handle parsing to JSON the data modelst 
		toBeBucketSorted = toBeFiltered
	elif latDegrees is None:
		#No lonDegrees
		toBeBucketSorted = toBeFiltered.filter('lat <', latDegrees + latOffset).filter('lat >', latDegrees - latOffset)
	elif lonDegrees is None:
		#no latdegrees
		toBeBucketSorted = toBeFiltered.filter('lon <', lonDegrees + lonOffset).filter('lon >', lonDegrees - lonOffset)
	else:
		#lat degrees and londegrees are both present
		toBeBucketSorted = toBeFiltered.filter('lat <', (latDegrees + latOffset)).filter('lat >', (latDegrees - latOffset))
		combined = True #we must perform the second coordinates inequality in application code because of https://groups.google.com/forum/#!topic/google-appengine/F8f8JKJ0dPs


	#Now that we have all the items we want, bucket sort em with the precision
	buckets = {}
	for point in toBeBucketSorted:
		if combined:
			#filter on lon
			if not ((lonDegrees - lonOffset) <  point.lon and point.lon < (lonDegrees + lonOffset)):
				continue
		key = "%.*f_%.*f" % (latOffset,point.lat,lonOffset,point.lon)
		if key in buckets:
			buckets[key]['secondsWorked'] += point.secondsWorked
		else:
			buckets[key] = {'latDegrees' : float(round(point.lat,precision)), 'lonDegrees' : float(round(point.lon,precision)), 'secondsWorked' : point.secondsWorked}
	#Now send the buckets back as a list
	#note that buckets.items() will give back tuples, which is not what we want
	toReturn = []
	for key,bucket in buckets.iteritems():
		toReturn.append(bucket)
	return toReturn

def pinsFiltering(latDegrees, latOffset, lonDegrees, lonOffset):
	# filter by parameters passed in and return the appropriate dataset
	pins = {}
	toReturn = []
	
	if latDegrees is None and lonDegrees is None:
		# nothing specified, this means we return all of it
		dbPins = Pins.get_all_pins()
		return pinFormatter(dbPins)

	elif lonDegrees is None:
		# only latitude supplied
		dbPins = Pins.by_lat(lat=latDegrees, offset=latOffset)
		return pinFormatter(dbPins)

	elif latDegrees is None:
		# only longitude supplied
		dbPins = Pins.by_lon(lon=lonDegrees, offset=lonOffset)
		return pinFormatter(dbPins)

	elif (latDegrees and lonDegrees) and not lonOffset:
		# both lat and lon are supplied
		dbPins = Pins.by_lat_and_lon(lon=lonDegrees, lat=latDegrees, latOffset=latOffset, lonOffset=lonOffset)
		return pinFormatter(dbPins)

	elif latDegrees and latOffset and lonDegrees and lonOffset:
		# degrees are supplied with offsets
		dbPins = Pins.get_all_pins()
		dbLats = dbPins.filter('lat <', (latDegrees + latOffset)).filter('lat >', (latDegrees - latOffset))
		for pin in dbLats:
			#filter on lon
			if not ((lonDegrees - lonOffset) <  pin.lon and pin.lon < (lonDegrees + lonOffset)):
				continue
			key = "%f_%f" % (pin.lat, pin.lon)
			pins[key] = ({  'latDegrees' : pin.lat,
							'lonDegrees' : pin.lon,
							'type'		 : pin.pinType,
							'message'	 : pin.message })
		for key,item in pins.iteritems():
			toReturn.append(item)

		return toReturn

	else:
		return "Something bad happened"

def pinFormatter(dbPins):
	pins = {}
	toReturn = []	
	for pin in dbPins:		
		key = "%f_%f" % (pin.lat, pin.lon)
		pins[key] = ({  'latDegrees' : pin.lat,
						'lonDegrees' : pin.lon,
						'type'		 : pin.pinType,
						'message'	 : pin.message })
	for key,item in pins.iteritems():
		toReturn.append(item)

	return toReturn
