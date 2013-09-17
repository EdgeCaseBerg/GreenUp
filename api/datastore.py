# https://developers.google.com/appengine/docs/python/gettingstartedpython27/usingdatastore
# building relationships: https://developers.google.com/appengine/articles/modeling

'''
	Datastore entities required by the API. Entities are organized in a hierarchy much like a filesystem, with entity groups 
	specified in order to create transactional domains, within which queries are strongly consistent. The root entity is the 
	'campaign', with sub entities such as 'greenup' being its children. 
'''

from google.appengine.ext import db
from handlerBase import *
from google.appengine.api import memcache
from google.appengine.datastore import entity_pb
import logging
import hashlib
from datetime import date
from constants import *

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
		bc = Pins.all().ancestor(Pins.app_key()).filter('message =', message).get()
		return bc

	@classmethod
	def by_type(cls, pinType):
		bt = Pins.all().ancestor(Pins.app_key()).filter('pinType =', pinType).get()
		return bt

	@classmethod
	def by_lat(cls,lat, offset=None):
		if not offset:
			latitudes = Pins.all().ancestor(Pins.app_key()).filter('lat =', lat)
			return latitudes
		else:
			latitudes = Pins.all().ancestor(Pins.app_key()).filter('lat >=', lat).filter('lat <=', lat + offset)
		return latitudes

	@classmethod
	def by_lon(cls,lon, offset=None):
		if not offset:
			longitudes = Pins.all().ancestor(Pins.app_key()).filter('lon =', lon)
		else:
			longitudes = Pins.all().ancestor(Pins.app_key()).filter('lon >=', lon).filter('lon <=', lon + offset)
		return longitudes

	@classmethod
	def get_all_pins(cls):
		pins = Pins.all().ancestor(Pins.app_key())
		return pins

	@classmethod
	def by_lat_and_lon(cls, lat, latOffset, lon, lonOffset):
		if not latOffset:
			both = Pins.all().ancestor(Pins.app_key()).filter('lon =', lon).filter('lat =', lat)
			return both
		else:
			longitudes = Pins.all().ancestor(Pins.app_key()).filter('lon >=', lon).filter('lon <=', lon + offset)
			latitudes = Pins.all().ancestor(Pins.app_key()).filter('lat >=', lat).filter('lat <=', lat + offset)
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
		ct = Comments.all().ancestor(Comments.app_key()).filter('commentType =', cType).get()	
		return ct

	@classmethod
	def by_type_pagination(cls, cType):
		ct = Comments.all().ancestor(Comments.app_key()).filter('commentType =', cType)
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
		latitudes = GridPoints.all().ancestor(GridPoints.app_key()).filter('lat =', lat).get()
		return latitudes

	@classmethod
	def by_lon(cls,lon):
		longitudes = GridPoints.all().ancestor(GridPoints.app_key()).filter('lon =', lon).get()
		return longitudes

	@classmethod
	def by_latOffset(cls, latDegrees, offset):
		# query all points with a latitude between latDegrees and offset
		# this defines a chunk of the map containing the desired points
		q = GridPoints().all().ancestor(GridPoints.app_key()).filter('lat >=', latDegrees).filter('lat <=', latDegrees + offset).get()
		return q

	@classmethod
	def by_lonOffset(cls, lonDegrees, offset):
		# query all points with a latitude between lonDegrees and offset
		q = GridPoints().all().ancestor(GridPoints.app_key()).filter('lon >=', lonDegrees).filter('lon <=', lonDegrees + offset).get()
		return q

	@classmethod
	def get_all_delayed(cls):
		return GridPoints.all().ancestor(GridPoints.app_key())

