//
//  AddressController.h
//  likedislike
//
//  Created by Herbert Yeung on 15/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface AddressController : UITableViewController <ABPeoplePickerNavigationControllerDelegate> {
    
}
- (IBAction)showPicker:(id)sender;

@end
