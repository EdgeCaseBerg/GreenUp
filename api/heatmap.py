#Import google sign in
from google.appengine.ext import db

import webapp2
import json

import api

class SemanticError(Exception):
	def __init__(self,message):
		self.message = message
	def __str__(self):
		return repr(self.message)

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
		if latDegrees:
			try:
				#Check that latDegrees is within the correct range and is numeric. throw syntax on numeric error, semantic on range
				float(latDegrees)
				#check range
				latDegrees = float(latDegrees)
				if latDegrees < -180.0 or latDegrees > 180.0:
					raise SemanticError("latDegrees must be within the range of -180.0 and 180.0")
			except ValueError, v:
				#Syntactic error
				self.response.set_status(api.HTTP_REQUEST_SYNTAX_PROBLEM)
				self.response.write('{"Error_Message" : "latDegrees parameter must be numeric"}')
				return
			except SemanticError, s:
				self.response.set_status(api.HTTP_REQUEST_SEMANTICS_PROBLEM,s.message)
				self.response.write('{"Error_Message" : "%s"}' % s.message)
				return

		if lonDegrees:
			try:
				float(lonDegrees)
				#check range
				lonDegrees = float(lonDegrees)
				if lonDegrees < -90.0 or lonDegrees > 90.0:
					raise SemanticError("lonDegrees must be within the range of -180.0 and 180.0")
			except ValueError, v:
				self.response.set_status(api.HTTP_REQUEST_SYNTAX_PROBLEM)
				self.response.write("{%s}" % "lonDegrees parameter must be numeric")
				return
			except SemanticError, s:
				self.response.set_status(api.HTTP_REQUEST_SEMANTICS_PROBLEM,s.message)
				self.response.write("{%s}" % s.message)
				return
		
		#Check offsets
		#If one offset is present the other must be too
		#It'd be great if python had XOR for objects instead of just bitwise ^
		if (lonOffset and not latOffset) or (latOffset and not lonOffset):
			self.response.set_status(api.HTTP_REQUEST_SEMANTICS_PROBLEM)
			self.response.write("%s" % "Both lonOffset and latOffset must be present if either is used")
			return

		#the choice of lon is arbitrary, either lat or lon offset would work here
		if lonOffset:
			try:
				lonOffset = int(lonOffset)
				latOffset = int(latOffset)
			except ValueError, e:
				self.response.set_status(api.HTTP_REQUEST_SYNTAX_PROBLEM)
				self.response.write('{"Error_Message" : "Offsets defined must both be integers" }')
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