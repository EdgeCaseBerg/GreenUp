# f=urllib.urlopen('http://greenupapi.appspot.com/api')
# >>> f.getcode()
# 200
# >>> print f.read()
# {"version": 1.0, "powered by": "Xenon Apps"}

import urllib2
import json

import numbers

#Temporary in here
HTTP_NOT_IMPLEMENTED = 503
HTTP_OK = 200
HTTP_REQUEST_SEMANTICS_PROBLEM = 422
HTTP_REQUEST_SYNTAX_PROBLEM = 400

class BetterHTTPErrorProcessor(urllib2.BaseHandler):
    # a substitute/supplement to urllib2.HTTPErrorProcessor
    # that doesn't raise exceptions on status codes 201,204,206
    def http_error_200(self, request, response, code, msg, hdrs):
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
		if self.spiderlink:
			try:
				raw = self.spiderlink.read()
				#print raw
				returnValue = json.loads(raw)
				return returnValue
			except Exception, e:
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
	assert 'status' in comments_response_to_post
	assert 'message' in comments_response_to_post
	assert comments_response_to_post['status'] == 200
	assert comments_response_to_post['message'] == "Successfuly submitted new comment"
	return True

def validateHeatmapGETRequest(heatmap_response_to_get):
	heatmap_response_keys = ['latDegrees','lonDegrees','secondsWorked']
	for gridzone in heatmap_response_to_get:
		for key,value in heatmap_response_to_get.iteritems():
			assert key in heatmap_response_keys
			assert isinstance(value,numbers.Number)

def validateHeatmapPUTRequest(heatmap_response_to_put):
	assert heatmap_response_to_put is not None
	assert 'status' in heatmap_response_to_put
	assert 'message' in heatmap_response_to_put
	assert heatmap_response_to_put['status'] == 200
	assert heatmap_response_to_put['message'] == "Successfuly submit"
	return True

def validateErrorMessageReturned(comments_error_response):
	assert "Error_Message" in comments_error_response
	return True



if __name__ == "__main__":
	baseURL = 'http://greenupapi.appspot.com/api'
	baseURL = 'http://localhost:30002/api'
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

	tester.followLink(endPoints['comments'],withData={"type" : "meessage", "message" : "This is another test message", "pin" : "badpinval"},httpMethod="POST")
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	validateErrorMessageReturned(tester.getJSON())

	print "Comments Endpoint Passed all asserted tests"

	#Default GET + no parameters
	tester.followLink(endPoints['heatmap'])
	assert tester.getCode() == HTTP_OK
	validateHeatmapGETRequest(tester.getJSON)

	#Get with some parameters
	tester.followLink(endPoints['heatmap'],withData={})

	













