#Import google sign in
from google.appengine.ext import db

import webapp2
import json
import api

from datastore import Pins as DBPins
from constants import *
from datastore import *

import logging

class Pins(webapp2.RequestHandler):

	def get(self):
		parameters = 0

		#load optional parameters
		latDegrees = self.request.get("latDegrees")
		lonDegrees = self.request.get("lonDegrees")
		latOffset = self.request.get("latOffset")
		lonOffset = self.request.get("lonOffset")
		
		if latDegrees == "":
			latDegrees = None
		if lonDegrees == "":
			lonDegrees = None
		if lonOffset == "":
			lonOffset = None
		if latOffset == "":
			latOffset = None

		#validate parameters
		if latDegrees:
			try:
				#Check that latDegrees is within the correct range and is numeric. throw syntax on numeric error, semantic on range
				float(latDegrees)
				#check range
				latDegrees = float(latDegrees)
				if latDegrees < -90.0 or latDegrees > 90.0:
					raise SemanticError("latDegrees must be within the range of -90.0 and 90.0")
				parameters+= 1
			except ValueError, v:
				#Syntactic error
				self.response.set_status(HTTP_REQUEST_SYNTAX_PROBLEM)
				self.response.write(ERROR_STR % (HTTP_REQUEST_SYNTAX_PROBLEM, "latDegrees parameter must be numeric"))
				return
			except SemanticError, s:
				self.response.set_status(HTTP_REQUEST_SEMANTICS_PROBLEM,s.message)
				self.response.write(ERROR_STR % (HTTP_REQUEST_SEMANTICS_PROBLEM, s.message))
				return
		

		if lonDegrees:
			try:
				float(lonDegrees)
				#check range
				lonDegrees = float(lonDegrees)
				if lonDegrees < -180.0 or lonDegrees > 180.0:
					raise SemanticError("lonDegrees must be within the range of -180.0 and 180.0")
				parameters+=1
			except ValueError, v:
				self.response.set_status(HTTP_REQUEST_SYNTAX_PROBLEM)
				self.response.write(ERROR_STR % (HTTP_REQUEST_SYNTAX_PROBLEM, "lonDegrees parameter must be numeric"))
				return
			except SemanticError, s:
				self.response.set_status(HTTP_REQUEST_SEMANTICS_PROBLEM,s.message)
				self. response.write(ERROR_STR % (HTTP_REQUEST_SEMANTICS_PROBLEM, s.message))
				return
				
		
		#Check offsets
		#If one offset is present the other must be too
		#It'd be great if python had XOR for objects instead of just bitwise ^
		if (lonOffset and not latOffset) or (latOffset and not lonOffset):
			self.response.set_status(HTTP_REQUEST_SEMANTICS_PROBLEM)
			self.response.write(ERROR_STR % (HTTP_REQUEST_SEMANTICS_PROBLEM, "Both lonOffset and latOffset must be present if either is used"))
			return

		#the choice of lon is arbitrary, either lat or lon offset would work here
		if lonOffset:
			try:
				lonOffset = abs(float(lonOffset))
				latOffset = abs(float(latOffset))
				parameters+=2
				#We could check to see if the offsets cause us to go out of range for our queries, but really that's unneccesary and would cause unneccesary calculation on the clientside to deal making sure they're within range.
			except ValueError, e:
				self.response.set_status(HTTP_REQUEST_SYNTAX_PROBLEM)
				self.response.write(ERROR_STR % (HTTP_REQUEST_SYNTAX_PROBLEM, "Offsets defined must both be numeric"))
				return

		#If no parameters are specified we'll return everything we have for them
		response = []
		layer = AbstractionLayer()
		#Return data
		response = layer.getPins(latDegrees=latDegrees, latOffset=latOffset, lonDegrees=lonDegrees, lonOffset=lonOffset)
		#By this point we have a response and we simply have to send it back
		self.response.set_status(HTTP_OK)
		self.response.write(json.dumps({'status_code' : HTTP_OK, 'pins' : response}))

	def post(self):
		self.response.set_status(HTTP_OK)

		try:
			json.loads(self.request.body)
		except Exception, e:
			#The request body is malformed. 
			self.response.set_status(HTTP_REQUEST_SYNTAX_PROBLEM)
			self.response.write(ERROR_STR % (HTTP_REQUEST_SYNTAX_PROBLEM, "Request body is malformed"))
			#Don't allow execution to proceed any further than this
			return
		info = json.loads(self.request.body)

		try:
			info['latDegrees']
			info['lonDegrees']
			info['type']
			info['message']
			info['addressed']
		except Exception, e:
			#Improper request
			self.response.set_status(HTTP_REQUEST_SYNTAX_PROBLEM)
			self.response.write(ERROR_STR % (HTTP_REQUEST_SYNTAX_PROBLEM, "Required keys not present in request"))
			return
		
		pinType = info['type']
		latDegrees = info['latDegrees']
		lonDegrees = info['lonDegrees']
		message = info['message']
		addressed = info['addressed']

		#Catch nulls
		if pinType is None or latDegrees is None or lonDegrees is None or message is None:
			self.response.set_status(HTTP_REQUEST_SEMANTICS_PROBLEM)
			self.response.write(ERROR_STR % (HTTP_REQUEST_SEMANTICS_PROBLEM, "Cannot accept null data for required parameters"))
			return

		if addressed is None or addressed == "":
			addressed = False
		else:
			if addressed:
				addressed = True
			else:
				addressed = False

		#Determine if the type is correct:
		if pinType.upper() not in PIN_TYPES:
			self.response.set_status(HTTP_REQUEST_SEMANTICS_PROBLEM)
			self.response.write('{"status_code" : %i, "Error_Message" : "Pin type not a valid type." }' % HTTP_REQUEST_SEMANTICS_PROBLEM)
			return

		#Determine if lat Degrees and lon degrees are within the proper range and numeric
		try:
			latDegrees = float(latDegrees)
			if latDegrees  < -180.0 or latDegrees > 180.0:
				raise SemanticError("Lat degrees must be within the range between -180.0 and 180.0")
		except ValueError, e:
			self.response.set_status(HTTP_REQUEST_SYNTAX_PROBLEM)
			self.response.write(Error_Message % (HTTP_REQUEST_SYNTAX_PROBLEM, "Lat degrees must be a numeric value"))
			return
		except SemanticError,s:
			self.response.set_status(HTTP_REQUEST_SEMANTICS_PROBLEM)
			self.response.write(ERROR_STR % (HTTP_REQUEST_SEMANTICS_PROBLEM, s.message))
			return
		
		#do the same thing for lon degrees
		try:
			lonDegrees = float(lonDegrees)
			if lonDegrees < -180.0 or lonDegrees > 180.0:
				raise SemanticError("Lon degrees must be within the range of -180.0 and 180.0")
		except ValueError, e:
			self.response.set_status(HTTP_REQUEST_SYNTAX_PROBLEM)
			self.response.write(ERROR_STR % (HTTP_REQUEST_SYNTAX_PROBLEM, "Lon degrees must be a numeric value"))
			return
		except SemanticError, s:
			self.response.set_status(HTTP_REQUEST_SEMANTICS_PROBLEM)
			self.response.write(ERROR_STR % (HTTP_REQUEST_SEMANTICS_PROBLEM, s.message))
			return

		#Verify the message is not empty
		if message.lstrip().rstrip() == '':
			self.response.set_status(HTTP_REQUEST_SEMANTICS_PROBLEM)
			self.response.write(ERROR_STR % (HTTP_REQUEST_SEMANTICS_PROBLEM, "Pin message may not be empty."))
			return

		#Place the pin into the datastore
		layer = AbstractionLayer()
		pid = layer.submitPin(latDegrees=latDegrees, lonDegrees=lonDegrees, pinType=pinType.upper(), message=message,addressed=addressed)

		#self.response.set_status(HTTP_OK)		
		self.response.write('{  "pin_id" : %i,  "status_code" : 200,  "message" : "Successful submit"}' % pid)

	def put(self):
		#expecting a put request like: /api/pins?id=id with http body of {"address" : True|False}
		self.response.set_status(HTTP_OK)

		try:
			json.loads(self.request.body)
		except Exception, e:
			#The request body is malformed. 
			self.response.set_status(HTTP_REQUEST_SYNTAX_PROBLEM)
			self.response.write(ERROR_STR % (HTTP_REQUEST_SYNTAX_PROBLEM, "Request body is malformed"))
			#Don't allow execution to proceed any further than this
			return
		info = json.loads(self.request.body)

		try:
			info['addressed']
		except Exception, e:
			#Improper request
			self.response.set_status(HTTP_REQUEST_SYNTAX_PROBLEM)
			self.response.write(ERROR_STR % (HTTP_REQUEST_SYNTAX_PROBLEM, "Required key 'addressed' not present in request body"))
			return

		addressed = info['addressed']


		pinID = self.request.get("id")
		if pinID is None or pinID == "":
			self.response.set_status(HTTP_REQUEST_SEMANTICS_PROBLEM)
			self.response.write(ERROR_STR % (HTTP_REQUEST_SEMANTICS_PROBLEM, "Required key id not present in request url"))
			return

		try:
			pinId = int(pinID)
		except Exception, e:
			self.response.set_status(HTTP_REQUEST_SEMANTICS_PROBLEM)
			self.response.write(ERROR_STR % (HTTP_REQUEST_SEMANTICS_PROBLEM, "id must be a numeric identifier"))
			return

		#Now go find the pin and update it!
		layer = AbstractionLayer()
		if layer.addressPin(int(pinID), addressed):
			self.response.set_status(HTTP_OK)
			self.response.write('{ "status_code" : 200,  "message" : "Successful"}')
		else:
			self.response.set_status(HTTP_NOT_FOUND)
			self.response.write(ERROR_STR % (HTTP_NOT_FOUND, "Id not found and pin not updated"))

				
	def delete(self):
		#responds to DELETE /api/pins?id=<id number> 
		pinID = self.request.get("id")
		if pinID is None or pinID == "":
			self.response.set_status(HTTP_REQUEST_SEMANTICS_PROBLEM)
			self.response.write(ERROR_STR % (HTTP_REQUEST_SEMANTICS_PROBLEM, "Required key id not present in request url"))
			return

		try:
			pinId = int(pinID)
		except Exception, e:
			self.response.set_status(HTTP_REQUEST_SEMANTICS_PROBLEM)
			self.response.write(ERROR_STR % (HTTP_REQUEST_SEMANTICS_PROBLEM, "id must be a numeric identifier"))
			return

		layer = AbstractionLayer()
		if layer.deletePin(pinID):
			self.response.set_status(HTTP_DELETED)
			self.response.write('{ "status_code" : %i,  "message" : "Successful"}' % HTTP_DELETED)
		else:
			self.response.set_status(HTTP_NOT_FOUND)
			self.response.write(ERROR_STR % (HTTP_NOT_FOUND, "Id not found and pin not updated"))




		

application = webapp2.WSGIApplication([
    ('/api/pins', Pins),

], debug=True)