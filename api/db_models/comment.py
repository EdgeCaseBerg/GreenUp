from google.appengine.ext import db
from ..constants import *
from greenup import * 
from pins import *

class Comments(Greenup):

	commentType = db.StringProperty(choices=COMMENT_TYPES)
	message = db.TextProperty()
	timeSent = db.DateTimeProperty(auto_now_add = True)	
	pin = db.ReferenceProperty(Pins, collection_name ='pins')

	@classmethod
	def by_id(cls, commentId):
		return Comments.get_by_id(commentId, parent = Comments.app_key())
	
	@classmethod
	def by_type(cls,cType):
		ct = Comments.all().ancestor(Comments.app_key()).filter('commentType =', cType).get()	
		return ct

	@classmethod
	def by_type_pagination(cls, cType):
		ct = Comments.all().ancestor(Comments.app_key()).filter('commentType =', cType)
		return ct
