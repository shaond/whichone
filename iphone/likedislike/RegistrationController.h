//
//  RegistrationController.h
//  likedislike
//
//  Created by Herbert Yeung on 27/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationController : UIViewController <UIAlertViewDelegate>
{
    UITextField *mobileField; 
    
}
-(void)displayRegistration : (NSString *) message;
-(void)removeRegistraton;

@end
