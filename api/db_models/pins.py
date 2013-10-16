from google.appengine.ext import db
from ..constants import *
from greenup import * 

class Pins(Greenup):
	message = db.TextProperty()
	pinType = db.StringProperty(choices=PIN_TYPES)
	# these must be stored precisely
	lat = db.FloatProperty()
	lon = db.FloatProperty()
	addressed = db.BooleanProperty()

	@classmethod
	def by_id(cls, pinId):
		return Pins.get_by_id(pinId, parent = Greenup.app_key())

	@classmethod
	def by_message(cls, message):
		bc = Pins.all().ancestor(Pins.app_key()).filter('message =', message).get()


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
