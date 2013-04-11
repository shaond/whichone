//
//  PhotoSource.m
//  likedislike
//
//  Created by Herbert Yeung on 18/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoSource.h"
#import "Photo.h"
#import "SBJson.h"

@implementation PhotoSource
@synthesize title = _title, urlSource;

- (id)init {
	_title = @"What's Hot!";
    NSDictionary *whatshotPhotoSourceDict = [[self initPhotosLocation] autorelease]; //640x480
    
    // Get the objects you want, e.g. output the second item's client id
    NSArray *poll_items = [whatshotPhotoSourceDict valueForKeyPath:@"pk"];
    /*for (id poll_item in poll_items)
        NSLog(@" Poll Id : %@", poll_item);*/
    
    NSArray *thumbnail_items = [whatshotPhotoSourceDict valueForKeyPath:@"fields"];
    /*for (id th_item in thumbnail_items)
        NSLog(@" Thumbnail Id : %@", [th_item objectForKey:@"img1_thumb"]);*/

    
	// initial photos that are displayed
    if (_photos) {
        [_photos release];
        _photos = nil;
    }
    _photos = [[NSMutableArray alloc] init];
    NSUInteger counter = 0;
    NSString *str = nil;
    NSString *substring = nil;
    NSString* url_photo = nil;
    NSString* th_photo = nil;
    for (NSString* poll_item in poll_items)
    {
        str = (NSString*)[[thumbnail_items objectAtIndex:counter] objectForKey:@"img1_thumb"];
        substring = [str substringFromIndex:NSMaxRange([str rangeOfString: @"thumbnails/"])];
        url_photo = [@"https://whichone.funkhq.com/uploads/" stringByAppendingString:substring];
        th_photo = [@"https://whichone.funkhq.com/uploads/" stringByAppendingString:str];
        [_photos addObject:[[Photo alloc] initWithURL:url_photo smallURL:th_photo size:CGSizeMake(640, 480) pollURL:poll_item]];
        counter++;                                                                                                                          
    }
    
	for (int i = 0; i < _photos.count; ++i) {
		id<TTPhoto> photo = [_photos objectAtIndex:i];
		if ((NSNull*)photo != [NSNull null]) {
			photo.photoSource = self;
			photo.index = i;
		}
    }
	
	// more photos, these will be loaded when the 'Load More Photos' button is clicked
    morePhotos = nil;
    /*morePhotos = [[NSArray alloc] initWithObjects:
                  [[[Photo alloc]
                    initWithURL:@"http://farm4.static.flickr.com/3334/3334095096_ffdce92fc4.jpg"
                    smallURL:@"http://farm4.static.flickr.com/3334/3334095096_ffdce92fc4_t.jpg"
                    size:CGSizeMake(407, 500)] autorelease],
                  [[[Photo alloc]
                    initWithURL:@"http://farm4.static.flickr.com/3118/3122869991_c15255d889.jpg"
                    smallURL:@"http://farm4.static.flickr.com/3118/3122869991_c15255d889_t.jpg"
                    size:CGSizeMake(500, 406)] autorelease],
                  [[[Photo alloc]
                    initWithURL:@"http://farm2.static.flickr.com/1004/3174172875_1e7a34ccb7.jpg"
                    smallURL:@"http://farm2.static.flickr.com/1004/3174172875_1e7a34ccb7_t.jpg"
                    size:CGSizeMake(500, 372)] autorelease],
                  [[[Photo alloc]
                    initWithURL:@"http://farm3.static.flickr.com/2300/2179038972_65f1e5f8c4.jpg"
                    smallURL:@"http://farm3.static.flickr.com/2300/2179038972_65f1e5f8c4_t.jpg"
                    size:CGSizeMake(391, 500)] autorelease],
                  nil
                  ];*/
	
	for (int i = 0; i < morePhotos.count; ++i) {
		id<TTPhoto> photo = [morePhotos objectAtIndex:i];
		if ((NSNull*)photo != [NSNull null]) {
			photo.photoSource = self;
			photo.index = i;
		}
    }
	
	// set the total number of photos to the sum of _photos and morePhotos to show the 'Load More Photos' button
	total = _photos.count + morePhotos.count;
	
	return self;
}


- (NSDictionary*) initPhotosLocation
{
    NSURL *url = [NSURL URLWithString:@"https://whichone.funkhq.com/get/hot"];
    
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
        return nil;
    }
    
    // Convert the response data to a string.
    NSString *responseString = [[[NSString alloc] initWithData:responseData  encoding:NSUTF8StringEncoding] autorelease];
    
    // View the data returned - should be ready for parsing.
    NSLog(@"%@", responseString);
    
    // Parse the string into JSON
    NSDictionary *json = [responseString JSONValue];
    
    return json;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// TTPhotoSource

- (NSInteger)numberOfPhotos {
	return total;
}

- (NSInteger)maxPhotoIndex {
	return _photos.count-1;
}

- (id<TTPhoto>)photoAtIndex:(NSInteger)index {
	if (index < _photos.count) {
		id photo = [_photos objectAtIndex:index];
		if (photo == [NSNull null]) {
			return nil;
		} else {
			return photo;
		}
	} else {
		return nil;
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTModel

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
	NSInteger nextIndex = _photos.count;
	for (int i = 0; i < morePhotos.count; i++) {
		id<TTPhoto> photo = [morePhotos objectAtIndex:i];
		photo.photoSource = self;
		photo.index = nextIndex;
		if ((NSNull*)photo != [NSNull null]) {
			[_photos addObject:photo];
			nextIndex++;
		}
    }
	
	[self didFinishLoad];
}

-(void) dealloc
{
    if (_photos) {
        [_photos release];
    }
    [super dealloc];
}

@end



