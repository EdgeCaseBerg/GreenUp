import json
import jinja2
import os
import webapp2

class Handler(webapp2.RequestHandler):
	'''
		Class Handler 
		This class inherits from RequestHandler. It is used to simplify writing and rendering to templates by providing
		simpler methods to use in order to do such operations. 
	'''
	def write(self, *a, **kw):
		self.response.out.write(*a, **kw)

	def renderStr(self, template, **params):
		t = jinja_env.get_template(template)
		return t.render(params)
