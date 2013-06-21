#Import google sign in
from google.appengine.ext import db


import webapp2
import json

class API(webapp2.RequestHandler):

	def get(self):
		#Display API information
		info = json.dumps({"version" : 1.00, "powered by" : "Xenon Apps"})
		self.response.set_status(200,info)
		self.response.write(info)	

		

application = webapp2.WSGIApplication([
    ('.*', API),

], debug=True)