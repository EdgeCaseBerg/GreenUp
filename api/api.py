#Import google sign in
from handlerBase import Handler
from datastore import *

import webapp2

TESTING = True

if TESTING:
	from testHarness import *

""" Constants for use in response codes declared here """
HTTP_NOT_IMPLEMENTED = 503
HTTP_OK = 200
HTTP_REQUEST_SEMANTICS_PROBLEM = 422
HTTP_REQUEST_SYNTAX_PROBLEM = 400

""" Constants for domain name and fully qualified http urls"""
BASE_URL = "http://greenup.xenonapps.com"
CONTEXT_PATH = "/api"

""" Miscellaneous Constants """
DEFAULT_ROUNDING_PRECISION = 6


""" Error to throw on a sematic error in a request """
class SemanticError(Exception):
	def __init__(self,message):
		self.message = message
	def __str__(self):
		return repr(self.message)

class API(Handler):

	def get(self):
		#Display API information
		info = json.dumps({"version" : 1.00, "powered by" : "Xenon Apps"})
		self.response.set_status(200,info)
		self.write(info)

		
#This is the catch all #('.*', API)
application = webapp2.WSGIApplication([
										('/api', API), 
										('/api/writeTest', WriteTest),
										('/api/readTest', ReadTest),
										('/api/cacheTest',MemcacheVsDatastore)
									], debug=True)