//
//  DocumentManager.h
//
//  Created by Luan-Ling Chiang on 11/27/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DocumentManager : NSObject
{
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
}
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;

- (NSManagedObjectContext *) managedObjectContext;
- (NSMutableArray*)fetchArrayFromDBWithEntity:(NSString*)entityName forKey:(NSString*)keyName withPredicate:(NSPredicate*)predicate;
+ (id) sharedInstance;
@end
