#Import google sign in
from google.appengine.ext import db

import webapp2
import json

import api



class Heatmap(webapp2.RequestHandler):

	def get(self):
		#TODO
		self.response.set_status(api.HTTP_NOT_IMPLEMENTED,"")

		#Attempt to load optional parameters
		latDegrees = self.request.get("latDegrees")
		lonDegrees = self.request.get("lonDegrees")
		latOffset = self.request.get("latOffset")
		lonOffset = self.request.get("lonOffset")
		precision = api.DEFAULT_ROUNDING_PRECISION
		if self.request.get("precision"):
			precision = self.request.get("precision")
		
		#validate parameters
		try:
			#Check that latDegrees is within the correct range and is numeric. throw syntax on numeric error, semantic on range
		except Exception, e:
			raise
		else:
			pass
		finally:
			pass



		
		self.response.write("{}")	

	def put(self):
		#TODO
		self.response.set_status(api.HTTP_NOT_IMPLEMENTED,"")
		self.response.write("{}")

		

application = webapp2.WSGIApplication([
    ('/api/heatmap', Heatmap),

], debug=True)