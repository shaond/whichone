//
//  Authenticator.h
//  likedislike
//
//  Created by Herbert Yeung on 3/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MobileAuthenticator : NSObject

-(NSString *) simpleValidate: (NSString *) mobileNumber;
-(NSString *) getPINValue: (NSString *) mobileNumber; 

@end
