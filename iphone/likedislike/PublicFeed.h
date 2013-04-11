//
//  PublicFeed.h
//  likedislike
//
//  Created by Herbert Yeung on 18/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import <Three20/Three20.h>

@interface PublicFeed : TTThumbsViewController
{
    NSTimer *timer;
}

- (void) updatePublicFeed;
- (void) stopTimer;

@end
