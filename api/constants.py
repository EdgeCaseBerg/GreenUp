""" Constants for use in response codes declared here """
HTTP_NOT_IMPLEMENTED = 503
HTTP_OK = 200
HTTP_REQUEST_SEMANTICS_PROBLEM = 422
HTTP_REQUEST_SYNTAX_PROBLEM = 400

""" Constants for domain name and fully qualified http urls"""
BASE_URL = "http://greenup.xenonapps.com"
CONTEXT_PATH = "/api"

""" Miscellaneous Constants """
DEFAULT_ROUNDING_PRECISION = 6

""" Validation Constants """
PIN_TYPES = ('GENERAL MESSAGE', 'HELP NEEDED', 'TRASH PICKUP')
COMMENT_TYPES = ('FORUM', 'NEEDS', 'MESSAGE','')
COMMENTS_RESOURCE_PATH = "comments"



""" Error to throw on a sematic error in a request """
class SemanticError(Exception):
	def __init__(self,message):
		self.message = message
	def __str__(self):
		return repr(self.message)