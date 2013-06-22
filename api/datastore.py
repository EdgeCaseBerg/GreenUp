# datastore entities required by API.
# https://developers.google.com/appengine/docs/python/gettingstartedpython27/usingdatastore

from google.appengine.ext import db
from handlerBase import *
import logging 

def app_key(name = 'default'):
    return db.Key.from_path('things', name)

class Types(db.Model):
	'''
		What type of message/pin is being placed.
	'''
	description = db.StringProperty()

class GridPoints(db.Model):
	'''
		GridPoints contains the points of the map grid. 
	'''
	lat = db.FloatProperty()
	lon = db.FloatProperty()
	secondsWorked = db.FloatProperty()
	# maybe we need this, maybe we don't=> https://developers.google.com/appengine/docs/python/datastore/typesandpropertyclasses#GeoPtProperty
	geoPoint = db.GeoPtProperty()

class Comments(db.Model):
	'''
		A forum message with a particular type and timestamp, also optionally associated to a pin
		This may be of use:
			https://developers.google.com/appengine/docs/python/datastore/typesandpropertyclasses#ReferenceProperty
	'''
	message = db.TextProperty()
	timeSent = db.DateTimeProperty(auto_now_add = True)

class Pins(db.Model):
	'''
		Pins are latitude and longitude points on the map with a particular type and a comment associated with them.
	'''
	lat = db.FloatProperty()
	lon = db.FloatProperty()
	pinType = db.ReferenceProperty(Types)
	pinComment = db.ReferenceProperty(Comments)

# test the datastore
class MakeDatastoreTest(webapp2.RequestHandler):
	def get(self):
		self.response.write("write worked")

		# Set the same parent key on each entity to ensure consistent results and add some junk data
		types = Types(parent = app_key(), description = "General Message")
		gridPoints = GridPoints(parent = app_key(), lat = 1.0, lon = 2.0, secondsWorked = 10.0)
		comments = Comments(parent = app_key(), message = 'this is a message')
		pins = Pins(parent = app_key(), lat= 1.1, lon= 1.2)

		# put the junk data in the datastore
		types.put()
		gridPoints.put()
		comments.put()
		pins.put()

class DisplayDatastoreTest(webapp2.RequestHandler):
	def get(self):
		self.response.write("check logs for read")
		# types
		logging.info("## Types ##")
		types_query = Types.all()
		types_query.ancestor(app_key())

		for types in types_query.run():
			logging.info(types.description)

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