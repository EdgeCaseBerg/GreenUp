#Import google sign in
from handlerBase import Handler
from datastore import *

import comments
import heatmap
import pins


import webapp2

""" Constants for use in response codes declared here """
HTTP_NOT_IMPLEMENTED = 503
HTTP_OK = 200
HTTP_REQUEST_SEMANTICS_PROBLEM = 422
HTTP_REQUEST_SYNTAX_PROBLEM = 400

""" Constants for domain name and fully qualified http urls"""
BASE_URL = "http://localhost:30002"
CONTEXT_PATH = "/api"

class API(webapp2.RequestHandler):

	def get(self):
		#Display API information
		info = json.dumps({"version" : 1.00, "powered by" : "Xenon Apps"})
		self.response.set_status(200,info)
		self.response.out.write(info)

		
#This is the catch all #('.*', API)
application = webapp2.WSGIApplication([
										('/api/heatmap',heatmap.Heatmap),
										('/api/pins',Pins),
										('/api/comments',Comments),
										('/api', API), 
										('/MakeDatastoreTest', MakeDatastoreTest),
										('/DisplayDatastoreTest', DisplayDatastoreTest),
									], debug=True)