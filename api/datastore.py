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
	latOffset = db.FloatProperty()
	lonOffset = db.FloatProperty()
	precision = db.FloatProperty()

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
	def by_lat(cls,lat):
		latitudes = Pins.all().filter('lat =', lat).get()
		return latitudes

	@classmethod
	def by_lon(cls,lon):
		longitudes = Pins.all().filter('lon =', lon).get()
		return longitudes

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
	cpgnKey = ""

	def __init__(self):
		cpgn = Greenup()
		self.cpgnKey = Greenup.app_key()

	def getComments(self, type, page):
		# memcache or datastore read
		pass

	def submitComments(self, commentType, message, pin=None):
		# datastore write
		cmt = Comments(parent = self.cpgnKey, commentType=commentType, message=message, pin=pin).put()

		# TODO: update # of datastore writes in memecached for refreshment purposes

	def getHeatmap(self, latDegrees=None, latOffset=None, lonDegrees=None, lonOffset=None, precision=None):
		# memcache or datastore read
		pass

	def updateHeatmap(self, latDegree, lonDegree, secondsWorked):
		# datastore write
		pass

	def getPins(self, latDegrees=None, latOffset=None, lonDegrees=None, lonOffset=None, precision=None):
		# memcache or datastore read
		pass

	def submitPin(self, latDegrees, lonDegrees, type, message):
		# datastore write
		pass

'''
	Memecache layer, used to perform necessary methods for interaction with cache. Note that the cache becomes stale after X 
	datastore writes have been performed.
'''
def setData(key, val):
	# simple wrapper for memcache.set, in case we need to extend it.
	memcache.set(key, val)

def getData(key):
	# wrapper for memcache get, will return none if the data wasn't found
	result = memcache.get(key)

	if not result:
		return None

	return result