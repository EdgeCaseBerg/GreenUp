#Import google sign in
from handlerBase import Handler
from datastore import *

import webapp2

from constants import *

TESTING = True

if TESTING:
	from testHarness import *


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
										('/api/cacheTest', MemcacheVsDatastore),
										('/api/cacheView', MemecacheViewer)
									], debug=True)