#Import google sign in
from handlerBase import Handler
from datastore import *

import webapp2

class API(webapp2.RequestHandler):

	def get(self):
		#Display API information
		info = json.dumps({"version" : 1.00, "powered by" : "Xenon Apps"})
		self.response.set_status(200,info)
		self.response.out.write(info)

		
#This is the catch all #('.*', API)
application = webapp2.WSGIApplication([
										('/', API), 
										('/MakeDatastoreTest', MakeDatastoreTest),
										('/DisplayDatastoreTest', DisplayDatastoreTest),
									], debug=True)