//
// Created by Farid on 21.05.16.
// Copyright (c) 2016 Farid. All rights reserved.
//

#import "Manager.h"
#import "AppDelegate.h"


@implementation Manager {
	QueriesManager *_queries;

	NSManagedObjectContext *_managedObjectContext;
	NSManagedObjectContext *_parentManagedObjectContext;
	NSManagedObjectModel *_managedObjectModel;
	NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}

+ (instancetype)sharedManager {
	static Manager *instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = (Manager *) [[self class] new];
	});
	return instance;
}

- (QueriesManager *)queries {
	if (!_queries) {
		_queries = [QueriesManager new];
	}
	return _queries;
}


#pragma mark - Core Data Stack

/*!
	Child context
	Used by UI
 */
- (NSManagedObjectContext *)managedObjectContext {
	if (_managedObjectContext != nil) {
		return _managedObjectContext;
	}

	_managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
	_managedObjectContext.parentContext = [self parentManagedObjectContext];

	return _managedObjectContext;
}

/*!
	Parent context
	Used as parent context for saving data
 */
- (NSManagedObjectContext *)parentManagedObjectContext {
	if (_parentManagedObjectContext != nil) {
		return _parentManagedObjectContext;
	}

	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (coordinator != nil) {
		_parentManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
		[_parentManagedObjectContext setPersistentStoreCoordinator:coordinator];
	}
	return _parentManagedObjectContext;
}


/*!
	Returns the managed object model for the application.
	If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
	if (_managedObjectModel != nil) {
		return _managedObjectModel;
	}
#pragma clang diagnostic push
#pragma ide diagnostic ignored "ResourceNotFoundInspection"
	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Afisha" withExtension:@"momd"];
	if (modelURL == nil) {
		modelURL = [[NSBundle mainBundle] URLForResource:@"Afisha" withExtension:@"mom"];
	}
#pragma clang diagnostic pop
	_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	return _managedObjectModel;
}

/*!
	Returns the persistent store coordinator for the application.
	If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	if (_persistentStoreCoordinator != nil) {
		return _persistentStoreCoordinator;
	}

	NSURL *applicationDocumentsDirectory = ((AppDelegate *) [UIApplication sharedApplication].delegate).applicationDocumentsDirectory;
	NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:@"iTunesSearch.sqlite"];

	NSError *error = nil;
	_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSMigratePersistentStoresAutomaticallyOption : @YES, NSInferMappingModelAutomaticallyOption : @YES} error:&error]) {
		[[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
#ifdef DEBUG
		NSLog(@"Unresolved error. Storage deleted.");
#endif
		if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
			abort();
		}
	}

	return _persistentStoreCoordinator;
}

- (void)saveContext {
	[self saveContext:nil];
}

- (void)saveContext:(void (^)())completion {
	__block NSError *error = nil;
	if (_managedObjectContext != nil) {
		if ([_managedObjectContext hasChanges]) {
			[_managedObjectContext performBlock:^{
				if (![_managedObjectContext save:&error]) {
#ifdef DEBUG
					NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
#endif
					abort();
				}
				if (completion) {
					completion();
				}
				if ([_parentManagedObjectContext hasChanges]) {
					[_parentManagedObjectContext performBlock:^{
						if (![_parentManagedObjectContext save:&error]) {
#ifdef DEBUG
							NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
#endif
							abort();
						}
					}];
				}
			}];
		} else if (completion) {
			completion();
		}
	}
}

@end