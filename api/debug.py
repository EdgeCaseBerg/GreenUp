import webapp2
import json

import logging

from constants import *

from datastore import AbstractionLayer

#For extensions add to this list, or abstract to some type of properties file

class Debug(webapp2.RequestHandler):

	def get(self):
		#Default status if none are set
		self.response.set_status(HTTP_OK,"")

		
		response="{\"status_code\" : \"%s\", \"messages\" :  []}"

		#Send out the response
		self.response.set_status(HTTP_OK,"")
		self.response.write(json.dumps(response))	

	def post(self):
		self.response.set_status(HTTP_OK,"")

		#Confirm that all elements of the json are there.
		try:
			json.loads(self.request.body)
		except Exception, e:
			#The request body is malformed. 
			self.response.set_status(HTTP_REQUEST_SYNTAX_PROBLEM,"")
			self.response.write('{"Error_Message" : "Request body is malformed"}')
			#Don't allow execution to proceed any further than this
			return
		info = json.loads(self.request.body)

		#Request is well formed, but does it hold the proper semantic meaning for us? (all keys present)
		try:
			info['Error_Message']
		except Exception, e:
			#The request body lacks proper keys
			self.response.set_status(HTTP_REQUEST_SEMANTICS_PROBLEM)
			self.response.write(json.dumps({"Error_Message" : "Required keys not present in request"}))
			return

		#Do things here

		self.response.write('{ "status" : %i, "message" : "Successfuly submitted new comment" }' % HTTP_OK)

		

application = webapp2.WSGIApplication([
    ('/api/debug', Debug),

], debug=True)