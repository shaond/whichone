//
//  MainController.h
//  likedislike
//
//  Created by Herbert Yeung on 15/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoController.h"

@interface MainController : UITabBarController  {
    //IBOutlet UIView *displayRegistration;
    UIButton *button;
}

// Create an event listener so that we can replace with PhotoController
-(void) createVote;

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage;

@end
