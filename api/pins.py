#Import google sign in
from google.appengine.ext import db

import webapp2
import json

from datastore import Pins as DBPins
from constants import *

class Pins(webapp2.RequestHandler):

	def get(self):
		parameters = 0

		#load optional parameters
		latDegrees = self.request.get("latDegrees")
		lonDegrees = self.request.get("lonDegrees")
		latOffset = self.request.get("latOffset")
		lonOffset = self.request.get("lonOffset")
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
				parameters+= 1
			except ValueError, v:
				#Syntactic error
				self.response.set_status(HTTP_REQUEST_SYNTAX_PROBLEM)
				self.response.write('{"Error_Message" : "latDegrees parameter must be numeric"}')
				return
			except SemanticError, s:
				self.response.set_status(HTTP_REQUEST_SEMANTICS_PROBLEM,s.message)
				self.response.write('{"Error_Message" : "%s"}' % s.message)
				return
		

		if lonDegrees:
			try:
				float(lonDegrees)
				#check range
				lonDegrees = float(lonDegrees)
				if lonDegrees < -90.0 or lonDegrees > 90.0:
					raise SemanticError("lonDegrees must be within the range of -180.0 and 180.0")
				parameters+=1
			except ValueError, v:
				self.response.set_status(HTTP_REQUEST_SYNTAX_PROBLEM)
				self.response.write('{"Error_Message" : "%s" }' % "lonDegrees parameter must be numeric")
				return
			except SemanticError, s:
				self.response.set_status(HTTP_REQUEST_SEMANTICS_PROBLEM,s.message)
				self.response.write('{ "Error_Message" : "%s" }' % s.message)
				return
				
		
		#Check offsets
		#If one offset is present the other must be too
		#It'd be great if python had XOR for objects instead of just bitwise ^
		if (lonOffset and not latOffset) or (latOffset and not lonOffset):
			self.response.set_status(HTTP_REQUEST_SEMANTICS_PROBLEM)
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
				self.response.set_status(HTTP_REQUEST_SYNTAX_PROBLEM)
				self.response.write('{"Error_Message" : "Offsets defined must both be integers" }')
				return

		
		#Check precision
		if precision:
			try:
				precision = abs(int(precision))
				parameters += 1
			except ValueError, e:
				self.response.set_status(HTTP_REQUEST_SYNTAX_PROBLEM)
				self.response.write('{"Error_Message" : "Precision value must be a numeric integer" '  )
				return
			else:
				precision = DEFAULT_ROUNDING_PRECISION
		else:
			precision = DEFAULT_ROUNDING_PRECISION	


		#If no parameters are specified we'll return everything we have for them
		response = []
		
		if parameters == 0:
			#Return everything
			response = []
		else:
			#Figure out what type of query to make depending on the parameters we have available
			if not lonOffset and latDegrees and not lonDegrees:
				#Only specified latDegrees
				#Round latDegrees by precision value:
				latDegrees = round(latDegrees,precision) 
				response = DBPins.by_lat(latDegrees)
				if not response:
					response = []
			elif not lonOffset and lonDegrees and not latDegrees:
				#Only specified lonDegrees
				lonDegrees = round(lonDegrees,precision)
				response = DBPins.by_lon(lonDegrees)
				if not response:
					response = []
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
				if parameters == 1:
					#Just precision
					pass
				else:
					#This is a bad request.
					self.response.set_status(HTTP_REQUEST_SEMANTICS_PROBLEM)
					self.response.write('{"Error_Message" : "Improperly formed query, if offsets or precision specified, at least one degree must be given"}')
					return


		#By this point we have a response and we simply have to send it back
		self.response.set_status(HTTP_OK)
		self.response.write(json.dumps(response))	

	def post(self):
		self.response.set_status(HTTP_OK)

		try:
			json.loads(self.request.body)
		except Exception, e:
			#The request body is malformed. 
			self.response.set_status(HTTP_REQUEST_SYNTAX_PROBLEM)
			self.response.write('{"Error_Message" : "Request body is malformed"}')
			#Don't allow execution to proceed any further than this
			return
		info = json.loads(self.request.body)

		try:
			info['latDegrees']
			info['lonDegrees']
			info['type']
			info['message']
		except Exception, e:
			#Improper request
			self.response.set_status(HTTP_REQUEST_SYNTAX_PROBLEM)
			self.response.write('{"Error_Message" : "Required keys not present in request"}')
			return
		
		pinType = info['type']
		latDegrees = info['latDegrees']
		lonDegrees = info['lonDegrees']
		message = info['message']

		#Catch nulls
		if pinType is None or latDegrees is None or lonDegrees is None or message is None:
			self.response.set_status(HTTP_REQUEST_SEMANTICS_PROBLEM)
			self.response.write('{"Error_Message" : "Cannot accept null data for required parameters" }')
			return

		#Determine if the type is correct:
		if pinType.upper() not in PIN_TYPES:
			self.response.set_status(HTTP_REQUEST_SEMANTICS_PROBLEM)
			self.response.write('{"Error_Message" : "Pin type not a valid type." }')
			return

		#Determine if lat Degrees and lon degrees are within the proper range and numeric
		try:
			latDegrees = float(latDegrees)
			if latDegrees  < -180.0 or latDegrees > 180.0:
				raise SemanticError("Lat degrees must be within the range between -180.0 and 180.0")
		except ValueError, e:
			self.response.set_status(HTTP_REQUEST_SYNTAX_PROBLEM)
			self.response.write('{"Error_Message" : "Lat degrees must be a numeric value" }')
			return
		except SemanticError,s:
			self.response.set_status(HTTP_REQUEST_SEMANTICS_PROBLEM)
			self.response.write('{"Error_Message" : "%s" }' % s.message)
			return
		
		#do the same thing for lon degrees
		try:
			lonDegrees = float(lonDegrees)
			if lonDegrees < -90.0 or lonDegrees > 90.0:
				raise SemanticError("Lon degrees must be within the range of -90.0 and 90.0")
		except ValueError, e:
			self.response.set_status(HTTP_REQUEST_SYNTAX_PROBLEM)
			self.response.write('{"Error_Message" : "Lon degrees must be a numeric value"}')
			return
		except SemanticError, s:
			self.response.set_status(HTTP_REQUEST_SEMANTICS_PROBLEM)
			self.response.write('{"Error_Message" : "%s"}' % s.message)
			return

		#Don't know what to do about the message. perhaps just escape it or something I guess?

		#Place the pin into the datastore
		

		#self.response.set_status(HTTP_OK)		
		self.response.write('{  "status" : 200,  "message" : "Successful submit"}')

		

application = webapp2.WSGIApplication([
    ('/api/pins', Pins),

], debug=True)