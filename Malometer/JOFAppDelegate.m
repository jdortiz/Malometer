//
//  JOFAppDelegate.m
//  Malometer
//
//  Created by Jorge D. Ortiz Fuentes on 02/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "JOFAppDelegate.h"
#import "JOFAgentsViewController.h"
#import "FreakType+Model.h"
#import "Agent+Model.h"


@interface JOFAppDelegate()

@property (readonly, strong, nonatomic) NSManagedObjectContext *rootMOC;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *backgroundMOC;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSNotificationCenter *notificationCenter;

@end



@implementation JOFAppDelegate

@synthesize rootMOC = _rootMOC;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize backgroundMOC = _backgroundMOC;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Constants & Parameters

static NSUInteger importedObjectCount = 10000;


#pragma mark - Application lifecycle

- (BOOL) application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [self registerForChangesInMOCNotifications];
    [self importDataInMOC:self.backgroundMOC];
    [self prepareRootViewController];
    return YES;
}


- (void) prepareRootViewController {
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    JOFAgentsViewController *controller = (JOFAgentsViewController *)navigationController.topViewController;
    controller.managedObjectContext = self.managedObjectContext;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
//    [self deregisterForChangesInMOCNotifications];
}


#pragma mark - Notifications

//- (void) registerForChangesInMOCNotifications {
//    [self.notificationCenter addObserver:self selector:@selector(mergeChangesSavedToContext:)
//                                    name:NSManagedObjectContextDidSaveNotification
//                                  object:self.backgroundMOC];
//}
//
//- (void) deregisterForChangesInMOCNotifications {
//    [self.notificationCenter removeObserver:self
//                                       name:NSManagedObjectContextDidSaveNotification
//                                     object:self.backgroundMOC];
//}
//

#pragma mark - Core Data operations

- (void) importDataInMOC:(NSManagedObjectContext *)moc {
    [moc performBlock:^{
        for (NSUInteger i = 0; i < importedObjectCount; i++) {
            FreakType *freakType = [FreakType freakTypeInMOC:moc
                                                    withName:@"Monster"];
            Agent *agent = [Agent agentInMOC:moc
                                    withName:[NSString stringWithFormat:@"Agent %u",i]];
            agent.category = freakType;
            usleep(5000000/importedObjectCount);
        }
        [moc save:NULL];
    }];
}
//
//
//- (void) mergeChangesSavedToContext:(NSNotification *)notification {
//    [self.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
//}
//

- (void) saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}


#pragma mark - Core Data stack

- (NSManagedObjectContext *) managedObjectContext {
    if (_managedObjectContext == nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _managedObjectContext.parentContext = self.rootMOC;
        [self prepareUndoManagerForContext:_managedObjectContext];
    }
    return _managedObjectContext;
}


- (NSManagedObjectContext *) rootMOC {
    if (_rootMOC == nil) {
        NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
        if (coordinator != nil) {
            _rootMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            _rootMOC.persistentStoreCoordinator = coordinator;
        }
    }
    return _rootMOC;
}


- (NSManagedObjectContext *) backgroundMOC {
    if (_backgroundMOC == nil) {
        _backgroundMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _backgroundMOC.parentContext = self.managedObjectContext;
    }
    return _backgroundMOC;
}


- (void) prepareUndoManagerForContext:(NSManagedObjectContext *)moc {
    moc.undoManager = [[NSUndoManager alloc] init];
    moc.undoManager.groupsByEvent = NO;
    moc.undoManager.levelsOfUndo = 10;
}


// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Malometer" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Malometer.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *lightweightOptions = @{ NSMigratePersistentStoresAutomaticallyOption: @YES,
                                          NSInferMappingModelAutomaticallyOption: @YES};
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:lightweightOptions error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}


#pragma mark - Lazy instantiation properties for dependency injection

- (NSNotificationCenter *) notificationCenter {
    if (_notificationCenter == nil) {
        _notificationCenter = [NSNotificationCenter defaultCenter];
    }
    return _notificationCenter;
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