class DebugReports(Greenup):

	errorMessage = db.StringProperty()
	debugInfo = db.StringProperty()
	timeSent = db.DateTimeProperty(auto_now_add = True)
	origin = db.StringProperty(required = True)
	authhash = db.StringProperty(required = True)

	@classmethod 
	def by_id(cls, debugId):
		return DebugReports.get_by_id(debugId, parent=app_key())

	@classmethod
	def by_origin(cls, origin):
		errors = DebugReports.all().ancestor(DebugReports.app_key()).filter('origin =', origin).get()	
		return ct 

	@classmethod
	def since(cls,timeSent):
		#gets delayed. call get on it
		return DebugReports.all().ancestor(DebugReports.app_key()).filter('timeSent >',timeSent)

	@classmethod
	def by_hash(cls,theHash):
		return DebugReports.all().ancestor(DebugReports.app_key()).filter('authhash =',theHash).get()		

	@classmethod
	def get_all(cls):
		return DebugReports.all().ancestor(DebugReports.app_key()).get()

	@classmethod
	def get_all_delayed(cls):
		return DebugReports.all().ancestor(DebugReports.app_key())



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
			dictComments.append({'type' : comment.commentType, 'message' : comment.message, 'pin' : comment.pin.key().id() if comment.pin is not None else "0" , 'timestamp' : comment.timeSent.ctime(), 'id' : comment.key().id()})
		return sorted(dictComments, key=lambda k: k['timestamp'], reverse=True) 
		

	def submitComments(self, commentType, message, pin=None):
		# datastore write
		cmt = Comments(parent=self.appKey, commentType=commentType, message=message, pin=pin).put()
		#Clear the memcache then recreate the initial page.
		memcache.flush_all()
		initialPage(None,"comment")

	def getHeatmap(self, latDegrees=None, latOffset=None, lonDegrees=None, lonOffset=None, precision=None,raw=False):
		return heatmapFiltering(latDegrees,lonDegrees,latOffset,lonOffset,precision,raw)

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
		c = Comments(parent=self.appKey, commentType=pinType,message=message,pin=p).put()
		memcache.flush_all()
		initialPage(None,"comment")
		return p.id()


	def submitDebug(self, errorMessage, debugInfo,origin):
		# submit information about a bug
		authhash = hashlib.sha256(errorMessage + debugInfo).hexdigest()
		debug = DebugReports(parent=self.appKey, errorMessage=errorMessage, debugInfo=debugInfo, authhash=authhash, origin=origin).put()
		memcache.flush_all()
		initialPage(None,"comment")

	def getDebug(self, debugId=None, theHash=None,since=None,page=1):
		# retrieve information about a bug by id, hash, or get them all with optional since time
		# add JSON Formatting to the returns such that {  "errror_message" : "Stack trace or debugging information here", "id":id, "time":timestamp } 
		if debugId is not None:
			logging.info("by id")
			bugs = DebugReports.by_id(debugId) 
		elif theHash is not None:
			logging.info("by hash")
			bugs = DebugReports.by_hash(theHash)
		else:
			bugs = paging(page,None,"debug",since)
		logging.info(bugs)
		return debugFormatter(bugs)	

	def deleteDebug(self,origin,theHash):
		# remove a bug from the datastore (if only we could remove all the bugs from the datastore! )
		debugReport = DebugReports.by_hash(theHash)
		msg = "Succesful Deletion"
		if debugReport is None:
			stat = HTTP_NOT_FOUND
		else:
			if debugReport.origin == origin:
				debugReport.delete()
				stat = HTTP_DELETED
			else:
				stat = HTTP_NOT_FOUND
		return stat,msg

	def checkNextPage(self, page):
		# check for the presence of a next page in memecache
		if memcache.get('greenup_%s_%s_paging_cursor_%s_%s' %(None,"comment",None, page+1) ):
			return page+1
		else:
			q = Comments.all()
			total = q.count()
			if (((page-1) * PAGE_SIZE) < total):
				return page+1
			else:
				return None

		return None	

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

