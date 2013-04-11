//
//  PhotoController.h
//  likedislike
//
//  Created by Herbert Yeung on 15/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainController.h"

#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.24299 //1.12412 for iOS 3.x
#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 480

@interface PhotoController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (void) cameraButtonPressed;
- (void) textFieldFinished;
- (void)timerFireMethod:(NSTimer*)theTimer;
- (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;

@end
