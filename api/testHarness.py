'''
	Classes, methods and handlers used to test various aspects of the datastore and memecache.
'''

import logging 
from handlerBase import *
from datastore import *
import pickle
import random
from random import shuffle
import json

class DummyData():
	# used to seed datastore with dummy data
	def __init__(self):

		# delete the datastore entities before we make new ones
		db.delete(db.Query(keys_only=True))

		stringSeed = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
		splt = stringSeed.split(' ')
		
		inputFloats = []
		inputStrings = []
		commentInputTypes = []
		inputSeconds = []
		pinsInputTypes = []

		for i in range(1,100):
			inputFloats.append( float( "{0:.7f}".format(random.uniform(0.0, 2.0)) ) )
			inputSeconds.append( float(random.uniform(0.0, 10)) )
			inputStrings.append( splt[int(random.uniform(0, len(splt)))] )
			commentInputTypes.append( COMMENT_TYPES[int(random.uniform(0, len(COMMENT_TYPES)))] )
			pinsInputTypes.append( PIN_TYPES[int(random.uniform(0, len(PIN_TYPES)))] )

		# write dummy data to the datastore through the abstraction layer
		al = AbstractionLayer()

		for i in range(0,99):		
			al.submitComments(commentInputTypes[i%len(commentInputTypes)], inputStrings[i%len(inputStrings)])
			# al.updateHeatmap(inputFloats[i], inputFloats[i], inputSeconds[i])
			al.submitPin(inputFloats[i], inputFloats[i], pinsInputTypes[i%len(pinsInputTypes)], inputStrings[i%len(inputStrings)])

			shuffle(pinsInputTypes)
			shuffle(commentInputTypes)
			shuffle(inputStrings)
			shuffle(inputSeconds)


class WriteTest(Handler):
	def get(self):
		self.write("Got here to the write handler. The should be some data in the datastore now.")
		d = DummyData()
		# result = getCachedData('pins')
		# logging.info(result)

class ReadTest(Handler):
	def get(self):
		self.write("got here to the read handler")
		al = AbstractionLayer()
		# pins = al.getPins(latDegrees = 1.76, offset=3, precision = 3)
		pins = al.getPins()
		jp = json.dumps(pins)
		logging.info(pins)

class MemecacheViewer(Handler):
	def get(self):
		# NOTE: can't go over 5 pages, because there are only 100 dummy items in the datastore.
		# self.write("hello there, check the logs")
		# result = getCachedData('pins')
		# for r in result:
		# 	logging.info( r.message )
		# memcache.flush_all()

		results = paging(1, 'FORUM')
		logging.info(results)
		# results = paging(5)
		# logging.info(results)
		
		for r in results:
			print r.message

		# initialPage()
		# entities = deserialize_entities(memcache.get("greenup_comments_page_1"))
		# for e in entities:
		# 	print e

import time
import platform

class MemcacheVsDatastore(webapp2.RequestHandler):
	def get(self):
		#This primes the pump for any non-unix machines (http://docs.python.org/2/library/time.html)
		if( platform.system().lower().find("win") > -1 and platform.system().lower().find("win") < 3):
			#win < 3 because of darwin
			time.clock()

		#delete the datastore entities
		db.delete(db.Query(keys_only=True))

		#Place a single entity into the datastore
		firstPin = Pins(parent = app_key(), lat=0.0,lon=2.3).put()
		fpID = firstPin.id()
		
		#time how long it takes to retrieve the pin from the datastore using it's key id
		#We use 1000 times to really make a difference
		beforeTime = time.clock()
		for i in range(0,1000):
			Pins.by_id(fpID)
		afterTime = time.clock()
		datastoreRetrieval1 = (afterTime - beforeTime)/1000


		#Place the same entiry into the memcache
		setData(str(fpID),firstPin)
		beforeTime = time.clock()
		for i in range(0,1000):
			getData(str(fpID))
		afterTime = time.clock()

		memcacheRetrieval1 = (afterTime - beforeTime)/1000

		logging.info("First Round of tests done. ")
		logging.info("Results: Datastore: %s Memcache: %s" % (str(datastoreRetrieval1),str(memcacheRetrieval1)))
		
		#Add 100,000 entries to the datastore and construct the entity that will be placed into the memcache
		logging.info("Creating 100,000 Datastore entities")
		memPins = []
		for i in range(0,100000):
			pins = Pins(parent = app_key(), lat= 1.1, lon= 1.2)
			memPins.append(pins)
			pins.put()
			setData(str(fpID),pins)
		logging.info("Finished creating 100,000 datastore entities")

		
		#Now time how long it takes to retrieve a pin	
		#From the datastore
		beforeTime = time.clock()
		for i in range(0,1000):
			Pins.by_id(fpID)
		afterTime = time.clock()
		datastoreRetrieval2 = (afterTime - beforeTime)/1000
		
		#From the memcache
		beforeTime = time.clock()
		for i in range(0,1000):
			getData(str(fpID))
		afterTime = time.clock()
		memcacheRetrieval2 = (afterTime - beforeTime)/1000

		logging.info("Second Round of tests done. ")
		logging.info("Results: Datastore: %s Memcache %s" % (str(datastoreRetrieval2),str(memcacheRetrieval2)))
		
		#Now we need to know how long it takes to serialize and deserialize the memcache
		f = open('datafile','w')
		beforeTime = time.clock()
		pickle.dump(memPins,f)
		afterTime = time.clock()
		timeToSerialize = beforeTime - afterTime

		a = open('datafile','r')
		beforeTime = time.clock()
		pickle.load(a)
		afterTime = time.clock()
		timeToLoad = beforeTime - time.clock()

		#Display results in log
		logging.info("Serialization Test Complete")
		logging.info("Writing: %s " % str(timeToSerialize))
		logging.info("Reading: %s " % str(timeToLoad))