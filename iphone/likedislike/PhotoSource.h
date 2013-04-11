//
//  PhotoSource.h
//  likedislike
//
//  Created by Herbert Yeung on 18/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import <Three20/Three20.h>

#import <Three20/Three20.h>


@interface PhotoSource : TTModel <TTPhotoSource> {
    NSString* _title;
	NSMutableArray* _photos;
	NSArray* morePhotos;
	NSInteger total;
    NSURL *urlSource;
}

@property (nonatomic, retain) NSURL *urlSource;

-(NSDictionary*) initPhotosLocation;

@end
