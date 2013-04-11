//
//  RegistrationController.m
//  likedislike
//
//  Created by Herbert Yeung on 27/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RegistrationController.h"
#import "MobileAuthenticator.h"
#import "PINValidationController.h"

@implementation RegistrationController


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // There is only 'Unlock PIN' button
    if(buttonIndex == 0) {
        // Get PIN
        MobileAuthenticator *mobileAuth = [[MobileAuthenticator alloc] init];
        NSString *result = [mobileAuth getPINValue:[mobileField text]];
        [mobileAuth release];
        [mobileField release];
        
        if ([result isEqualToString: @"Error"]) {
            //[self removeRegistraton];
            [self displayRegistration:@"You have entered an incorrect mobile number. Please try again.\n\n\n"];   
        }
        else {
            PINValidationController *pinValidationController = [[PINValidationController alloc] init];
            [pinValidationController setMobilenum:result];
            [pinValidationController displayPIN];
            //[pinValidationController release];
        }
    }
}

-(void)displayRegistration:(NSString *)message
{
    
    UIAlertView *mobileEntryAlert = [[UIAlertView alloc] initWithTitle:@"Enter Your Mobile Number" message:nil
                                                              delegate:self cancelButtonTitle:nil otherButtonTitles:@"Get SMS PIN", nil];
    
    [mobileEntryAlert setMessage:message];
    mobileField = [[UITextField alloc] initWithFrame:CGRectMake(16,88,252,25)];
    mobileField.borderStyle = UITextBorderStyleRoundedRect;
    mobileField.keyboardType = UIKeyboardTypePhonePad;
    mobileField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [mobileField becomeFirstResponder];
    [mobileEntryAlert addSubview:mobileField];
    
    [mobileEntryAlert show];
    [mobileEntryAlert release];
}

-(void)removeRegistraton
{
    [[self modalViewController] dismissModalViewControllerAnimated:YES];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        /*UIAlertView *mobileEntryAlert = [[UIAlertView alloc] initWithTitle:@"Enter Mobile Number" message:@"e.g. +61425201441\n\n\n" delegate:self cancelButtonTitle:@"Reset" otherButtonTitles:@"Get Unlock PIN", nil];

        UITextField *mobileField = [[UITextField alloc] initWithFrame:CGRectMake(16,83,252,25)];
        mobileField.font = [UIFont systemFontOfSize:16];
        mobileField.borderStyle = UITextBorderStyleRoundedRect;
        mobileField.keyboardType = UIKeyboardTypePhonePad;
        //mobileField.keyboardType = UIKeyboardTypeNumberPad;
        mobileField.keyboardAppearance = UIKeyboardAppearanceAlert;
        [mobileField becomeFirstResponder];
        [mobileEntryAlert addSubview:mobileField];
        
        [mobileEntryAlert show];
        [mobileEntryAlert release];
        [mobileField release];*/
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
