#Import google sign in
from google.appengine.ext import db

import webapp2
import json

import api
from constants import *
from  datastore import *

import logging


class Heatmap(webapp2.RequestHandler):

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
					raise api.SemanticError("latDegrees must be within the range of -180.0 and 180.0")
				parameters+= 1
			except ValueError, v:
				#Syntactic error
				self.response.set_status(api.HTTP_REQUEST_SYNTAX_PROBLEM)
				self.response.write('{"Error_Message" : "latDegrees parameter must be numeric"}')
				return
			except api.SemanticError, s:
				self.response.set_status(api.HTTP_REQUEST_SEMANTICS_PROBLEM,s.message)
				self.response.write('{"Error_Message" : "%s"}' % s.message)
				return
		

		if lonDegrees:
			try:
				float(lonDegrees)
				#check range
				lonDegrees = float(lonDegrees)
				if lonDegrees < -90.0 or lonDegrees > 90.0:
					raise api.SemanticError("lonDegrees must be within the range of -180.0 and 180.0")
				parameters+=1
			except ValueError, v:
				self.response.set_status(api.HTTP_REQUEST_SYNTAX_PROBLEM)
				self.response.write('{"Error_Message" : "%s" }' % "lonDegrees parameter must be numeric")
				return
			except api.SemanticError, s:
				self.response.set_status(api.HTTP_REQUEST_SEMANTICS_PROBLEM,s.message)
				self.response.write('{ "Error_Message" : "%s" }' % s.message)
				return
				
		
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
				return

		
		#Check precision
		if precision:
			try:
				precision = abs(int(precision))
				parameters += 1
			except ValueError, e:
				self.response.set_status(api.HTTP_REQUEST_SYNTAX_PROBLEM)
				self.response.write('{"Error_Message" : "Precision value must be a numeric integer" '  )
				return
			else:
				precision = api.DEFAULT_ROUNDING_PRECISION
		else:
			precision = api.DEFAULT_ROUNDING_PRECISION
				

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
				response = GridPoints.by_lat(latDegrees)
				if not response:
					response = []
			elif not lonOffset and lonDegrees and not latDegrees:
				#Only specified lonDegrees
				lonDegrees = round(lonDegrees,precision)
				response = GridPoints.by_lon(lonDegrees)
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
					#Only precision passed perform query for full grid with precision
					pass
				else:
					self.response.set_status(api.HTTP_REQUEST_SEMANTICS_PROBLEM)
					self.response.write('{"Error_Message" : "Improperly formed query, if offsets or precision specified, at least one degree must be given"}')
					return


		#By this point we have a response and we simply have to send it back
		self.response.set_status(api.HTTP_OK)
		self.response.write(json.dumps(response))	

	def put(self):
		#Check for the existence of required parameters
		try:
			json.loads(self.request.body)
		except Exception, e:
			#The request body is malformed. 
			self.response.set_status(api.HTTP_REQUEST_SYNTAX_PROBLEM,"")
			self.response.write('{"Error_Message" : "Request body is malformed"}')
			#Don't allow execution to proceed any further than this
			return
		info = json.loads(self.request.body)


		#For each pin we recieve we will enter them into the database. If any pins are malformed then no pointss are added
		points = []
		for i in range(len(info)):
			try:
				info[i]["latDegrees"]
				info[i]["lonDegrees"]
				info[i]["secondsWorked"]
			except Exception, e:
				#Request does not have proper keys
				self.response.set_status(api.HTTP_REQUEST_SYNTAX_PROBLEM,"")
				self.response.write('{"Error_Message" : "Required keys not present in request"}')
				return
			


			latDegrees = info[i]["latDegrees"]
			lonDegrees = info[i]["lonDegrees"]
			secondsWorked = info[i]["secondsWorked"]

			if latDegrees is None or lonDegrees is None or secondsWorked is None:
				self.response.set_status(api.HTTP_REQUEST_SEMANTICS_PROBLEM)
				self.response.write('{"Error_Message" : "Cannot accept null data for required parameters" }')
				return

			try:
				latDegrees = float(latDegrees)
				if latDegrees < -180.0 or latDegrees > 180.0:
					raise api.SemanticError("latDegrees must be within the range of -180.0 and 180.0")
			except ValueError, e:
				self.response.set_status(api.HTTP_REQUEST_SYNTAX_PROBLEM)
				self.response.write('{"Error_Message" : "latDegrees parameter must be numeric" }')
				return
			except api.SemanticError, s:
				self.response.set_status(api.HTTP_REQUEST_SEMANTICS_PROBLEM)
				self.response.write('{"Error_Message" : "%s" } ' % s.message)
				return

			try:
				lonDegrees = float(lonDegrees)
				if lonDegrees <  -90.0 or lonDegrees > 90.0:
					raise api.SemanticError("Longitude degrees must be within the range of -90 to 90 degree")
			except ValueError, e:
				self.response.set_status(api.HTTP_REQUEST_SYNTAX_PROBLEM)
				self.response.write('{"Error_Message" : "lonDegrees parameter must be numeric" }')
				return
			except api.SemanticError, s:
				self.response.set_status(api.HTTP_REQUEST_SEMANTICS_PROBLEM)
				self.response.write('{"Error_Message" : "%s"  }' % s.message)
				return

			try:
				secondsWorked = int(secondsWorked)
				if secondsWorked < 0:
					raise api.SemanticError("Seconds worked must be a non negative unsigned integer value")
			except ValueError, e:
				self.response.set_status(api.HTTP_REQUEST_SYNTAX_PROBLEM)
				self.response.write('{"Error_Message" : "Seconds worked must be an unsigned integer value" }')
				return
			except api.SemanticError, s:
				self.response.set_status(api.HTTP_REQUEST_SEMANTICS_PROBLEM)
				self.response.write('{"Error_Message" : "%s"  }' % s.message)
				return

			#All required parameters are here and validated.
			#Add it to the list of points to be added
			points.append(info[i])

		#Add all points to datastore
		logging.info(info)
		for point in points:
			pass


		self.response.set_status(api.HTTP_OK)
		self.response.write('{"status": %i, "message" : "Successful submit" }' % api.HTTP_OK)

		

application = webapp2.WSGIApplication([
    ('/api/heatmap', Heatmap),

], debug=True)