from google.appengine.ext import db
from constants import *
from greenup import * 

class GridPoints(Greenup):
	lat = db.FloatProperty()
	lon = db.FloatProperty()
	secondsWorked = db.IntegerProperty()

	@classmethod
	def by_id(cls, gridId):
		return GridPoints.get_by_id(gridId, parent = Greenup.app_key())

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