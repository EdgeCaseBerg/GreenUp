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

class Campaign(db.Model):
	pass
class Greenup(Campaign):
	@classmethod
	def populate(cls, numvalues):
		logging.info('got here')

	@classmethod
	def app_key():
	    return db.Key.from_path('apps', 'greenup')

class Pins(Greenup):
	message = db.TextProperty()
	pinType = db.StringProperty(choices=('General Message', 'Help Needed', 'Trash Pickup'))
	lat = db.FloatProperty()
	lon = db.FloatProperty()
	latOffset = db.FloatProperty()
	lonOffset = db.FloatProperty()
	precision = db.FloatProperty()

class Comments(Greenup):
	commentType = db.StringProperty(choices=('General Message', 'Help Needed', 'Trash Pickup'))
	message = db.TextProperty()
	timeSent = db.DateTimeProperty(auto_now_add = True)	
	pin = db.ReferenceProperty(Pins, collection_name ='pins')

class GridPoints(Greenup):
	lat = db.FloatProperty()
	lon = db.FloatProperty()
	secondsWorked = db.FloatProperty()

