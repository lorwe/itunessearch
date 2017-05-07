//
// Created by Farid on 21.05.16.
// Copyright (c) 2016 Farid. All rights reserved.
//

#import "ITSCoreDataStore.h"


@implementation ITSCoreDataStore {
	NSManagedObjectContext *_managedObjectContext;
	NSManagedObjectContext *_parentManagedObjectContext;
	NSManagedObjectModel *_managedObjectModel;
	NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}

- (instancetype)init {
	self = [super init];
	if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(saveContext)
													 name:UIApplicationWillTerminateNotification
												   object:nil];
	}

	return self;
}


#pragma mark - Core Data Stack

- (NSURL *)applicationDocumentsDirectory {
	return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectContext *)managedObjectContext {
	if (_managedObjectContext != nil) {
		return _managedObjectContext;
	}

	_managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
	_managedObjectContext.parentContext = [self parentManagedObjectContext];

	return _managedObjectContext;
}

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

- (NSManagedObjectModel *)managedObjectModel {
	if (_managedObjectModel != nil) {
		return _managedObjectModel;
	}
#pragma clang diagnostic push
#pragma ide diagnostic ignored "ResourceNotFoundInspection"
	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iTunesSearch" withExtension:@"momd"];
	if (modelURL == nil) {
		modelURL = [[NSBundle mainBundle] URLForResource:@"iTunesSearch" withExtension:@"mom"];
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

	NSURL *applicationDocumentsDirectory = [self applicationDocumentsDirectory];
	NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:@"iTunesSearch.sqlite"];

	NSError *error = nil;
	_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES} error:&error]) {
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