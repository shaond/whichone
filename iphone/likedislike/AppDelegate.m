//
//  AppDelegate.m
//  likedislike
//
//  Created by Herbert Yeung on 15/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#include "TargetConditionals.h"

#import "MainController.h"
#import "AddressController.h"
#import "RegistrationController.h"
#import "PublicFeed.h"
#import "User.h"
#import "Friend.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize mainController = _mainController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
     self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

     if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
         
#if TARGET_IPHONE_SIMULATOR
        if (FALSE) {
#else
        // Check if the device is registered
        NSManagedObjectContext *context = [self managedObjectContext];
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
        NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
        [request setEntity:entityDesc];
        NSError *error = nil;
        NSArray *array = [context executeFetchRequest:request error:&error];
             
        if (![array count]) { 
#endif
             RegistrationController *registrationUIViewController = [[RegistrationController alloc] initWithNibName:@"RegistrationController" bundle:nil];
             
             // Check country you are currently in
             NSString *exampleNumber = @"";
             NSLocale* currentLocale = [NSLocale currentLocale];  // get the current locale.
             NSString* countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
             if ([countryCode isEqualToString: @"AU"]) {
                 exampleNumber = @"e.g. +61423456789\n\n\n";
             }
             else if ([countryCode isEqualToString: @"NZ"]) {
                 exampleNumber = @"e.g. +6422345678\n\n\n";
             }
             else if ([countryCode isEqualToString: @"US"] || [countryCode isEqualToString: @"CA"]) {
                 exampleNumber = @"e.g. +12987654308\n\n\n";
             }
             else if([countryCode isEqualToString: @"GB"]) {
                 exampleNumber = @"e.g. +447123456789\n\n\n";
             }
             else if([countryCode isEqualToString: @"IN"]) {
                 exampleNumber = @"e.g. +911234567890\n\n\n";
             }
             else if([countryCode isEqualToString: @"IE"]) {
                 exampleNumber = @"e.g. +353812345678\n\n\n";
             }
         
            [registrationUIViewController displayRegistration:exampleNumber]; 
         }
         else {
             // Check if the device is registered
             NSManagedObjectContext *context = [self managedObjectContext];
             NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Friend" inManagedObjectContext:context];
             NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
             [request setEntity:entityDesc];
             NSError *error = nil;
             NSArray *array = [context executeFetchRequest:request error:&error];
             
             for (int i = 0; i < [array count]; i++) {
                 Friend *usr = (Friend *)[array objectAtIndex:i];
                 NSLog(@"Friend: %@, %@, %@", [usr firstname], [usr lastname], [usr phone]);
             }
         }
         
         /*self.mainController = [[[MainController alloc] initWithNibName:@"MainController" bundle:nil] autorelease];
         self.window.rootViewController = self.mainController;
         [self.window makeKeyAndVisible];*/

        //self.mainController = [[[MainController alloc] initWithNibName:@"MainController" bundle:nil] autorelease];
        self.window.rootViewController = self.mainController;
        [window addSubview:mainController.view];
        [window makeKeyAndVisible];    
        
    }
         
    // Let the device know we want to receive push notifications
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert)];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (void)dealloc
{
    [mainController release];
    [window release];
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [super dealloc];
}


#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    //NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"likedislike" withExtension:@"mom"];
    //__managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    __managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"likedislike.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
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
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
    
#pragma mark - Push Notifications
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
    
    NSString * tokenAsString = [[[deviceToken description] 
                                 stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] 
                                stringByReplacingOccurrencesOfString:@" " withString:@""];
    // Create the URL from a string.
    NSURL *url = [NSURL URLWithString:[@"https://whichone.funkhq.com/add/devicetoken/" stringByAppendingString:tokenAsString]];
    
    // Create a request object using the URL.
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Prepare for the response back from the server    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    // Send a synchronous request to the server (i.e. sit and wait for the response)
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Check if an error occurred    
    if (error != nil) {
        NSLog(@"%@", [error localizedDescription]);
        // Do something to handle/advise user.
        //return @"Error";
    }
    
    // Convert the response data to a string.
    NSString *responseString = [[NSString alloc] initWithData:responseData  encoding:NSUTF8StringEncoding];    
    // View the data returned - should be ready for parsing.
    NSLog(@"%@", responseString);
    [responseString release];

    
    
}
    
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

@end
