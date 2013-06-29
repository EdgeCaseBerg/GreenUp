# datastore entities required by API.
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

import logging 

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
	pinType = db.StringProperty(choices=('General Message', 'Help Needed', 'Trash Pickup'))
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

class Comments(Greenup):
	commentType = db.StringProperty(choices=('General Message', 'Help Needed', 'Trash Pickup'))
	message = db.TextProperty()
	timeSent = db.DateTimeProperty(auto_now_add = True)	
	pin = db.ReferenceProperty(Pins, collection_name ='pins')

	@classmethod
	def by_id(cls, commentId):
		return Comments.get_by_id(commentId, parent = app_key)
	
	@classmethod
	def by_type(cls,cType):
		ct = Comments.all().filter('commentType =', cType).get()

class GridPoints(Greenup):
	lat = db.FloatProperty()
	lon = db.FloatProperty()
	secondsWorked = db.FloatProperty()

	@classmethod
	def by_id(cls, gridId):
		return GridPoints.get_by_id(gridId, parent = app_key)

	@classmethod
	def by_lat(cls,lat):
		latitudes = GridPoints.all().filter('lat =', lat).get()
		return latitudes

	@classmethod
	def by_lon(cls,lon):
		longitudes = GridPoints.all().filter('lon =', lon).get()
		return longitudes

	@classmethod
	def by_latOffset(cls, offset, etc):
		# TODO: implement this
		pass

	@classmethod
	def by_lonOffset(cls, offset, etc):
		# TODO: implement this
		pass

'''
	Abstraction Layer between the user and the datastore, containing methods to processes requests by the endpoints. Reads first check
	memcache, then look into the datastore if the read fails. Writes directly connect with the datastore.
'''
class AbstractionLayer():
	appKey = ""

	def __init__(self):
		app = Greenup()
		self.appKey = Greenup.app_key()

	def getComments(self, type=None, page=None):
		# memcache or datastore read
		pass

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
		updateCachedWrite(MEMCACHED_WRITE_KEY)

	def getPins(self, latDegrees=None, latOffset=None, lonDegrees=None, lonOffset=None, precision=None):
		# memcache or datastore read
		pass

	def submitPin(self, latDegrees, lonDegrees, pinType, message):
		# datastore write
		p = Pins(parent=self.appKey, lat=latDegrees, lon=lonDegrees, pinType=pinType, message=message).put()
		updateCachedWrite(MEMCACHED_WRITE_KEY)

'''
	Memecache layer, used to perform necessary methods for interaction with cache. Note that the cache becomes stale after X 
	datastore writes have been performed.
'''
def repopulate():
	app = Greenup()
	p = Pins.all().order('-time').fetch()
	key = Greenup.app_key()

	# q = Posts.all().order('-time').fetch(limit = 50)
	# key = "BLOG"

def setCachedData(key, val):
	# simple wrapper for memcache.set, in case we need to extend it.
	logging.info("made it here")
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
		# TODO: flush, then repopulate the cache with the data from the datastore
		logging.info("20 writes exceeded, resetting cache. Total writes == " + str(result+1))
		memcache.flush_all()
		repopulate()
		setCachedData(key, 0)
	else:
		setCachedData(key, result+1)