# f=urllib.urlopen('http://greenupapi.appspot.com/api')
# >>> f.getcode()
# 200
# >>> print f.read()
# {"version": 1.0, "powered by": "Xenon Apps"}

import urllib2
import json

class Spider(object):
	def __init__(self):
		super(Spider, self).__init__()
		
	def followLink(self,link,withData={},httpMethod="GET"):
		opener = urllib2.build_opener(urllib2.HTTPHandler)
		if httpMethod == "POST" or httpMethod == "PUT":
			data = json_data.encode(json.dumps(withData))
			request = urllib2.Request(link, data)
		else:
			request = urllib2.Request(link)

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
			


if __name__ == "__main__":
	baseURL = 'http://greenupapi.appspot.com/api'
	#make things easier later on
	endPoints = {'home' : baseURL,
			'comments' : baseURL + '/comments',
			'pins' : baseURL + "/pins",
			'heatmap' : baseURL + '/heatmap'
	}




