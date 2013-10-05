""" Constants for use in response codes declared here """
HTTP_NOT_IMPLEMENTED = 503
HTTP_OK = 200
HTTP_DELETED = 204
HTTP_REQUEST_SEMANTICS_PROBLEM = 422
HTTP_REQUEST_SYNTAX_PROBLEM = 400
HTTP_NOT_FOUND = 404

""" Constants for domain name and fully qualified http urls"""
BASE_URL = "http://greenupapp.appspot.com"
CONTEXT_PATH = "/api"

""" Miscellaneous Constants """
DEFAULT_ROUNDING_PRECISION = 6
PAGE_SIZE = 20

""" Validation Constants """
PIN_TYPES = ('GENERAL MESSAGE', 'HELP NEEDED', 'TRASH PICKUP')
COMMENT_TYPES = ('FORUM', 'GENERAL MESSAGE','','HELP NEEDED', 'TRASH PICKUP')
COMMENTS_RESOURCE_PATH = "/comments"
DEBUG_RESOURCE_PATH = "/debug"

""" String format of error messages """
ERROR_STR = '{"status_code" : %i, "Error_Message" : "%s"}'
SINCE_TIME_FORMAT = "%Y-%m-%d-%H:%M"

""" Error to throw on a sematic error in a request """
class SemanticError(Exception):
	def __init__(self,message):
		self.message = message
	def __str__(self):
		return repr(self.message)