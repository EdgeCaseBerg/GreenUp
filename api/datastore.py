# datastore entities required by API.
# https://developers.google.com/appengine/docs/python/gettingstartedpython27/usingdatastore
# building relationships: https://developers.google.com/appengine/articles/modeling

from google.appengine.ext import db
from handlerBase import *
from google.appengine.api import memcache # import memcache

import logging 

'''
	Datastore Classes (entities), prefaced by an ancestor function to make them consistent.
'''
def app_key(name = 'greenup'):
	# default name being greenup. this can be changed as we expand functionality
    return db.Key.from_path('apps', name)

class Greenup(db.Model):
	'''
		Here is our greenup database model superclass. This is done so we can expand with different classes (campaign, etc...)
	'''
	@classmethod
	def by_id(cls, id):
		raise NotImplementedError # override this on the child classes

class Types(Greenup):
	# What type of message/pin is being placed.
	description = db.StringProperty(choices=('General Message', 'Help Needed', 'Trash Pickup'))

	@classmethod
	def by_id(cls, typeId):
		# looks up type by id
		return Comments.get_by_id(typeId, parent = app_key)
	
	@classmethod
	def by_descriptionType(cls,name):
		# looks up type by its description
		dt = Types.all().filter('description =', name).get()
		return dt

class GridPoints(Greenup):
	# GridPoints contains the points of the map grid. 

	lat = db.FloatProperty()
	lon = db.FloatProperty()
	secondsWorked = db.FloatProperty()

	@classmethod
	def by_id(cls, gridId):
		return GridPoints.get_by_id(gridId, parent = app_key)

	@classmethod
	def by_lat(cls,name):
		latitudes = GridPoints.all().filter('lat =', name).get()
		return latitudes

	@classmethod
	def by_lon(cls,name):
		longitudes = GridPoints.all().filter('lon =', name).get()
		return longitudes

class Comments(Greenup):
	# A forum message with a particular type and timestamp, also optionally associated to a pin

	commentType = db.ReferenceProperty(Types, collection_name ='types')
	message = db.TextProperty()
	timeSent = db.DateTimeProperty(auto_now_add = True)

	@classmethod
	def by_id(cls, commentId):
		# looks up comment by id
		return Comments.get_by_id(commentId, parent = app_key)
	
	@classmethod
	def by_commentType(cls,name):
		# looks up comment by comment type
		ct = Comments.all().filter('commentType =', name).get()
		return ct

	@classmethod
	def get_comments(cls, retrievalAmount = 10):
		# retrieve paginated comments using a cursor
		results = Comments.all()
		cursor = memcache.get('greenupCursor')

		# is there already a cursor in memcache? If so, use it.
		if cursor:
			results.with_cursor(start_cursor=cursor)
		
		# retrieve the amount you want
		resultsRetrieved = results[:retrievalAmount]

		# update the cursor
		newCursor = results.cursor()
		memcache.set('greenupCursor', newCursor)

		# send those results to the user
		return resultsRetrieved


class Pins(Greenup):
	# Pins are latitude and longitude points on the map with a particular type and a comment associated with them.

	comment = db.ReferenceProperty(Comments, collection_name = 'comments')
	pinType = db.ReferenceProperty(Types, collection_name = 'pin_types')

	lat = db.FloatProperty()
	lon = db.FloatProperty()
	
	@classmethod
	def by_id(cls, pinId):
		return Pins.get_by_id(pinId, parent = app_key())

	@classmethod
	def by_comment(cls, name):
		bc = Pins.all().filter('comment =', name).get()
		return bc

	@classmethod
	def by_type(cls, name):
		bt = Pins.all().filter('pinType =', name).get()
		return bt

	@classmethod
	def by_lat(cls,name):
		latitudes = Pins.all().filter('lat =', name).get()
		return latitudes

	@classmethod
	def by_lon(cls,name):
		longitudes = Pins.all().filter('lon =', name).get()
		return longitudes

'''
	Memcache methods that the user will call instead of direct datastore queries.
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

'''
	Test harness for reading and writing entities in the datastore.
