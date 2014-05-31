#import "coreDataController.h"

static coreDataController *sharedCoreDataController;

@interface coreDataController ()

@property (nonatomic, strong) NSMutableDictionary *backgroundContexts;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

@end

@implementation coreDataController

@synthesize backgroundContexts;
@synthesize managedObjectContext, persistentStoreCoordinator, managedObjectModel;

#pragma mark - Singleton Accessor and Constructor

- (coreDataController *) init
{
	if (self = [super init])
	{
		self.backgroundContexts = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

+ (coreDataController *) shared
{
	if (sharedCoreDataController == nil)
	{
		sharedCoreDataController = [[coreDataController alloc] init];
	}
	
	return sharedCoreDataController;
}

#pragma mark - Core Data

- (NSManagedObjectModel *) managedObjectModel
{
	if(managedObjectModel != nil)
	{
		return managedObjectModel;
	}
	
	// We use +bundleForClass: here rather that +mainBundle because the mainBundle is not accessible when doing logic unit tests
	NSURL *modelURL = [[NSBundle bundleForClass: [self class]] URLForResource: DATA_MODEL_NAME withExtension: @"momd"];
	managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL: modelURL];
	
	return managedObjectModel;
}

- (NSManagedObjectContext *) managedObjectContext
{
	if (managedObjectContext != nil)
	{
		return managedObjectContext;
	}
	
	NSPersistentStoreCoordinator *thePersistentStoreCoordinator = self.persistentStoreCoordinator;
	if (thePersistentStoreCoordinator != nil)
	{
		managedObjectContext = [[NSManagedObjectContext alloc] init];
		[managedObjectContext setPersistentStoreCoordinator: thePersistentStoreCoordinator];
	}
	
	return managedObjectContext;
}

- (void) addPersistentStoreToCoordinator
{
	NSString *storeFilename = [NSString stringWithFormat: @"%@.sqlite", @"dataStore"];
	NSURL *applicationLibraryDirURL = [[[NSFileManager defaultManager] URLsForDirectory: NSLibraryDirectory inDomains: NSUserDomainMask] lastObject];
	NSURL *sourceStoreURL = [applicationLibraryDirURL URLByAppendingPathComponent: storeFilename];

	NSError *error = nil;
	[persistentStoreCoordinator addPersistentStoreWithType: NSSQLiteStoreType configuration: nil URL: sourceStoreURL options: nil error: &error];
	if (error != nil)
	{
		NSLog(@"ERROR: %@", error.localizedDescription);
	}
}

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator
{
	if (persistentStoreCoordinator != nil)
	{
		return persistentStoreCoordinator;
	}
	
	self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: self.managedObjectModel];
	[self addPersistentStoreToCoordinator];
	
	return persistentStoreCoordinator;
}

#pragma mark - Main Core Data Methods

- (id) insertNewEntityWithName:(NSString *)entityName
{
	NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entityName inManagedObjectContext: self.managedObjectContext];
	NSAssert(entityDesc != nil, @"Unable to create NSManagedObject for entity %@", entityName);
	
	NSManagedObject *insertedObject = [[NSManagedObject alloc] initWithEntity: entityDesc insertIntoManagedObjectContext: self.managedObjectContext];
	return insertedObject;
}

- (void) insertObject:(NSManagedObject *)_objectToInsert
{
	[self.managedObjectContext insertObject: _objectToInsert];
}

- (void) deleteObject: (NSManagedObject *) _objectToDelete
{
	[self.managedObjectContext deleteObject: _objectToDelete];
}

- (NSArray *) fetchObjectsWithEntityName: (NSString *) _entityName
							   predicate: (NSPredicate *) _predicate
						 sortDescriptors: (NSArray *) _sortDescriptors
						  andBatchNumber: (int) _batchSize
{
	// This is the main "fetch" method.  All other fetch methods call this one.
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName: _entityName];
	fetchRequest.fetchBatchSize = _batchSize;
	fetchRequest.returnsObjectsAsFaults = NO;
	
	NSError *error = nil;
	NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest: fetchRequest error: &error];
	if (error == nil)
	{
		if (_predicate != nil)
		{
			fetchedObjects = [fetchedObjects filteredArrayUsingPredicate: _predicate];
		}
		
		if (_sortDescriptors != nil)
		{
			fetchedObjects = [fetchedObjects sortedArrayUsingDescriptors: _sortDescriptors];
		}
	}
	else
	{
		NSLog(@"ERROR: Could not complete fetch request for %@! %@", _entityName, error.localizedDescription);
	}
	
	return fetchedObjects;
}

- (NSArray *) fetchAllObjectsWithEntityName: (NSString *) _entityName
						 andSortDescriptors: (NSArray *) _sortDescriptors
{
	NSArray *fetchedObjects = [self fetchObjectsWithEntityName: _entityName
													 predicate: nil
											   sortDescriptors: _sortDescriptors
												andBatchNumber: 0];
    

	
	return fetchedObjects;
}

- (void) deleteAllObjectsWithEntityName: (NSString *) _entityName
						   andPredicate: (NSPredicate *) _predicate
{
	NSArray *objectsToDelete = [self fetchObjectsWithEntityName: _entityName
													  predicate: _predicate
												sortDescriptors: nil
												 andBatchNumber: 0];
	
	for (NSManagedObject *anObjectToDelete in objectsToDelete)
	{
		[self.managedObjectContext deleteObject: anObjectToDelete];
	}
}


#pragma mark - Utility Methods
- (void) saveContext
{
	NSError *error = nil;
	[self.managedObjectContext save: &error];
	if (error != nil)
	{
		NSLog(@"ERROR: Unable to save context!  %@", error.localizedDescription);
	}
}

-(void)rollbackContext
{
	[self.managedObjectContext rollback];
}

-(void)wipeDataStore
{
	if (self.persistentStoreCoordinator.persistentStores.count != 1)
	{
		NSLog(@"ERROR: Invalid number of persistent stores (%d) detect in persistent store coordinator", self.persistentStoreCoordinator.persistentStores.count);
		return;
	}

	NSPersistentStore *persistentStoreToWipe = [self.persistentStoreCoordinator.persistentStores objectAtIndex: 0];
	
	NSError *error = nil;
	[self.persistentStoreCoordinator removePersistentStore: persistentStoreToWipe error: &error];
	if (error != nil)
	{
		NSLog(@"ERROR: Persistent Store could not be removed! %@", error.localizedDescription);
		return;
	}

	[[NSFileManager defaultManager] removeItemAtURL: persistentStoreToWipe.URL error: &error];
	if (error != nil)
	{
		NSLog(@"ERROR: Unable to remove persistent store .sqlite file! %@", error.localizedDescription);
		return;
	}
	
	[self addPersistentStoreToCoordinator];
}


@end
