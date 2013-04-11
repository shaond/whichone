//
//  PublicPoll.h
//  likedislike
//
//  Created by Herbert Yeung on 20/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import "TapDetectingPhotoView.h"

@interface PublicPollController : TTPhotoViewController <TTScrollViewDelegate, TapDetectingPhotoViewDelegate>
{
    NSURL *urlLocation;
    NSArray *images;
    NSString *pollID;
}

@property (nonatomic, retain) NSURL *urlLocation;
@property (nonatomic, retain) NSArray *images;
@property (nonatomic, copy) NSString *pollID;

@end