def initialPage(typeFilter=None, endpoint="comment",sinceTime=None):
	'''
		set up initial page in memecache and the initial cursor. This will guarantee that at least one key and page will be 
		in the cache (the first one).
	'''
	if endpoint == "comment":
		querySet = Comments.all().ancestor(Comments.app_key())
	elif endpoint == "debug":
		querySet = DebugReports.all().ancestor(DebugReports.app_key())
	else:
		raise Exception("No paging supported for comment")
	initialCursorKey = 'greenup_%s_%s_paging_cursor_%s_%s' %(sinceTime,endpoint,typeFilter,1)
	initialPageKey = 'greenup_%s_%ss_page_%s_%s' %(sinceTime,endpoint,typeFilter,1)

	results = querySet[0:PAGE_SIZE]
	# sort, newest to oldest
	results = sorted(results, key=lambda dataPoint: dataPoint.timeSent, reverse=True)
	memcache.set(initialPageKey, serialize_entities(results))

	dataCursor = querySet.cursor()
	memcache.set(initialCursorKey, dataCursor)

def paging(page=1,typeFilter=None,endpoint="comment",sinceTime=None):
	'''
		Paging works thusly:
		Try to find the cursor key for the page passed in. If you find it, look it up in cache and return it.
		If this cursor doesn't exist, look through all of the cursors down to 1. 
		When a hit occurs (and a hit must occur, as the first cursor and page is always read into memcache), build each page
		and their cursors up until we reach the page requested. Then, return that page of results.
	'''
	resultsPerPage = PAGE_SIZE
	querySet = None
	if typeFilter is not None and typeFilter is not "":
		#typeFilter must always by null when coming from debug endpoint
		querySet = Comments.by_type_pagination(typeFilter)
	else:
		if endpoint == "comment":
			querySet = Comments.all().ancestor(Pins.app_key())
		elif endpoint == "debug":
			if sinceTime is not None:
				querySet = DebugReports.since(sinceTime)
			else:
				querySet = DebugReports.get_all_delayed()

	currentCursorKey = 'greenup_%s_%s_paging_cursor_%s_%s' %(sinceTime,endpoint,typeFilter, page)
	pageInCache = memcache.get(currentCursorKey)

	misses = []

	if not memcache.get('greenup_%s_%s_paging_cursor_%s_%s' %(sinceTime,endpoint,typeFilter, 1) ):
		# make sure the initial page is in cache
		initialPage(typeFilter,endpoint,sinceTime)

	if not pageInCache:
		if page is None:
			page = 1
		# if there is no such item in memecache. we must build up all pages up to 'page' in memecache
		for x in range(page - 1,0, -1):
			# check to see if the page key x is in cache
			prevCursorKey = 'greenup_%s_%s_paging_cursor_%s_%s' %(sinceTime,endpoint,typeFilter, x)
			prevPageInCache = memcache.get(prevCursorKey)

			if not prevPageInCache:
				# if it isn't, then add it to the list of pages we need to create
				misses.append(prevCursorKey)

		# build all the pages we have in the misses stack 
		while misses:
			# get the cursor of the previous page
			cursorKey = misses.pop()			
			oldNum = int(cursorKey[-1]) - 1
			oldKey = 'greenup_%s_%s_paging_cursor_%s_%s' %(sinceTime,endpoint,typeFilter, oldNum)
			cursor = memcache.get(oldKey)

			# get PAGE_SIZE results from where we left off
			results = querySet.with_cursor(start_cursor=cursor)
			results = results.run(limit=resultsPerPage)

			items = [item for item in results]

			# save an updated cursor in cache 
			dataCursor = querySet.cursor()
			memcache.set(cursorKey, dataCursor)

			# save those results in memecache with thier own key
			pageKey = 'greenup_%s_%ss_page_%s_%s' %(sinceTime,endpoint,typeFilter, cursorKey[-1])
			memcache.set(pageKey, serialize_entities(items))

		# here is where we return the results for page = 'page', now that we've built all the pages up to 'page'
		prevCursor = 'greenup_%s_%s_paging_cursor_%s_%s' %(sinceTime,endpoint,typeFilter, page-1)
		cursor = memcache.get(prevCursor)

		results = querySet.with_cursor(start_cursor=cursor)
		results = results.run(limit=resultsPerPage)

		items = [item for item in results]
		# sort, newest to oldest
		items = sorted(items, key=lambda dataPoint: dataPoint.timeSent, reverse=True)

		# save updated cursor
		dataCursor = querySet.cursor()
		memcache.set(currentCursorKey, dataCursor)

		# save results in memecache with key
		pageKey = 'greenup_%s_%ss_page_%s_%s' %(sinceTime,endpoint,typeFilter, page)
		memcache.set(pageKey, serialize_entities(items))
		return items

	# otherwise, just get the page out of memcache
	# print "did this instead, cause it was in the cache"
	pageKey = "greenup_%s_%ss_page_%s_%s" %(sinceTime,endpoint,typeFilter, page)
	results = deserialize_entities(memcache.get(pageKey))
	
	# sort, newest to oldest
	results = sorted(results, key=lambda dataPoint: dataPoint.timeSent, reverse=True)

	return results


