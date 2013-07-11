# f=urllib.urlopen('http://greenupapi.appspot.com/api')
# >>> f.getcode()
# 200
# >>> print f.read()
# {"version": 1.0, "powered by": "Xenon Apps"}

import urllib2
import json
import logging
import numbers

from constants import *

class BetterHTTPErrorProcessor(urllib2.BaseHandler):
    # a substitute/supplement to urllib2.HTTPErrorProcessor
    # that doesn't raise exceptions on status codes 201,204,206
    def http_error_200(self, request, response, code, msg, hdrs):
        return response
    def http_error_400(self, request, response, code, msg, hdrs):
        return response
    def http_error_422(self, request, response, code, msg, hdrs):
        return response
    def http_error_503(self, request, response, code, msg, hdrs):
        return response

class Spider(object):
	def __init__(self):
		super(Spider, self).__init__()
		
	def followLink(self,link,withData={},httpMethod="GET"):
		opener = urllib2.build_opener(BetterHTTPErrorProcessor)
		if httpMethod == "POST" or httpMethod == "PUT":
			data = (json.dumps(withData))
			request = urllib2.Request(link, data)
		else:
			#Construct get parameters
			gets = "?"
			for key,value in withData.iteritems():
				gets = gets + key +"=" + str(value) +"&"
			request = urllib2.Request(link + gets)

		request.add_header('Content-Type', 'application/json')
		request.get_method = lambda: httpMethod
		self.spiderlink  = opener.open(request)

	def getCode(self):
		if self.spiderlink:
			return self.spiderlink.getcode()
		#You get nothing. Good day sir.

	def getJSON(self):
		"""Returns an object from json returned from spiderlink, or None if the information is malformed or not there"""
		# print self.spiderlink.read()
		if self.spiderlink:
			try:
				raw = self.spiderlink.read()
				returnValue = json.loads(raw)
				return returnValue
			except Exception, e:
				print "there's been an exception"
				#Issue parsing json. Die a silent death and allow tests to fail due to None
				print e
				pass
			


def validateCommentsGETRequest(comments_response_to_get):
	#define filters
	comment_response_keys = ['comments','page']
	comment_response_inner_keys = {'comments' : ['type','message','timestamp','pin','id'],
									'page' : ['next','previous']
	}
	
	assert comments_response_to_get is not None
	assert comment_response_keys[0] in comments_response_to_get
	assert comment_response_keys[1] in comments_response_to_get
	#make sure that any comments returned have the proper keys
	for comment in comments_response_to_get['comments']:
		for key in comment:
			assert key in comment_response_inner_keys['comments']
	for key in comments_response_to_get['page']:
		assert key in comment_response_inner_keys['page']
	return True

def validateCommentsPOSTRequest(comments_response_to_post):
	assert comments_response_to_post is not None
	#print comments_response_to_post
	assert 'status' in comments_response_to_post
	assert 'message' in comments_response_to_post
	assert comments_response_to_post['status'] == 200
	assert comments_response_to_post['message'] == "Successfuly submitted new comment"
	return True

def validateHeatmapGETRequest(heatmap_response_to_get):
	heatmap_response_keys = ['latDegrees','lonDegrees','secondsWorked']
	for gridzone in heatmap_response_to_get:
		for key,value in gridzone.iteritems():
			assert key in heatmap_response_keys
			assert isinstance(value,numbers.Number)
	return True

def validateHeatmapPUTRequest(heatmap_response_to_put):
	assert heatmap_response_to_put is not None
	assert 'status' in heatmap_response_to_put
	assert 'message' in heatmap_response_to_put
	assert heatmap_response_to_put['status'] == 200
	assert heatmap_response_to_put['message'] == "Successful submit"
	return True

def validatePINSGetRequest(pins_response_to_get):
	print "got to validatePINSGetRequest"
	pins_response_keys = ['latDegrees','lonDegrees','type','message']
	assert pins_response_to_get is not None
	for pin in pins_response_to_get:
		for key,value in pin.iteritems():
			assert key in pins_response_keys
			if key in ['latDegrees','lonDegrees']:
				assert isinstance(value,numbers.Number)
			else:
				assert isinstance(value,basestring)
	return True

