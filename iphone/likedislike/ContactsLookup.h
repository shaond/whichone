//
//  ContactsLookup.h
//  likedislike
//
//  Created by Herbert Yeung on 8/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactsLookup : NSObject <NSURLConnectionDelegate> {
    NSMutableDictionary *contactsList;
}
@property (nonatomic, retain) NSMutableDictionary *contactsList;

-(NSString *) getContacts;
-(void) validateContacts: (NSString*) mobileNum;
@end
