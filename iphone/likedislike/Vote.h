//
//  Vote.h
//  likedislike
//
//  Created by Herbert Yeung on 30/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Poll, User;

@interface Vote : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * like;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) Poll *poll;
@property (nonatomic, retain) User *voter;

@end
