//
//  Photo.m
//  likedislike
//
//  Created by Herbert Yeung on 19/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Photo.h"
#import "AppDelegate.h"
#import "SBJson.h"

@implementation Photo

@synthesize photoSource = _photoSource, size = _size, index = _index, caption = _caption, _poll_url;

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithURL:(NSString*)URL smallURL:(NSString*)smallURL size:(CGSize)size  pollURL:(NSString*)pollURL{
	return [self initWithURL:URL smallURL:smallURL size:size caption:nil pollURL:pollURL];
}

- (id)initWithURL:(NSString*)URL smallURL:(NSString*)smallURL size:(CGSize)size
		  caption:(NSString*)caption pollURL: (NSString*) pollURL {
	if (self = [super init]) {
		_photoSource = nil;
		_URL = [URL copy];
		_smallURL = [smallURL copy];
		_thumbURL = [smallURL copy];
		_size = size;
		_caption = [caption copy];
        _poll_url = [pollURL copy];
		_index = NSIntegerMax;
        
        [self getAndSavePollData:pollURL];
	}
	return self;
}

- (void) getAndSavePollData: (NSString*)pollID
{
    NSURL *url = [NSURL URLWithString:[@"https://whichone.funkhq.com/get/poll/" stringByAppendingString:pollID]];
    
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
        return;
    }
    
    // Convert the response data to a string.
    NSString *responseString = [[[NSString alloc] initWithData:responseData  encoding:NSUTF8StringEncoding] autorelease];
    
    // View the data returned - should be ready for parsing.
    NSLog(@"%@", responseString);
    
    // Parse the string into JSON
    /*NSDictionary *json = [responseString JSONValue];*/
    
    
    // Save this data to DB for later retrieval
    // JSON get from: /get/poll/poll_id
    /*NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Poll" inManagedObjectContext:context];
    [newManagedObject setValue:@"test" forKey:@"owner"];
    [newManagedObject setValue:[json valueForKey:@"img1"] forKey:@"img1"];
    [newManagedObject setValue:[json valueForKey:@"img2"] forKey:@"img2"];
    [newManagedObject setValue:[json valueForKey:@"desc"] forKey:@"desc"];
    [newManagedObject setValue:[json valueForKey:@"pk"] forKey:@"id"];
    
    if (![context save:&error]) {
        NSLog(@"Cannot save pol data: %@ -> %@", error, [error userInfo]);
        return;
    }*/

}

- (void)dealloc {
	TT_RELEASE_SAFELY(_URL);
	TT_RELEASE_SAFELY(_smallURL);
	TT_RELEASE_SAFELY(_thumbURL);
	TT_RELEASE_SAFELY(_caption);
    TT_RELEASE_SAFELY(_poll_url);
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTPhoto

- (NSString*)URLForVersion:(TTPhotoVersion)version {
	if (version == TTPhotoVersionLarge) {
		return _URL;
	} else if (version == TTPhotoVersionMedium) {
		return _URL;
	} else if (version == TTPhotoVersionSmall) {
		return _smallURL;
	} else if (version == TTPhotoVersionThumbnail) {
		return _thumbURL;
	} else {
		return nil;
	}
}

- (NSString*) getPollURL
{
    return _poll_url;
}

@end
