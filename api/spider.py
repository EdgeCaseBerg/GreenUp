# f=urllib.urlopen('http://greenupapi.appspot.com/api')
# >>> f.getcode()
# 200
# >>> print f.read()
# {"version": 1.0, "powered by": "Xenon Apps"}

import urllib2
import json
import logging
import types
import numbers
import datetime
import argparse

from constants import *

class BetterHTTPErrorProcessor(urllib2.BaseHandler):
    # a substitute/supplement to urllib2.HTTPErrorProcessor
    # that doesn't raise exceptions on status codes 200,400,422,503
    def http_error_200(self, request, response, code, msg, hdrs):
        return response
    def http_error_204(self, request, response, code, msg, hdrs):
    	return response
    def http_error_400(self, request, response, code, msg, hdrs):
        return response
    def http_error_404(self, request, response, code, msg, hdrs):
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
			#Construct get parameters (or delete)
			gets = "?"
			for key,value in withData.iteritems():
				gets = gets + key +"=" + str(value) +"&"
			request = urllib2.Request(link + gets)


		request.add_header('Content-Type', 'application/json')
		request.add_header('User-Agent', 'api-spider-test')
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
			raw = ""
			try:
				raw = self.spiderlink.read()
				#print raw #You may only read from spiderlink once! so if you need to use the value from read more than once extend the variable classwide or save it in a temporary
				returnValue = json.loads(raw)
				return returnValue
			except Exception, e:
				print "there's been an exception"
				#Issue parsing json. Die a silent death and allow tests to fail due to None
				print e
				print raw
				pass

	def getRaw(self):
		if self.spiderlink:
			raw = ""
			raw = self.spiderlink.read() 
			if raw == "":
				raw = None
			return raw
			


