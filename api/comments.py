import webapp2
import json

import api


COMMENT_TYPES = ['FORUM', 'NEEDS', 'MESSAGE']

class Comments(webapp2.RequestHandler):

	def get(self):
		#Default status if none are set
		self.response.set_status(api.HTTP_NOT_IMPLEMENTED,"")

		#Check for optional parameters:
		commentType = self.request.get("type")
		if commentType:
			#We have an optional parameter. Is it well formed?
			if commentType.upper() in COMMENT_TYPES:
				#Yes it is well formed and we may execute a datastore query for the comments
				self.response.set_status(api.HTTP_OK,"")
			else:
				#Semantically incorrect query
				self.response.set_status(api.HTTP_REQUEST_SEMANTICS_PROBLEM,"")


		#TODO
		
		self.response.write("{}")	

	def post(self):
		#Confirm that all elements of the json are there.
		
		self.response.set_status(api.HTTP_NOT_IMPLEMENTED,"")
		self.response.write("{}")

		

application = webapp2.WSGIApplication([
    ('/api/comments', Comments),

], debug=True)