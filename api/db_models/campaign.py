from google.appengine.ext import db

class Campaign(db.Model):
	# specify callbacks (and callforwards?) as well as override all of the put and delete methods provided by db.model so we can use them for counting
	def before_put(self):
		logging.info("before put")

	def after_put(self):
		logging.info("after put")
		# this is where we do the counting
		increment(self.__class__.__name__)
		
	def before_delete(self):
		logging.info("before delete")

	def after_delete(self):
		logging.info("after delete")
		# this is where we do the counting
		decrement(self.__class__.__name__)

	def put_async(self):
		return db.put_async(self)

	def delete_async(self):
		return db.delete_async(self)

	def put(self):
		# call get_result() on the return value to block on the call (returns an object containing the response data)
		return self.put_async().get_result()

	def delete(self):
		# call get_result() on the return value to block on the call (returns an object containing the response data)
		return self.delete_async().get_result()