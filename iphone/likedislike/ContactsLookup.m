//
//  ContactsLookup.m
//  likedislike
//
//  Created by Herbert Yeung on 8/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactsLookup.h"
#import <AddressBook/AddressBook.h>
#import "SBJson.h"
#import "AppDelegate.h"
#import "User.h"
#import "MobileAuthenticator.h"

@implementation ContactsLookup
@synthesize contactsList;

-(NSString *) getContacts {
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef all = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex n = ABAddressBookGetPersonCount(addressBook);
    NSDictionary *dict = nil;
    NSString *post_str = nil;
    Boolean first = true;
    
    // We need to check whether uuid exists or there is no point sending contacts to the server
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDesc];
    NSError *error = nil;
    NSMutableArray *array = [[context executeFetchRequest:request error:&error] mutableCopy];
    if ([array count]) { 
        //json_str = @"[";
        User *usr = (User *)[array objectAtIndex:0];
        post_str = [[@"uuid=" stringByAppendingString:[usr uuid]] stringByAppendingString:@"&friends="];
        /*dict = [NSDictionary dictionaryWithObjectsAndKeys: [usr uuid], @"uuid", nil];
        json_str = [json_str stringByAppendingString:[dict JSONRepresentation]];
        json_str = [json_str stringByAppendingString:@","];*/
        
        for( int i = 0 ; i < n ; i++ )
        {
            ABRecordRef ref = CFArrayGetValueAtIndex(all, i);
            NSString *firstName = (NSString *)ABRecordCopyValue(ref, kABPersonFirstNameProperty);
            NSString *lastName = (NSString *)ABRecordCopyValue(ref, kABPersonLastNameProperty);
            
            ABMultiValueRef *phones = (ABMultiValueRef*)ABRecordCopyValue(ref, kABPersonPhoneProperty);
            for(CFIndex j = 0; j < ABMultiValueGetCount(phones); j++) {
                NSString *phoneLabel = @"";
                CFStringRef phoneNumberRef = nil;
                phoneLabel=(NSString*)ABMultiValueCopyLabelAtIndex(phones, j);
                if ([phoneLabel isEqualToString:@"_$!<Mobile>!$_"]) {
                    phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, j);
                    NSString *phoneNumber = (NSString *)phoneNumberRef;
                    NSString *formattedNumber = nil;
                    
                    if (phoneNumber) { //We need to make sure it is the right phone number format
                        MobileAuthenticator *mobAuth = [[[MobileAuthenticator alloc] init] autorelease];   
                        formattedNumber = [mobAuth simpleValidate:phoneNumber];
                    }
                    
                    if (formattedNumber) {
                        if (!first) {
                            post_str = [post_str stringByAppendingString:@","];
                        }
                        else {
                            post_str = [post_str stringByAppendingString:@"["];
                            first = false;
                        }
                        dict = [NSDictionary dictionaryWithObjectsAndKeys: formattedNumber, @"phone", nil];
                        post_str = [post_str stringByAppendingString:[dict JSONRepresentation]];
                        
                        //Keep track of mobile numbers
                        NSArray *nameArray = [NSArray arrayWithObjects:firstName, lastName, nil];
                        [contactsList setObject:nameArray forKey:formattedNumber];
                    }
                    if (phoneNumberRef) {
                        CFRelease(phoneNumberRef);
                    }
                }
                [phoneLabel release];
            }
            CFRelease(firstName);
            CFRelease(lastName);
            CFRelease(phones);
        }
        //Formulate a JSON object to be added
        post_str = [post_str stringByAppendingString:@"]"];
        NSLog(@"THE POST STRING IS: %@", post_str);
    }
    
    [array release];
    CFRelease(addressBook);
    CFRelease(all);
    return post_str;
}

-(void) validateContacts: (NSString*) mobileNum {
    
    NSString *validate_url = @"https://whichone.funkhq.com/get/friends";    
    NSURL *url = [NSURL URLWithString:validate_url];
    
    NSString *json_request = [self getContacts];
    
    if (json_request) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        NSData *requestData = [NSData dataWithBytes:[json_request UTF8String] length:[json_request length]];
        
        // Create a request object using the URL.
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:requestData];
        
        [NSURLConnection connectionWithRequest:[request autorelease] delegate:self];
    }
    
}

-(void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
        forAuthenticationChallenge: challenge];
    }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

-(BOOL) connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    if ([[protectionSpace authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        return YES;
    }
    return NO;
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //We get back a list of contacts to process
    NSMutableData *d = [[NSMutableData data] retain];
    [d appendData:data];
    
    NSString *rawJson = [[NSString alloc] initWithData:d encoding:NSASCIIStringEncoding];
    NSLog(@"Data: %@", rawJson);
    
    //@TODO Store the mobile values to Core Data for later processing
    NSDictionary *parsedJson = [rawJson JSONValue];
    NSArray *extractedData = [parsedJson valueForKey:@"phone"];
    for (int i = 0; i < [extractedData count]; i++) {
        NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:context];
        // @TODO Get the values for this contact stored in NSMutableDictionary
        NSArray *person = (NSArray *)[contactsList objectForKey:(NSString*)[extractedData objectAtIndex:i]];
        [newManagedObject setValue:[NSNumber numberWithBool:TRUE] forKey:@"registereduser"];
        [newManagedObject setValue:(NSString*)[extractedData objectAtIndex:i] forKey:@"phone"];
        [newManagedObject setValue:(NSString*)[person objectAtIndex:0] forKey:@"firstname"];
        [newManagedObject setValue:(NSString*)[person objectAtIndex:1] forKey:@"lastname"];
        
        NSError *error = nil;        
        if (![context save:&error]) {
            NSLog(@"Cannot save for some odd reason %@ -> %@", error, [error description]);
        }
    }
    [d release];
    [rawJson release];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Contacts Error received: %@", [error description]);
}

-(void) dealloc {
    [contactsList release];
}

-(id) init {
    contactsList = [[NSMutableDictionary alloc] init];
    return [super init];
}

@end
