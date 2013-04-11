//
//  PINValidationController.m
//  likedislike
//
//  Created by Herbert Yeung on 7/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PINValidationController.h"
#import "AppDelegate.h"
#import "SBJson.h"
#import "ContactsLookup.h"

@implementation PINValidationController

@synthesize mobilenum;

#pragma mark GCPINViewControllerDelegate
- (BOOL)pinView:(GCPINViewController *)pinView validateCode:(NSString *)code {
    
    // Get Code from following link:
	// Create the URL from a string.
    NSString *validate_mobile_link = [@"https://whichone.funkhq.com/validate/" stringByAppendingString:self.mobilenum];
    NSString *validate_url = [[validate_mobile_link stringByAppendingString:@"/"] stringByAppendingString:code];
    NSURL *url = [NSURL URLWithString:validate_url];
    
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
        return false;
    }
    
    // Convert the response data to a string.
    NSString *responseString = [[NSString alloc] initWithData:responseData  encoding:NSUTF8StringEncoding];
    
    // View the data returned - should be ready for parsing.
    NSLog(@"%@", responseString);

    //Check whether responseString (UUID) is > 30 chars
    if ([responseString length] > 30) {
        //Write to Core Data User that we are registered now
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSManagedObject *newManagedObject = 
        [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
        [newManagedObject setValue:responseString forKey:@"uuid"];
        NSError *error = nil;        
        if (![context save:&error]) {
            NSLog(@"Cannot save for some odd reason %@ -> %@", error, [error userInfo]);
            abort();
        }
        
        ContactsLookup *contactsLookup = [[ContactsLookup alloc] init];
        [contactsLookup validateContacts:self.mobilenum];
        
		[pinView dismissModalViewControllerAnimated:YES];
        //[self release];
        //[responseString release];
        
        // Let the device know we want to receive push notifications
#ifndef TARGET_IPHONE_SIMULATOR
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert)];
#endif
        
        return TRUE;
    }
    else {
        [responseString release];
        return FALSE;
    }
}

- (void) displayPIN {
    // setup pin view
    GCPINViewController *pinView = [[GCPINViewController alloc] initWithNibName:@"PINViewDefault" bundle:nil];
    pinView.delegate = self;
    pinView.messageText = @"Enter SMS PIN";
    pinView.title = @"PIN";
    pinView.errorText = @"Please try entering again the SMS PIN.";
    
    // show pin view
	[pinView presentViewFromViewController:[[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController] animated:NO];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*- (void)dealloc {
    [super dealloc];
}*/

@end
