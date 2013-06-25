import webapp2
import json

import api
import logging

#For extensions add to this list, or abstract to some type of properties file
COMMENT_TYPES = ['FORUM', 'NEEDS', 'MESSAGE','']
RESOURCE_PATH = "comments"

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
				pass
			else:
				#Semantically incorrect query
				self.response.set_status(api.HTTP_REQUEST_SEMANTICS_PROBLEM,'{ "Error_Message" : "Unrecognized type"} ')
				self.response.write('{}')
				return
		#Check for other optional parameter:
		page = self.request.get("page")
		if page:
			#We have a paging parameter, is it well formed?
			try:
				int(page)
				page = int(page)
			except Exception, e:
				#Poorly formed page parameter
				self.response.set_status(api.HTTP_REQUEST_SEMANTICS_PROBLEM,'{"Error_Message" : "Non-integer page value not allowed"}')
				self.response.write('{}')
				return
		else:
			#No page given, so start it off
			page = 1
		#If we're here we have (possibly) a comment type and a page to retrieve

		#After retrieving the page we need to send back pagination information as well
		previous = None
		if page == 1:
			#There is no previous
			pass
		else:
			previous = "%s%s%s%s%s%s%i" % (api.BASE_URL,api.CONTEXT_PATH,RESOURCE_PATH,'?type=',commentType,'&page=',page -1)
		next = "%s%s%s%s%s%s%i" % (api.BASE_URL,api.CONTEXT_PATH,RESOURCE_PATH,'?type=',commentType,'&page=',page +1)

		#write out the comments in json form
		comments = []
		response = { "comments" : comments, "page" : {"next" : next, "previous" : previous}}
		

		#Send out the response
		self.response.set_status(api.HTTP_OK,"")
		self.response.write(json.dumps(response))	

	def post(self):
		self.response.set_status(api.HTTP_NOT_IMPLEMENTED,"")

		#Confirm that all elements of the json are there.
		logging.info(self.request.body)
		try:
			json.loads(self.request.body)
		except Exception, e:
			#The request body is malformed. 
			self.response.set_status(api.HTTP_REQUEST_SYNTAX_PROBLEM,"")
			self.response.write('{"Error_Message" : "Request body is malformed"}')
			#Don't allow execution to proceed any further than this
			return
		info = json.loads(self.request.body)

		#Request is well formed, but does it hold the proper semantic meaning for us? (all keys present)
		try:
			info['type']
			info['message']
		except Exception, e:
			#The request body lacks proper keys
			self.response.set_status(api.HTTP_REQUEST_SEMANTICS_PROBLEM,"")
			self.response.write('{"Error_Message" : "Required keys not present in request"}')
			return

		#Request has proper required keys
		typeOfComment = info['type']
		commentMessage = info['message']

		#Determine if type is semantically correct
		if typeOfComment.upper() in COMMENT_TYPES:
			pass
		else:
			self.response.set_status(api.HTTP_REQUEST_SEMANTICS_PROBLEM,"")
			self.response.write('{ "Error_Message" : "Unrecognized Type" }')
			return


		pin = None
		try:
			info['pin']
			pin = int(info['pin'])
		except Exception, e:
			#Die silently if the pine is not there as it is optional
			pass
		
		#All information present and valid. Store information in the database
		

		self.response.write("{}")

		

application = webapp2.WSGIApplication([
    ('/api/comments', Comments),

], debug=True)