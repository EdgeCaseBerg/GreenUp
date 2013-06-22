#Import google sign in
from google.appengine.ext import db
from handlerBase import *

import webapp2

class API(Handler):

	def get(self):
		#Display API information
		info = json.dumps({"version" : 1.00, "powered by" : "Xenon Apps"})
		self.response.set_status(200,info)
		self.response.write(info)	

		
#This is the catch all
application = webapp2.WSGIApplication([
    ('.*', API),

], debug=True)