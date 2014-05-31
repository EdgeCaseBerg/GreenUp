#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define theCoreDataController [coreDataController shared]

#define DATA_MODEL_NAME @"DataModel"

@interface coreDataController : NSObject

+ (coreDataController *) shared;

// Interacting with Core Data
#pragma mark - Main Core Data Methods

//Inserts
- (id) insertNewEntityWithName:(NSString *)entityName;
- (void) insertObject:(NSManagedObject *)_objectToInsert;

//Gets
- (NSArray *) fetchObjectsWithEntityName: (NSString *) _entityName
							   predicate: (NSPredicate *) _predicate
						 sortDescriptors: (NSArray *) _sortDescriptors
						  andBatchNumber: (int) _batchSize;
- (NSArray *) fetchAllObjectsWithEntityName: (NSString *) _entityName
						 andSortDescriptors: (NSArray *) _sortDescriptors;

//Deletes
- (void) deleteObject: (NSManagedObject *) _objectToDelete;
- (void) deleteAllObjectsWithEntityName: (NSString *) _entityName
						   andPredicate: (NSPredicate *) _predicate;


#pragma mark - Utility Methods
- (void) saveContext;
- (void) rollbackContext;
- (void) wipeDataStore;


@end
