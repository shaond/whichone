//
//  TapDetectingPhotoView.h
//  likedislike
//
//  Created by Herbert Yeung on 26/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import <Three20/Three20.h>
#import "OpinionAreaView.h"

@protocol TapDetectingPhotoViewDelegate;

@interface TapDetectingPhotoView : TTPhotoView <OpinionAreaViewDelegate> {
    NSArray *sensibleAreas;
    id <TapDetectingPhotoViewDelegate> tappableAreaDelegate;
    NSString *pollID;
    BOOL _centerPoll; // Used to track the current Poll we are on
}

@property (nonatomic, retain) NSArray *sensibleAreas;
@property (nonatomic, copy) NSString *pollID;
@property (nonatomic, assign) id <TapDetectingPhotoViewDelegate> tappableAreaDelegate;
@property (nonatomic, assign) BOOL centerPoll;

- (id) initWithPhoto:(NSString*)poll_ID;
- (BOOL) isDualPicPoll: (NSString*) poll_ID;
- (NSMutableArray*) imagesFromPoll: (NSString*) poll_ID;

@end


@protocol TapDetectingPhotoViewDelegate <NSObject>
@required
- (void)tapDidOccurOnSensibleAreaWithId:(NSUInteger*)ids;
@end