//
//  Photo.h
//  likedislike
//
//  Created by Herbert Yeung on 19/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


#import <Three20/Three20.h>

@interface Photo : NSObject <TTPhoto> {
	id<TTPhotoSource> _photoSource;
	NSString* _thumbURL;
	NSString* _smallURL;
	NSString* _URL;
	CGSize _size;
	NSInteger _index;
	NSString* _caption; 
    NSString* _poll_url;
}

- (id)initWithURL:(NSString*)URL smallURL:(NSString*)smallURL size:(CGSize)size pollURL:(NSString*)pollURL;

- (id)initWithURL:(NSString*)URL smallURL:(NSString*)smallURL size:(CGSize)size
		  caption:(NSString*)caption pollURL:(NSString*)pollURL;

@property(nonatomic, copy) NSString *_poll_url;

- (void) getAndSavePollData: (NSString*)pollID;

@end
