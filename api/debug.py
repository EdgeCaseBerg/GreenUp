import webapp2
import json

import logging
import datetime

from constants import *

from datastore import AbstractionLayer

#For extensions add to this list, or abstract to some type of properties file

class Debug(webapp2.RequestHandler):

	def get(self):
		#Default status if none are set
		self.response.set_status(HTTP_OK,"")
		status_code = HTTP_OK

		since = self.request.get("since")
		msgHash = self.request.get("hash")
		page = self.request.get("page")


		if page is not None and msgHash is not None and not (page == "" or msgHash == ""):
			#Well this makes no sense. You can only do one! SEMATICS
			self.response.set_status(HTTP_REQUEST_SEMANTICS_PROBLEM,"")
			self.response.write(ERROR_STR % "Page and hash parameters are mutually exclusive")
			return

		if msgHash is not None and since is not None and msgHash != "":
			#No sense here either, but we can just ignore since in this case
			since = None

		#If we have a hash then we retrieve a single message by its hash
		if msgHash is not None:
			#Ask the abstraction layer for it and return it or a 404
			pass

		if page is not None and page != "":
			#If page is not none then we will retrieve the given page! Validate!
			try:
				int(page)
				page = abs(int(page))
			except Exception, e:
				self.response.set_status(HTTP_REQUEST_SEMANTICS_PROBLEM)
				self.response.write(ERROR_STR % "Non-integer page value not allowed")
				return
		else:
			page = 1
		
		#Next check the since parameter to see if we're using time at all
		if since is not None and since != "":
			try:
				since = datetime.datetime.strptime(since, SINCE_TIME_FORMAT)
				logging.info(since)
			except ValueError, ve:
				#Messed up your time format. syntax error 
				self.response.set_status(HTTP_REQUEST_SYNTAX_PROBLEM)
				self.response.write(ERROR_STR % "The since datetime format could not be parsed. Please use YYYY-mm-dd-HH:MM with military time.")
				return
		else:
			#Since is nothing
			since = ""


		#If we've made it this far it means we have a page and possibly a time to filter with
		#Pass that down to the abstraction layer and let it return the messages to us
		messages = []

		
		prevPage = page -1 if page != 1 else 1
		response={"status_code" : "%s" % status_code, "messages" :  messages "page" : { "next" : "%s%s%s?page=%i&since=%s"% (BASE_URL,CONTEXT_PATH,DEBUG_RESOURCE_PATH,page+1,since.strftime(SINCE_TIME_FORMAT)), "previous" : "%s%s%s?page=%i&since=%s"%(BASE_URL,CONTEXT_PATH,DEBUG_RESOURCE_PATH,prevPage,since.strftime(SINCE_TIME_FORMAT))}}

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
			self.response.write(ERROR_STR % "Request body is malformed")
			#Don't allow execution to proceed any further than this
			return
		info = json.loads(self.request.body)

		#Request is well formed, but does it hold the proper semantic meaning for us? (all keys present)
		try:
			info['Error_Message']
		except Exception, e:
			#The request body lacks proper keys
			self.response.set_status(HTTP_REQUEST_SEMANTICS_PROBLEM)
			self.response.write(ERROR_STR % "Required keys not present in request")
			return

		#Do things here

		self.response.write('{ "status" : %i, "message" : "Successfuly submitted new comment" }' % HTTP_OK)

		

application = webapp2.WSGIApplication([
    ('/api/debug', Debug),

], debug=True)