# f=urllib.urlopen('http://greenupapi.appspot.com/api')
# >>> f.getcode()
# 200
# >>> print f.read()
# {"version": 1.0, "powered by": "Xenon Apps"}

import urllib2
import json

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
			data = json_data.encode(json.dumps(withData))
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
				returnValue = json.loads(self.spiderlink.read())
				return returnValue
			except Exception, e:
				#Issue parsing json. Die a silent death and allow tests to fail due to None
				pass
			


def validateComments(comments_response_to_get):
	#define filters
	comments_params = {'type' : ['forum','needs','message'],
	}
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
	validateComments(comments_response_to_get)
	
	#Next attempt to submit responses and verify that they are what they should be
	tester.followLink(endPoints['comments'],withData={'type' : 'forum', 'page' : 1})
	assert tester.getCode() == HTTP_OK
	comments_response_to_get = tester.getJSON()
	validateComments(comments_response_to_get)

	#Give it something it should have a problem with:
	tester.followLink(endPoints['comments'],withData={'type' : 'badvalue'})
	assert tester.getCode() == HTTP_REQUEST_SEMANTICS_PROBLEM
	validateErrorMessageReturned(tester.getJSON())





	heatmap_pin_params = {
		'latDegrees' : [-191, -180, 2.3, 0, 180, 180.1,'bad'],
		'lonDegrees' : [2.3, -4.5, 91.1, -91, 20,-20.4,'bad'],
		'lonOffset' : [-1, 4, 'bad'],
		'latOffset' : [-1, 4, 'good'],
		'precision' : [-1, 0 ,6, 'badvalue']
	}

	heatmap_put_params = {'tests' : [ [], 
					{}, 
					[{},{}], 
					[{'latDegrees' : 4, 'lonDegrees' : 5, 'secondsWorked' : 50}],
					[{'latDegrees' : 4, 'lonDegrees' : 'bad5', 'secondsWorked' : 50}], 
		]
	}

	