def heatmapFiltering(latDegrees=None,lonDegrees=None,latOffset=1,lonOffset=1,precision=DEFAULT_ROUNDING_PRECISION,raw=False):
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
	elif latDegrees is not None:
		#No lonDegrees
		toBeBucketSorted = toBeFiltered.filter('lat <', latDegrees + latOffset).filter('lat >', latDegrees - latOffset)
	elif lonDegrees is not None:
		#no latdegrees
		toBeBucketSorted = toBeFiltered.filter('lon <', lonDegrees + lonOffset).filter('lon >', lonDegrees - lonOffset)
	else:
		#lat degrees and londegrees are both present
		toBeBucketSorted = toBeFiltered.filter('lat <', (latDegrees + latOffset)).filter('lat >', (latDegrees - latOffset))
		combined = True #we must perform the second coordinates inequality in application code because of https://groups.google.com/forum/#!topic/google-appengine/F8f8JKJ0dPs


	#Now that we have all the items we want, bucket sort em with the precision
	buckets = {}
	highestVal = 0.0
	for point in toBeBucketSorted:
		if combined:
			#filter on lon
			if not ((lonDegrees - lonOffset) <  point.lon and point.lon < (lonDegrees + lonOffset)):
				continue
		key = "%.*f_%.*f" % (int(latOffset),point.lat,int(lonOffset),point.lon)
		if key in buckets:
			buckets[key]['secondsWorked'] += point.secondsWorked
			if buckets[key]['secondsWorked'] > highestVal:
				highestVal = buckets[key]['secondsWorked']
		else:
			buckets[key] = {'latDegrees' : float(round(point.lat,precision)), 'lonDegrees' : float(round(point.lon,precision)), 'secondsWorked' : point.secondsWorked}
			if buckets[key]['secondsWorked'] > highestVal:
				highestVal = buckets[key]['secondsWorked']
	#Now send the buckets back as a list
	#note that buckets.items() will give back tuples, which is not what we want
	toReturn = []
	for key,bucket in buckets.iteritems():
		#normalize data
		if not raw:
			bucket['secondsWorked'] = float(bucket['secondsWorked'])/float(highestVal)
		toReturn.append(bucket)
	return toReturn

def pinsFiltering(latDegrees, latOffset, lonDegrees, lonOffset):
	# filter by parameters passed in and return the appropriate dataset
	pins = []
	
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
			pins.append( {  'id' : pin.key().id(),
							'latDegrees' : pin.lat,
							'lonDegrees' : pin.lon,
							'type'		 : pin.pinType,
							'message'	 : pin.message }
						)
		return pins

	else:
		return "Something bad happened"

def pinFormatter(dbPins):
	# properly format pins in json and return
	pins = []
	for pin in dbPins:		
		pins.append( {  'id' : pin.key().id(),
						'latDegrees' : pin.lat,
						'lonDegrees' : pin.lon,
						'type'		 : pin.pinType,
						'message'	 : pin.message }
					)
	return pins
def debugFormatter(dbBugs):
	# properly format bugs in json and return
	bugs = []
	if dbBugs is None:
		return bugs
	for bug in dbBugs:
		bugs.append({   'message' : bug.errorMessage,
						'stackTrace'    : bug.debugInfo,
						'timestamp'    : bug.timeSent.strftime(SINCE_TIME_FORMAT) ,
						'hash' 		   : bug.authhash })
	return bugs