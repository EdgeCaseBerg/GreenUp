from google.appengine.ext import db
from constants import *
from greenup import * 

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