def validateCommentsGETRequest(comments_response_to_get):
	#define filters
	comment_response_keys = ['comments','page','status_code']
	comment_response_inner_keys = {'comments' : ['addressed', 'type','message','timestamp','pin','id'],
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
	assert 'status_code' in comments_response_to_post
	assert 'message' in comments_response_to_post
	assert comments_response_to_post['status_code'] == 200
	assert comments_response_to_post['message'] == "Successfuly submitted new comment"
	return True

def validateHeatmapGETRequest(heatmap_response_to_get):
	heatmap_response_keys = ['grid','status_code']
	heatmap_response_inner_keys = ['latDegrees','lonDegrees','secondsWorked']
	for out_key,out_val in heatmap_response_to_get.iteritems():
		assert out_key in heatmap_response_keys
		if out_key == "status_code":
			assert out_val == 200
		if out_key == "grid":
			for gridzone in heatmap_response_to_get['grid']:
				for key,value in gridzone.iteritems():
					assert key in heatmap_response_inner_keys
					assert isinstance(value,numbers.Number)
	return True

def validateHeatmapGETRawFalseRequest(heatmap_response_to_get):
	heatmap_response_keys = ['grid','status_code']
	heatmap_response_inner_keys = ['latDegrees','lonDegrees','secondsWorked']
	for out_key,out_val in heatmap_response_to_get.iteritems():
		if out_key == "grid":
			for gridzone in out_val:
				for key,value in gridzone.iteritems():
					assert key in heatmap_response_inner_keys
					assert isinstance(value,numbers.Number)
					if key=="secondsWorked":
						assert value <= 1.0
		if out_key == "status_code":
			assert out_val == 200
	return True

def validateHeatmapGETRawTrueRequest(heatmap_response_to_get):
	heatmap_response_keys = ['grid','status_code']
	heatmap_response_inner_keys = ['latDegrees','lonDegrees','secondsWorked']
	#Assert validity of syntax
	valid = False
	if(validateHeatmapGETRequest(heatmap_response_to_get)):
		for out_key,out_val in heatmap_response_to_get.iteritems():
			assert out_key in heatmap_response_keys
			if out_key == "grid":
				for gridzone in out_val:
					for key,value in gridzone.iteritems():
						assert key in heatmap_response_inner_keys
						#We have to assert that all the values are floats for secondsWorked and they're not all under 1,
						if key=="secondsWorked":
							valid = valid or value > 1.0
			if out_key == "status_code":
				assert out_val == 200
	assert valid == True
	return True


def validateHeatmapPUTRequest(heatmap_response_to_put):
	assert heatmap_response_to_put is not None
	assert 'status_code' in heatmap_response_to_put
	assert 'message' in heatmap_response_to_put
	assert heatmap_response_to_put['status_code'] == 200
	assert heatmap_response_to_put['message'] == "Successful submit"
	return True

def validatePINSGetRequest(pins_response_to_get):
	pins_response_keys = ['status_code', 'pins']
	pins_response_inner_keys = ['latDegrees','lonDegrees','type','message','id','addressed']
	assert pins_response_to_get is not None
	for out_key,out_val in pins_response_to_get.iteritems():
		assert out_key in pins_response_keys
		if out_key == "status_code":
			assert out_val == 200
		if out_key == "pins":
			for pin in out_val:
				for key,value in pin.iteritems():
					assert key in pins_response_inner_keys
					if key in ['latDegrees','lonDegrees','id']:
						assert isinstance(value,numbers.Number)
					elif key == "addressed":
						pass
					else:
						assert isinstance(value,basestring)
	return True

def validatePinsPOSTRequest(pins_response_to_post):
	assert pins_response_to_post is not None
	assert 'status_code' in pins_response_to_post
	assert 'message' in pins_response_to_post
	assert 'pin_id' in pins_response_to_post
	assert pins_response_to_post['status_code'] == 200
	assert pins_response_to_post['message'] == "Successful submit"
	return True

def validateErrorMessageReturned(err_message_returned):
	assert err_message_returned is not None
	assert "Error_Message" in err_message_returned
	return True

def validateDebugGETRequest(debugs_response_to_get,since=None):
	assert debugs_response_to_get is not None
	debug_outer_keys = ['status_code','messages','page']
	debug_inner_keys = ['message', 'stackTrace','timestamp','hash']
	debug_page_keys  = ['next','previous']
	for out_key,out_val in debugs_response_to_get.iteritems():
		assert out_key in debug_outer_keys
		if out_key == "status_code":
			assert int(out_val) == HTTP_OK
		if out_key == "messages":
			for msg in out_val:
				for msg_key,msg_val in msg.iteritems():
					assert msg_key in debug_inner_keys
					if msg_key == "timestamp":
						#validate the timestamp format
						try:
							datetime.datetime.strptime(msg_val, SINCE_TIME_FORMAT)
						except Exception,e:
							raise Exception("fuck")
						if since is not None:
							#Validate that the timestamp is not prior the since date
							returned_time = datetime.datetime.strptime(msg_val, SINCE_TIME_FORMAT)
							assert returned_time > since

		if out_key == "page":
			for key,val in out_val.iteritems():
				assert key in debug_page_keys
	return True

def validateDebugPOSTRequest(debugs_response_to_post):
	assert debugs_response_to_post is not None
	debug_expected_keys = ['status_code', 'message']
	for key,val in debugs_response_to_post.iteritems():
		assert key in debug_expected_keys
		if key == "status_code":
			assert val == HTTP_OK
	return True

def validateDebugDELETERequest(debugs_response_to_delete):
	assert debugs_response_to_delete is None
	return True


def validateDebugDELETE404Response(debugs_response_to_delete):
	assert debugs_response_to_delete is not None
	debug_expected_keys = ['status_code', 'message']
	for key,val in debugs_response_to_delete.iteritems():
		assert key in debug_expected_keys
		if key == "status_code":
			assert val == HTTP_NOT_FOUND
	return True

if __name__ == "__main__":
	parser = argparse.ArgumentParser(description='Test the API.')
	parser.add_argument('-p', help='Specify local port to run the spider against. If blank, run against app url.')
	args = parser.parse_args()
	if args.p:
		port = args.p
		baseURL = 'http://localhost:%s/api' % port
	else:
		baseURL = 'http://greenupapp.appspot.com/api'
	
	# baseURL = 'http://greenup.xenonapps.com/api' #doesn't work because of 302 instead of 307 on forwarding domain
	
	#make things easier later on
	endPoints = {'home' : baseURL,
			'comments' : baseURL + '/comments',
			'pins' : baseURL + "/pins",
			'heatmap' : baseURL + '/heatmap',
			'debug' : baseURL + '/debug'
	}

	print "Beginning Spider API test against %s " % baseURL
	
	#Test the comment endpoint:
	tester = Spider()

	tester.followLink(endPoints['comments'])
	assert tester.getCode() == HTTP_OK
	comments_response_to_get = tester.getJSON()
	assert validateCommentsGETRequest(comments_response_to_get) is True

	#See if the comments are in reverse chronological order
	tester.followLink(endPoints['comments'])
	assert tester.getCode() == HTTP_OK
	comments_response_to_get = tester.getJSON()
	newlist = sorted(comments_response_to_get['comments'], key=lambda k: k['timestamp'], reverse=True) 
	#assert comments_response_to_get['comments'] == newlist

	#Next attempt to submit responses and verify that they are what they should be
	tester.followLink(endPoints['comments'],withData={'type' : 'COMMENT', 'page' : 1})
	assert tester.getCode() == HTTP_OK
	comments_response_to_get = tester.getJSON()
	assert validateCommentsGETRequest(comments_response_to_get) is True

	#Give it something it should have a problem with:
	tester.followLink(endPoints['comments'],withData={'type' : 'badvalue'})
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	#Give it another bad value that it will be ok with (it doesn't care about negatives)
	tester.followLink(endPoints['comments'],withData={'type' : 'ADMIN', 'page' : -2})
	assert tester.getCode() == HTTP_OK
	assert validateCommentsGETRequest(tester.getJSON()) is True

	#Send a POST request to the endpoint with appropriate data
	tester.followLink(endPoints['comments'],withData={"type" : "COMMENT", "message" : "This is a test message"},httpMethod="POST")
	assert tester.getCode() == HTTP_OK
	assert validateCommentsPOSTRequest(tester.getJSON()) is True

	#Send a bad POST request 
	tester.followLink(endPoints['comments'],withData={"type" : "crap", "message" : "This is another test message"},httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	tester.followLink(endPoints['comments'],withData={"type" : None, "message" : None },httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	tester.followLink(endPoints['comments'],withData={"type" : "COMMENT", "message" : "This is another test message", "pin" : "badpinval"},httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	#Send a POST request to the endpoint with an empty message
	tester.followLink(endPoints['comments'],withData={"type" : "COMMENT", "message" : " "},httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	#Send a POST request to the endpoint with more than 140 characters (145) in the message
	tester.followLink(endPoints['comments'],withData={"type" : "COMMENT", "message" : "sfsdfsdlfhdslfhlksdfhlsdkfdsklfjldskjfkldsjflksdjflksdhfjsdkbgdsibosdihgfiosdhglkdshslkdhgioerhgoirenglsdkhgsdhgoierhgoirehglkfsdhgiofhgioshglks"},httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	#Test delete a comment
	tester.followLink(endPoints['comments'])
	response = tester.getJSON()
	tester.followLink(endPoints['comments'],withData={"id" : response['comments'][0]['id']},httpMethod="DELETE")
	assert tester.getCode() == HTTP_DELETED
	tester.followLink(endPoints['comments'],withData={"id" : response['comments'][0]['id']},httpMethod="DELETE")
	assert tester.getCode() == HTTP_NOT_FOUND


	print "\tComments Endpoint Passed all asserted tests"

	#Default GET + no parameters
	tester.followLink(endPoints['heatmap'])
	assert tester.getCode() == HTTP_OK
	assert validateHeatmapGETRawFalseRequest(tester.getJSON()) is True

	#Default GET + bad latDegrees parameter
	tester.followLink(endPoints['heatmap'],withData={"latDegrees" : 91})
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	#GET with bad lonDegrees
	tester.followLink(endPoints['heatmap'],withData={"lonDegrees" : 291})
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	#get with bad offset (only one given)
	tester.followLink(endPoints['heatmap'],withData={"latDegrees" : 1.2, "lonDegrees" : 4.5, "lonOffset" : 6})
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	#Good get request with parameters
	tester.followLink(endPoints['heatmap'],withData={"latDegrees" : -25.4, "lonDegrees" : 43.2, "latOffset" : 4,"lonOffset" : 2})
	assert tester.getCode() == HTTP_OK
	assert validateHeatmapGETRawFalseRequest(tester.getJSON()) is True

	#Good get request with decimal offset
	tester.followLink(endPoints['heatmap'],withData={"latDegrees" : -25.4, "lonDegrees" : 43.2, "latOffset" : 4.2,"lonOffset" : 2.2})
	assert tester.getCode() == HTTP_OK
	assert validateHeatmapGETRawFalseRequest(tester.getJSON()) is True

	#Get with JUST precision (like a get all, but for a given precision)
	tester.followLink(endPoints['heatmap'],withData={"precision" : 4})
	assert tester.getCode() == HTTP_OK
	assert validateHeatmapGETRawFalseRequest(tester.getJSON()) is True

	#PUT requests to server checking
	tester.followLink(endPoints['heatmap'],withData=[{"latDegrees" : 31, "lonDegrees" : 32, "secondsWorked" : 25}],httpMethod="PUT")
	assert tester.getCode() == HTTP_OK
	assert validateHeatmapPUTRequest(tester.getJSON()) is True

	tester.followLink(endPoints['heatmap'],withData=[{"latDegrees" : 31, "lonDegrees" : 12, "secondsWorked" : 45}],httpMethod="PUT")
	assert tester.getCode() == HTTP_OK
	assert validateHeatmapPUTRequest(tester.getJSON()) is True

	#Bad PUT request
	tester.followLink(endPoints['heatmap'],withData=[{"latDegrees" : -231, "lonDegrees" : 32, "secondsWorked" : 45}],httpMethod="PUT")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON())	 is True

	tester.followLink(endPoints['heatmap'],withData=[{"latDegrees" : None, "lonDegrees" : None, "secondsWorked" : None}],httpMethod="PUT")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON())	 is True

	tester.followLink(endPoints['heatmap'],withData=[{"latDegrees" : -31, "lonDegrees" : -92, "secondsWorked" : 45}],httpMethod="PUT")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON())	 is True

	tester.followLink(endPoints['heatmap'],withData=[{"latDegrees" : 31, "lonDegrees" : 32, "secondsWorked" : -45}],httpMethod="PUT")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON())	 is True

	tester.followLink(endPoints['heatmap'],withData=[{ "lonDegrees" : 32, "secondsWorked" : 45}],httpMethod="PUT")
	assert tester.getCode() == HTTP_REQUEST_SYNTAX_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON())	 is True

	tester.followLink(endPoints['heatmap'],withData=[{ "latDegrees" : 32, "secondsWorked" : 25}],httpMethod="PUT")
	assert tester.getCode() == HTTP_REQUEST_SYNTAX_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON())	 is True

	tester.followLink(endPoints['heatmap'],withData=[{ "lonDegrees" : 32, "secondsWorked" : 45}],httpMethod="PUT")
	assert tester.getCode() == HTTP_REQUEST_SYNTAX_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON())	 is True

	tester.followLink(endPoints['heatmap'],withData=[{ "lonDegrees" : 32, "latDegrees" : 4}],httpMethod="PUT")
	assert tester.getCode() == HTTP_REQUEST_SYNTAX_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON())	 is True

	#Test the rawness of the heatmap by this point we have enough seconsdWorked stored to have over 1.
	tester.followLink(endPoints['heatmap'],withData={"raw" : "True"},httpMethod="GET")
	assert validateHeatmapGETRawTrueRequest(tester.getJSON()) == True
	assert tester.getCode() == HTTP_OK



	print "\tHeatmap endpoint Passed all assertion tests"


	'''
		****************** PINS SECTION ****************** 
	'''

	#Default GET
	tester.followLink(endPoints['pins'])
	assert tester.getCode() == HTTP_OK
	assert validatePINSGetRequest(tester.getJSON()) is True

	#Get with parameters
	#Default GET + bad latDegrees parameter
	tester.followLink(endPoints['pins'],withData={"latDegrees" : 191})
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	#GET with bad lonDegrees
	tester.followLink(endPoints['pins'],withData={"lonDegrees" : 191})
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	#get with bad offset (only one given)
	tester.followLink(endPoints['pins'],withData={"latDegrees" : 1.2, "lonDegrees" : 4.5, "lonOffset" : 6})
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True


	#Good get request with parameters
	tester.followLink(endPoints['pins'],withData={"latDegrees" : -25.4, "lonDegrees" : 43.2, "latOffset" : 4,"lonOffset" : 2})
	assert tester.getCode() == HTTP_OK
	assert validatePINSGetRequest(tester.getJSON()) is True

	#Get with JUST precision (like a get all, but for a given precision)
	tester.followLink(endPoints['pins'],withData={"precision" : 4})
	assert tester.getCode() == HTTP_OK
	assert validatePINSGetRequest(tester.getJSON()) is True


	#Test the POST
	tester.followLink(endPoints['pins'],withData={'latDegrees' : 40, 'lonDegrees' : 50, 'type' : "ADMIN", 'message' : "Test","addressed" : False},httpMethod="POST")
	assert tester.getCode() == HTTP_OK
	assert validatePinsPOSTRequest(tester.getJSON()) is True

	tester.followLink(endPoints['pins'],withData={'latDegrees' : 40, 'lonDegrees' : 25, 'type' : "MARKER", 'message' : "Test","addressed" : False},httpMethod="POST")
	assert tester.getCode() == HTTP_OK
	assert validatePinsPOSTRequest(tester.getJSON()) is True

	tester.followLink(endPoints['pins'],withData={'latDegrees' : 40, 'lonDegrees' : 50, 'type' : "COMMENT", 'message' : "Test","addressed" : False},httpMethod="POST")
	assert tester.getCode() == HTTP_OK
	assert validatePinsPOSTRequest(tester.getJSON()) is True

	#Test the POSt with missing keys
	tester.followLink(endPoints['pins'],withData={'lonDegrees' : 50, 'type' : "ADMIN", 'message' : "Test","addressed" : False},httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SYNTAX_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	tester.followLink(endPoints['pins'],withData={'latDegrees' : 50, 'type' : "ADMIN", 'message' : "Test","addressed" : False},httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SYNTAX_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	tester.followLink(endPoints['pins'],withData={'lonDegrees' : 50, 'latDegrees' : 2, 'message' : "Test","addressed" : False},httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SYNTAX_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	tester.followLink(endPoints['pins'],withData={'lonDegrees' : 50, 'type' : "ADMIN", 'latDegrees' : 2,"addressed" : False},httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SYNTAX_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	#Test the POST with keys but bad data
	tester.followLink(endPoints['pins'],withData={'latDegrees' : -240, 'lonDegrees' : 50, 'type' : "ADMIN", 'message' : "Test","addressed" : False},httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	tester.followLink(endPoints['pins'],withData={'latDegrees' : 40, 'lonDegrees' : 190, 'type' : "ADMIN", 'message' : "Test","addressed" : False},httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	tester.followLink(endPoints['pins'],withData={'latDegrees' : 440, 'lonDegrees' : 50, 'type' : "ADMIN", 'message' : "Test","addressed" : False},httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	tester.followLink(endPoints['pins'],withData={'latDegrees' : 40, 'lonDegrees' : -930, 'type' : "ADMIN", 'message' : "Test","addressed" : False},httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	#Because of pythons dynamic typing this is ok
	tester.followLink(endPoints['pins'],withData={'latDegrees' : "40", 'lonDegrees' : "50", 'type' : "ADMIN", 'message' : "Test","addressed" : False},httpMethod="POST")
	assert tester.getCode() == HTTP_OK
	assert validatePinsPOSTRequest(tester.getJSON()) is True

	tester.followLink(endPoints['pins'],withData={'latDegrees' : 40, 'lonDegrees' : -930, 'type' : "trashickup", 'message' : "Test","addressed" : False},httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	tester.followLink(endPoints['pins'],withData={'latDegrees' : 40, 'lonDegrees' : -930, 'type' : "ADMIN", 'messsage' : "Test","addressed" : False},httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SYNTAX_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	tester.followLink(endPoints['pins'],withData={'latDegrees' : None, 'lonDegrees' : None, 'type' : None, 'message' : None,"addressed" : False},httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	#Test deleting a pin:
	tester.followLink(endPoints['pins'])
	response = tester.getJSON()
	tester.followLink(endPoints['pins'],withData={'id':response['pins'][0]['id'] }, httpMethod="DELETE")
	assert tester.getCode() == HTTP_DELETED
	tester.followLink(endPoints['pins'],withData={'id':response['pins'][0]['id'] }, httpMethod="DELETE")
	assert tester.getCode() == HTTP_NOT_FOUND
	


	print "\tPins endpoint passed all assertion tests"


	#Test the DEBUG endpoint
	tester.followLink(endPoints['debug'])
	assert tester.getCode() == HTTP_OK
	assert validateDebugGETRequest(tester.getJSON()) is True

	#empty values are ok and ignored
	tester.followLink(endPoints['debug'],withData={'hash' :'','page' : '', 'since':''},httpMethod="GET")
	assert tester.getCode() == HTTP_OK
	assert validateDebugGETRequest(tester.getJSON()) is True

	#Valid time format returns things with proper time
	tester.followLink(endPoints['debug'],withData={'hash' :'','page' : '', 'since':'2013-08-17-00:00'},httpMethod="GET")
	assert tester.getCode() == HTTP_OK
	assert validateDebugGETRequest(tester.getJSON(),since=datetime.datetime.now()) is True 

	tester.followLink(endPoints['debug'],withData={'hash' :'','page' : '', 'since':'2013-08-17-00:00'},httpMethod="GET")
	assert tester.getCode() == HTTP_OK
	assert validateDebugGETRequest(tester.getJSON(),since=datetime.datetime.strptime('2013-08-17-00:00', SINCE_TIME_FORMAT)) is True 

	#mutual exclusion of parameters page and hash
	tester.followLink(endPoints['debug'],withData={'hash' : 'asdf','page' : 1},httpMethod="GET")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	#Test that page must be numeric
	tester.followLink(endPoints['debug'],withData={'hash' : '','page' : 'derp'},httpMethod="GET")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	#Test bad date parameters
	tester.followLink(endPoints['debug'],withData={'hash' :'','page' : '', 'since':'2013-08-17+00:00'},httpMethod="GET")
	assert tester.getCode() == HTTP_REQUEST_SYNTAX_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	tester.followLink(endPoints['debug'],withData={'hash' :'','page' : '', 'since':'2008-17+00:00'},httpMethod="GET")
	assert tester.getCode() == HTTP_REQUEST_SYNTAX_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	#Test the post validation

	#A proper post
	tester.followLink(endPoints['debug'],withData={'message' : 'Test message', 'stackTrace' : 'line 520 in spider.py', 'origin' : 'spider-test' },httpMethod="POST")
	assert tester.getCode() == HTTP_OK
	assert validateDebugPOSTRequest(tester.getJSON()) is True

	#With a messed up mesage key
	tester.followLink(endPoints['debug'],withData={'mesage' : 'Test message', 'stackTrace' : 'line 520 in spider.py', 'origin' : 'spider-test' },httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	#bad stack trace key
	tester.followLink(endPoints['debug'],withData={'message' : 'Test message', 'stackTraces' : 'line 520 in spider.py', 'origin' : 'spider-test' },httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	#bad origin key
	tester.followLink(endPoints['debug'],withData={'message' : 'Test message', 'stackTrace' : 'line 520 in spider.py', 'origins' : 'spider-test' },httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	#Empty values
	tester.followLink(endPoints['debug'],withData={'message' : '', 'stackTrace' : 'line 520 in spider.py', 'origin' : 'spider-test' },httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	tester.followLink(endPoints['debug'],withData={'message' : 'Test message', 'stackTrace' : '', 'origin' : 'spider-test' },httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	tester.followLink(endPoints['debug'],withData={'message' : 'Test message', 'stackTrace' : 'line 520 in spider.py', 'origin' : '' },httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	#Test the deletion validations
	tester.followLink(endPoints['debug'],withData={'hash' : '5f8b50789cadf1cf56328e3419be87a76f8a13b1c931475640bc9fdbbaffc37f', 'origin' : 'spider-test' },httpMethod="DELETE")	
	assert tester.getCode() == HTTP_DELETED
	assert validateDebugDELETERequest(tester.getRaw()) is True

	#test the trying to delete again will give 404
	tester.followLink(endPoints['debug'],withData={'hash' : '5f8b50789cadf1cf56328e3419be87a76f8a13b1c931475640bc9fdbbaffc37f', 'origin' : 'spider-test' },httpMethod="DELETE")
	assert tester.getCode() == HTTP_NOT_FOUND
	assert validateDebugDELETE404Response(tester.getJSON()) is True

	#Test that the two parameters are required
	tester.followLink(endPoints['debug'],withData={'origin' : 'spider-test' },httpMethod="DELETE")
	assert tester.getCode() == HTTP_REQUEST_SYNTAX_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True

	tester.followLink(endPoints['debug'],withData={'hash' : 'xkj45tr99sder' },httpMethod="DELETE")
	assert tester.getCode() == HTTP_REQUEST_SYNTAX_PROBLEM
	assert validateErrorMessageReturned(tester.getJSON()) is True
	
	print "\tDebug endpoint passed all assertion tests"
	print "Spider API Test complete. All tests passed"

	







	













