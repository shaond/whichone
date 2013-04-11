//
//  User.h
//  likedislike
//
//  Created by Herbert Yeung on 30/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Poll, Vote;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSNumber * registered;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) Poll *poll;
@property (nonatomic, retain) Vote *vote;

@end