'''
class MakeDatastoreTest(webapp2.RequestHandler):
	def get(self):
		self.response.write("write worked")

		# Set the same parent key on each entity to ensure consistent results and add some junk data
		types = Types(parent = app_key(), description = "Help Needed")
		gridPoints = GridPoints(parent = app_key(), lat = 1.0, lon = 2.0, secondsWorked = 10.0)
		comments = Comments(parent = app_key(), message = 'this is a message')
		pins = Pins(parent = app_key(), lat= 1.1, lon= 1.2)

		# put the junk data in the datastore
		types.put()
		gridPoints.put()
		comments.put()
		pins.put()

		# test out relational modelling
		types = Types(parent = app_key(), description = "General Message")
		types.put()
		Comments(parent=app_key(), commentType = types, message='i hope this works').put()


class DisplayDatastoreTest(webapp2.RequestHandler):
	def get(self):
		self.response.write("check logs for read")
		# types
		logging.info("## Types ##")
		types_query = Types.all()
		types_query.ancestor(app_key())
		for types in types_query.run():
			logging.info(types.description)

		types_query = Types.by_descriptionType('Help Needed')
		logging.info(types_query.description)

		# gridPoints
		logging.info("## GridPoints ##")
		gridPoints_query = GridPoints.all()
		gridPoints_query.ancestor(app_key())

		for gridPoints in gridPoints_query.run():
			logging.info('lat= %s, lon= %s, secondsWorked=%s' %(str(gridPoints.lat), str(gridPoints.lon), str(gridPoints.secondsWorked)) )

		# comments
		logging.info("## Comments ##")
		comments_query = Comments.all()
		comments_query.ancestor(app_key())

		for comments in comments_query.run():
			logging.info(comments.message)

		# pins
		logging.info("## Pins ##")
		pins_query = Pins.all()
		pins_query.ancestor(app_key())

		for pins in pins_query.run():
			logging.info('lat= %s, lon=%s' %(str(pins.lat), str(pins.lon)) )

import time
import pickle
import platform

class MemcacheVsDatastore(webapp2.RequestHandler):
	def get(self):
		#This primes the pump for any non-unix machines (http://docs.python.org/2/library/time.html)
		if( platform.system().lower().find("win") > -1 and platform.system().lower().find("win") < 3):
			#win < 3 because of darwin
			time.clock()
			


		#delete the datastore entities
		db.delete(db.Query(keys_only=True))

		#Place a single entity into the datastore
		firstPin = Pins(parent = app_key(), lat=0.0,lon=2.3).put()
		fpID = firstPin.id()
		
		#time how long it takes to retrieve the pin from the datastore using it's key id
		#We use 1000 times to really make a difference
		beforeTime = time.clock()
		for i in range(0,1000):
			Pins.by_id(fpID)
		afterTime = time.clock()
		datastoreRetrieval1 = (afterTime - beforeTime)/1000


		#Place the same entiry into the memcache
		setData(str(fpID),firstPin)
		beforeTime = time.clock()
		for i in range(0,1000):
			getData(str(fpID))
		afterTime = time.clock()

		memcacheRetrieval1 = (afterTime - beforeTime)/1000

		logging.info("First Round of tests done. ")
		logging.info("Results: Datastore: %s Memcache: %s" % (str(datastoreRetrieval1),str(memcacheRetrieval1)))
		
		#Add 100,000 entries to the datastore and construct the entity that will be placed into the memcache
		logging.info("Creating 100,000 Datastore entities")
		memPins = []
		for i in range(0,100000):
			pins = Pins(parent = app_key(), lat= 1.1, lon= 1.2)
			memPins.append(pins)
			pins.put()
			setData(str(fpID),pins)
		logging.info("Finished creating 100,000 datastore entities")

		
		#Now time how long it takes to retrieve a pin	
		#From the datastore
		beforeTime = time.clock()
		for i in range(0,1000):
			Pins.by_id(fpID)
		afterTime = time.clock()
		datastoreRetrieval2 = (afterTime - beforeTime)/1000
		
		#From the memcache
		beforeTime = time.clock()
		for i in range(0,1000):
			getData(str(fpID))
		afterTime = time.clock()
		memcacheRetrieval2 = (afterTime - beforeTime)/1000

		logging.info("Second Round of tests done. ")
		logging.info("Results: Datastore: %s Memcache %s" % (str(datastoreRetrieval2),str(memcacheRetrieval2)))
		
		#Now we need to know how long it takes to serialize and deserialize the memcache
		f = open('datafile','w')
		beforeTime = time.clock()
		pickle.dump(memPins,f)
		afterTime = time.clock()
		timeToSerialize = beforeTime - afterTime

		a = open('datafile','r')
		beforeTime = time.clock()
		pickle.load(a)
		afterTime = time.clock()
		timeToLoad = beforeTime - time.clock()

		#Display results in log
		logging.info("Serialization Test Complete")
		logging.info("Writing: %s " % str(timeToSerialize))
		logging.info("Reading: %s " % str(timeToLoad))

