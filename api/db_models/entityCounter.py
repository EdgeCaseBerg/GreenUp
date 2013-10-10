from google.appengine.ext import db

# manage the EntityCounter class
def increment(caller):
	ec = EntityCounter()
	ec.setType(caller)
	keyName = "caller_%s" %(caller)
	q = EntityCounter.get_or_insert(key_name=keyName, entityType=caller)
	ec.increment(q.key())

def decrement(caller):
	ec = EntityCounter()
	ec.setType(caller)
	q = EntityCounter.all().filter('entityType =', caller).get()

	if q is not None:
		# an entityCounter object with this type does exist. all is well
		ec.decrement(q.key())
	else:
		# and EntityCounter for this type doesn't exist in the datastore. How did this happen?
		# it can happen because we can ask to delete something that doesn't exist. -E. --the spider does it
		#raise Exception("Trying to decrement from a non-existant entityCounter type")	
		pass #removed raise becuase it causes a problem with spider.

class EntityCounter(db.Model):
	# inherits from db.model to avoid running the counting callbacks on itself
	entityType = db.StringProperty()
	entityCount = db.IntegerProperty(default=0)

	def setType(self, callerType):
		self.entityType = callerType

	@db.transactional
	def increment(self, key, amount=1):
		# Doing the read, calculation, and write in a single transaction ensures that no other process can interfere with the increment
		obj = db.get(key)
		obj.entityCount += amount
		obj.put()

	@db.transactional
	def decrement(self, key, amount=1):
		obj = db.get(key)
		obj.entityCount -= amount
		obj.put()

	@classmethod
	def count(cls, eType):
		ec = EntityCounter.all().filter('entityType =', eType).get()	
		if ec:
			return ec.entityCount
		return 1