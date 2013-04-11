//
//  Poll.h
//  likedislike
//
//  Created by Herbert Yeung on 30/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Friend, User, Vote;

@interface Poll : NSManagedObject

@property (nonatomic, retain) NSString * created;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * img1;
@property (nonatomic, retain) NSString * img2;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) User *owner;
@property (nonatomic, retain) Vote *vote;
@property (nonatomic, retain) Friend *voter;

@end
