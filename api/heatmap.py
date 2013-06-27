#Import google sign in
from google.appengine.ext import db

import webapp2
import json

import api
import datastore



class Heatmap(webapp2.RequestHandler):

	def get(self):
		#TODO
		self.response.set_status(api.HTTP_NOT_IMPLEMENTED,"")

		parameters = 0

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
					raise api.SemanticError("latDegrees must be within the range of -180.0 and 180.0")
			except ValueError, v:
				#Syntactic error
				self.response.set_status(api.HTTP_REQUEST_SYNTAX_PROBLEM)
				self.response.write('{"Error_Message" : "latDegrees parameter must be numeric"}')
				return
			except api.SemanticError, s:
				self.response.set_status(api.HTTP_REQUEST_SEMANTICS_PROBLEM,s.message)
				self.response.write('{"Error_Message" : "%s"}' % s.message)
				return
			else:
				parameters+= 1

		if lonDegrees:
			try:
				float(lonDegrees)
				#check range
				lonDegrees = float(lonDegrees)
				if lonDegrees < -90.0 or lonDegrees > 90.0:
					raise api.SemanticError("lonDegrees must be within the range of -180.0 and 180.0")
			except ValueError, v:
				self.response.set_status(api.HTTP_REQUEST_SYNTAX_PROBLEM)
				self.response.write('{"Error_Message" : "%s" }' % "lonDegrees parameter must be numeric")
				return
			except api.SemanticError, s:
				self.response.set_status(api.HTTP_REQUEST_SEMANTICS_PROBLEM,s.message)
				self.response.write('{ "Error_Message" : "%s" }' % s.message)
				return
			else:
				parameters+=1
		
		#Check offsets
		#If one offset is present the other must be too
		#It'd be great if python had XOR for objects instead of just bitwise ^
		if (lonOffset and not latOffset) or (latOffset and not lonOffset):
			self.response.set_status(api.HTTP_REQUEST_SEMANTICS_PROBLEM)
			self.response.write('{"Error_Message" : "%s"}' % "Both lonOffset and latOffset must be present if either is used")
			return

		#the choice of lon is arbitrary, either lat or lon offset would work here
		if lonOffset:
			try:
				lonOffset = abs(int(lonOffset))
				latOffset = abs(int(latOffset))
				parameters+=2
				#We could check to see if the offsets cause us to go out of range for our queries, but really that's unneccesary and would cause unneccesary calculation on the clientside to deal making sure they're within range.
			except ValueError, e:
				self.response.set_status(api.HTTP_REQUEST_SYNTAX_PROBLEM)
				self.response.write('{"Error_Message" : "Offsets defined must both be integers" }')

		#Check precision
		if precision:
			try:
				precision = abs(int(precision))
			except ValueError, e:
				self.response.set_status(api.HTTP_REQUEST_SYNTAX_PROBLEM)
				self.response.write('{"Error_Message" : "Precision value must be a numeric integer" '  )
			else:
				parameters += 1

		#If no parameters are specified we'll return everything we have for them
		response = None
		if parameters == 0:
			#Return everything
			response = []
		else:
			#Figure out what type of query to make depending on the parameters we have available
			if not lonOffset and latDegrees and not lonDegrees:
				#Only specified latDegrees
				#Round latDegrees by precision value:
				latDegrees = round(latDegrees,precision) 
				response = GridPoints.by_lat(latDegrees)
			elif not lonOffset and lonDegrees and not latDegrees:
				#Only specified lonDegrees
				lonDegrees = round(lonDegrees,precision)
				response = GridPoints.by_lon(lonDegrees)
			elif not lonOffset and latDegrees and lonDegrees:
				#We have both lon and lat degrees
				lonDegrees = round(lonDegrees,precision)
				latDegrees = round(latDegrees,precision)
				pass
				#Do query for both (not implemented yet)
			elif lonOffset and ((latDegrees and not lonDegrees) or (not latDegrees and lonDegrees)):
				#Do query for degrees with offsets
				if latDegrees:
					#Do query for latitude with an offset
					pass
				elif lonDegrees:
					#Do query for longitude with an offset
					pass
				pass
			elif lonOffset and latDegrees and lonDegrees:
				#We have offsets and both degrees, fire off the bounds request
				pass
			else:
				#No degrees specified and offsets or just precision?
				#This is a bad request.
				self.response.set_status(api.HTTP_REQUEST_SEMANTICS_PROBLEM)
				self.response.write('{"Error_Message" : "Improperly formed query, if offsets or precision specified, at least one degree must be given"}')






		
		self.response.write("{}")	

	def put(self):
		#TODO
		self.response.set_status(api.HTTP_NOT_IMPLEMENTED,"")
		self.response.write("{}")

		

application = webapp2.WSGIApplication([
    ('/api/heatmap', Heatmap),

], debug=True)