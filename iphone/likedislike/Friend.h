//
//  Friend.h
//  likedislike
//
//  Created by Herbert Yeung on 30/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Poll;

@interface Friend : NSManagedObject

@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSNumber * registereduser;
@property (nonatomic, retain) Poll *poll;

@end
