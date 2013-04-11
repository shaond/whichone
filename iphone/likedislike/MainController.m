//
//  MainController.m
//  likedislike
//
//  Created by Herbert Yeung on 22/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MainController.h"
#import "PhotoController.h"

@implementation MainController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        /*UIAlertView *mobileEntryAlert = [[UIAlertView alloc] init];
        [mobileEntryAlert setTitle:@"Enter Mobile Number"];
        [mobileEntryAlert setMessage:@"e.g. +61425201441\n\n\n"];
        [mobileEntryAlert addButtonWithTitle:@"Get Unlock PIN"];
        
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
    [self addCenterButtonWithImage];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage
{
    UIImage *buttonImage = [UIImage imageNamed:@"camera_button_take.png"];
    UIImage *highlightImage = [UIImage imageNamed:@"tabBar_cameraButton_ready_matte.png"];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [button setTag:8];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }

    //Associate an IBAction as event listener
    //[button addTarget:self action:@selector(createVote) forControlEvents:UIControlEventTouchUpInside];
    /*if (!photoController) 
    {
        photoController = [[PhotoController alloc] initWithNibName:@"PhotoController" bundle:nil];
    }*/
    
    //[button addTarget:photoController action:@selector(cameraButtonPressed) forControlEvents: UIControlEventTouchUpInside];      
    [button addTarget:self action:@selector(createVote) forControlEvents: UIControlEventTouchUpInside];      

    [self.view addSubview:button];
}

- (void)createVote 
{
    //Invoke the PhotoController  
    //PhotoController *photoController = [[PhotoController alloc] init];
    //[photoController cameraButtonPressed];
    //[self presentModalViewController:photoController animated:YES];
    [self setSelectedIndex:2];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:TRUE];
    [self setSelectedIndex:0];    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc
{
    [super dealloc];
    [button release];
}

@end
