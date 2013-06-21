import json
import jinja2
import os
import webapp2

#set templating directory with jinja. NOTE that jinja escapes html because autoescape = True
template_dir = os.path.join(os.path.dirname(__file__), '../templates')
jinja_env = jinja2.Environment(loader = jinja2.FileSystemLoader(template_dir), autoescape = True)

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

	def render(self, template, **kw):
		logging.info("template directory")
		logging.info(template_dir)

		#called by render_front in MainPage class
		self.write(self.renderStr(template, **kw))