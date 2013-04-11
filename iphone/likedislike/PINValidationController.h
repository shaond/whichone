//
//  PINValidationController.h
//  likedislike
//
//  Created by Herbert Yeung on 7/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPINViewController.h"

@interface PINValidationController : UIViewController <GCPINViewControllerDelegate>

@property(nonatomic,retain) NSString* mobilenum;
-(void) displayPIN;
@end