def validatePinsPOSTRequest(pins_response_to_post):
	assert pins_response_to_post is not None
	assert 'status' in pins_response_to_post
	assert 'message' in pins_response_to_post
	assert pins_response_to_post['status'] == 200
	assert pins_response_to_post['message'] == "Successful submit"
	return True

def validateErrorMessageReturned(comments_error_response):
	assert "Error_Message" in comments_error_response
	return True



if __name__ == "__main__":
	baseURL = 'http://greenup.xenonapps.com/api' #doesn't work because of 302 instead of 307 on forwarding domain
	baseURL = 'http://greenupapi.appspot.com/api'
	baseURL = 'http://localhost:16084/api'
	#make things easier later on
	endPoints = {'home' : baseURL,
			'comments' : baseURL + '/comments',
			'pins' : baseURL + "/pins",
			'heatmap' : baseURL + '/heatmap'
	}

	
	#Test the comment endpoint:
	tester = Spider()

	tester.followLink(endPoints['comments'])
	assert tester.getCode() == HTTP_OK
	comments_response_to_get = tester.getJSON()
	validateCommentsGETRequest(comments_response_to_get)
	
	#Next attempt to submit responses and verify that they are what they should be
	tester.followLink(endPoints['comments'],withData={'type' : 'forum', 'page' : 1})
	assert tester.getCode() == HTTP_OK
	comments_response_to_get = tester.getJSON()
	validateCommentsGETRequest(comments_response_to_get)

	#Give it something it should have a problem with:
	tester.followLink(endPoints['comments'],withData={'type' : 'badvalue'})
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	validateErrorMessageReturned(tester.getJSON())

	#Give it another bad value that it will be ok with (it doesn't care about negatives)
	tester.followLink(endPoints['comments'],withData={'type' : 'needs', 'page' : -2})
	assert tester.getCode() == HTTP_OK
	validateCommentsGETRequest(tester.getJSON())

	#Send a POST request to the endpoint with appropriate data
	tester.followLink(endPoints['comments'],withData={"type" : "forum", "message" : "This is a test message"},httpMethod="POST")
	assert tester.getCode() == HTTP_OK
	validateCommentsPOSTRequest(tester.getJSON())

	#Send a bad POST request 
	tester.followLink(endPoints['comments'],withData={"type" : "crap", "message" : "This is another test message"},httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	validateErrorMessageReturned(tester.getJSON())

	tester.followLink(endPoints['comments'],withData={"type" : None, "message" : None },httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	validateErrorMessageReturned(tester.getJSON())

	tester.followLink(endPoints['comments'],withData={"type" : "meessage", "message" : "This is another test message", "pin" : "badpinval"},httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	validateErrorMessageReturned(tester.getJSON())

	print "Comments Endpoint Passed all asserted tests"

	#Default GET + no parameters
	tester.followLink(endPoints['heatmap'])
	assert tester.getCode() == HTTP_OK
	validateHeatmapGETRequest(tester.getJSON())

	#Default GET + bad latDegrees parameter
	tester.followLink(endPoints['heatmap'],withData={"latDegrees" : 191})
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	validateErrorMessageReturned(tester.getJSON())

	#GET with bad lonDegrees
	tester.followLink(endPoints['heatmap'],withData={"lonDegrees" : 91})
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	validateErrorMessageReturned(tester.getJSON())

	#get with bad offset (only one given)
	tester.followLink(endPoints['heatmap'],withData={"latDegrees" : 1.2, "lonDegrees" : 4.5, "lonOffset" : 6})
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	validateErrorMessageReturned(tester.getJSON())

	#Good get request with parameters
	tester.followLink(endPoints['heatmap'],withData={"latDegrees" : -25.4, "lonDegrees" : 43.2, "latOffset" : 4,"lonOffset" : 2})
	assert tester.getCode() == HTTP_OK
	validateHeatmapGETRequest(tester.getJSON())

	#Get with JUST precision (like a get all, but for a given precision)
	tester.followLink(endPoints['heatmap'],withData={"precision" : 4})
	assert tester.getCode() == HTTP_OK
	validateHeatmapGETRequest(tester.getJSON())

	#PUT requests to server checking
	tester.followLink(endPoints['heatmap'],withData=[{"latDegrees" : 31, "lonDegrees" : 32, "secondsWorked" : 45}],httpMethod="PUT")
	assert tester.getCode() == HTTP_OK
	validateHeatmapPUTRequest(tester.getJSON())

	#Bad PUT request
	tester.followLink(endPoints['heatmap'],withData=[{"latDegrees" : -231, "lonDegrees" : 32, "secondsWorked" : 45}],httpMethod="PUT")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	validateErrorMessageReturned(tester.getJSON())	

	tester.followLink(endPoints['heatmap'],withData=[{"latDegrees" : None, "lonDegrees" : None, "secondsWorked" : None}],httpMethod="PUT")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	validateErrorMessageReturned(tester.getJSON())	

	tester.followLink(endPoints['heatmap'],withData=[{"latDegrees" : -31, "lonDegrees" : -92, "secondsWorked" : 45}],httpMethod="PUT")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	validateErrorMessageReturned(tester.getJSON())	

	tester.followLink(endPoints['heatmap'],withData=[{"latDegrees" : 31, "lonDegrees" : 32, "secondsWorked" : -45}],httpMethod="PUT")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	validateErrorMessageReturned(tester.getJSON())	

	tester.followLink(endPoints['heatmap'],withData=[{ "lonDegrees" : 32, "secondsWorked" : 45}],httpMethod="PUT")
	assert tester.getCode() == HTTP_REQUEST_SYNTAX_PROBLEM
	validateErrorMessageReturned(tester.getJSON())	

	tester.followLink(endPoints['heatmap'],withData=[{ "latDegrees" : 32, "secondsWorked" : 45}],httpMethod="PUT")
	assert tester.getCode() == HTTP_REQUEST_SYNTAX_PROBLEM
	validateErrorMessageReturned(tester.getJSON())	

	tester.followLink(endPoints['heatmap'],withData=[{ "lonDegrees" : 32, "secondsWorked" : 45}],httpMethod="PUT")
	assert tester.getCode() == HTTP_REQUEST_SYNTAX_PROBLEM
	validateErrorMessageReturned(tester.getJSON())	

	tester.followLink(endPoints['heatmap'],withData=[{ "lonDegrees" : 32, "latDegrees" : 4}],httpMethod="PUT")
	assert tester.getCode() == HTTP_REQUEST_SYNTAX_PROBLEM
	validateErrorMessageReturned(tester.getJSON())	

	print "Heatmap endpoint Passed all assertion tests"


	'''
		****************** PINS SECTION ****************** 
	'''

	#Default GET
	tester.followLink(endPoints['pins'])
	assert tester.getCode() == HTTP_OK
	validatePINSGetRequest(tester.getJSON())

	#Get with parameters
	#Default GET + bad latDegrees parameter
	tester.followLink(endPoints['pins'],withData={"latDegrees" : 191})
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	validateErrorMessageReturned(tester.getJSON())

	#GET with bad lonDegrees
	tester.followLink(endPoints['pins'],withData={"lonDegrees" : 91})
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	validateErrorMessageReturned(tester.getJSON())

	#get with bad offset (only one given)
	tester.followLink(endPoints['pins'],withData={"latDegrees" : 1.2, "lonDegrees" : 4.5, "lonOffset" : 6})
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	validateErrorMessageReturned(tester.getJSON())


	#Good get request with parameters
	tester.followLink(endPoints['pins'],withData={"latDegrees" : -25.4, "lonDegrees" : 43.2, "latOffset" : 4,"lonOffset" : 2})
	assert tester.getCode() == HTTP_OK
	validatePINSGetRequest(tester.getJSON())

	#Get with JUST precision (like a get all, but for a given precision)
	tester.followLink(endPoints['pins'],withData={"precision" : 4})
	assert tester.getCode() == HTTP_OK
	validatePINSGetRequest(tester.getJSON())


	#Test the POST
	tester.followLink(endPoints['pins'],withData={'latDegrees' : 40, 'lonDegrees' : 50, 'type' : "trash pickup", 'message' : "Test"},httpMethod="POST")
	assert tester.getCode() == HTTP_OK
	validatePinsPOSTRequest(tester.getJSON())

	tester.followLink(endPoints['pins'],withData={'latDegrees' : 40, 'lonDegrees' : 50, 'type' : "help needed", 'message' : "Test"},httpMethod="POST")
	assert tester.getCode() == HTTP_OK
	validatePinsPOSTRequest(tester.getJSON())

	tester.followLink(endPoints['pins'],withData={'latDegrees' : 40, 'lonDegrees' : 50, 'type' : "general message", 'message' : "Test"},httpMethod="POST")
	assert tester.getCode() == HTTP_OK
	validatePinsPOSTRequest(tester.getJSON())

	#Test the POSt with missing keys
	tester.followLink(endPoints['pins'],withData={'lonDegrees' : 50, 'type' : "trash pickup", 'message' : "Test"},httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SYNTAX_PROBLEM
	validateErrorMessageReturned(tester.getJSON())

	tester.followLink(endPoints['pins'],withData={'latDegrees' : 50, 'type' : "trash pickup", 'message' : "Test"},httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SYNTAX_PROBLEM
	validateErrorMessageReturned(tester.getJSON())

	tester.followLink(endPoints['pins'],withData={'lonDegrees' : 50, 'latDegrees' : 2, 'message' : "Test"},httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SYNTAX_PROBLEM
	validateErrorMessageReturned(tester.getJSON())

	tester.followLink(endPoints['pins'],withData={'lonDegrees' : 50, 'type' : "trash pickup", 'latDegrees' : 2},httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SYNTAX_PROBLEM
	validateErrorMessageReturned(tester.getJSON())

	#Test the POST with keys but bad data
	tester.followLink(endPoints['pins'],withData={'latDegrees' : -240, 'lonDegrees' : 50, 'type' : "trash pickup", 'message' : "Test"},httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	validateErrorMessageReturned(tester.getJSON())

	tester.followLink(endPoints['pins'],withData={'latDegrees' : 40, 'lonDegrees' : 150, 'type' : "trash pickup", 'message' : "Test"},httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	validateErrorMessageReturned(tester.getJSON())

	tester.followLink(endPoints['pins'],withData={'latDegrees' : 440, 'lonDegrees' : 50, 'type' : "trash pickup", 'message' : "Test"},httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	validateErrorMessageReturned(tester.getJSON())

	tester.followLink(endPoints['pins'],withData={'latDegrees' : 40, 'lonDegrees' : -930, 'type' : "trash pickup", 'message' : "Test"},httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	validateErrorMessageReturned(tester.getJSON())

	#Because of pythons dynamic typing this is ok
	tester.followLink(endPoints['pins'],withData={'latDegrees' : "40", 'lonDegrees' : "50", 'type' : "trash pickup", 'message' : "Test"},httpMethod="POST")
	assert tester.getCode() == HTTP_OK
	validatePinsPOSTRequest(tester.getJSON())

	tester.followLink(endPoints['pins'],withData={'latDegrees' : 40, 'lonDegrees' : -930, 'type' : "trashickup", 'message' : "Test"},httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	validateErrorMessageReturned(tester.getJSON())

	tester.followLink(endPoints['pins'],withData={'latDegrees' : 40, 'lonDegrees' : -930, 'type' : "trash pickup", 'messsage' : "Test"},httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SYNTAX_PROBLEM
	validateErrorMessageReturned(tester.getJSON())

	tester.followLink(endPoints['pins'],withData={'latDegrees' : None, 'lonDegrees' : None, 'type' : None, 'message' : None},httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	validateErrorMessageReturned(tester.getJSON())

	print "Pins endpoint passed all assertion tests"








	













