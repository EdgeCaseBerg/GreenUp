#Import google sign in
from google.appengine.ext import db


import webapp2
import json

class Comments(webapp2.RequestHandler):

	def get(self):
		#TODO
		self.response.set_status(200,"")
		self.response.write("")	

		

application = webapp2.WSGIApplication([
    ('/api/comments', Comments),

], debug=True)