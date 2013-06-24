#Import google sign in
from google.appengine.ext import db

import webapp2
import json

import api



class Heatmap(webapp2.RequestHandler):

	def get(self):
		#TODO
		self.response.set_status(api.HTTP_NOT_IMPLEMENTED,"")
		self.response.write("{}")	

	def put(self):
		#TODO
		self.response.set_status(api.HTTP_NOT_IMPLEMENTED,"")
		self.response.write("{}")

		

application = webapp2.WSGIApplication([
    ('/api/heatmap', Heatmap),

], debug=True)