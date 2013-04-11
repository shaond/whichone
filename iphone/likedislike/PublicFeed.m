//
//  PublicFeed.m
//  likedislike
//
//  Created by Herbert Yeung on 18/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PublicFeed.h"
#import "PhotoSource.h"
#import "PublicPollController.h"

static const NSTimeInterval TIMER_INTERVAL = 0.001;
static const NSInteger LOADING_LABEL_TAG = 102;

@implementation PublicFeed

- (void) updatePublicFeed
{
    // Display the Loading Label
    TTActivityLabel* loadingLabel = [[[TTActivityLabel alloc] initWithStyle:TTActivityLabelStyleBlackBezel] autorelease];
    loadingLabel.text = @"  Loading...";
    [loadingLabel sizeToFit];
    loadingLabel.frame = CGRectMake(10, 200, 300, 100);
    [loadingLabel setTag:LOADING_LABEL_TAG];
    [self.view addSubview:loadingLabel];  
    [self.view bringSubviewToFront:loadingLabel];

    //@TODO: POSSITBLE MEMORY LEAK - DOES NOT SEEM LIKE I CAN RELEASE IT
    /*if (timer) 
    {
        [timer release];
        timer = nil;
    }*/
    
    timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(stopTimer) userInfo:nil repeats:NO];
    
    /*if (loadingLabel) {
        [loadingLabel removeFromSuperview];
        [loadingLabel release];
    }*/
}

-(void) stopTimer 
{
    if (timer)
    {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            PhotoSource *photoSource = [[[PhotoSource alloc] init] autorelease];
 
            dispatch_async(dispatch_get_main_queue(), ^{
                self.photoSource = photoSource;
                UIView* label = [self.view viewWithTag:LOADING_LABEL_TAG];
                if (label) {
                    [label removeFromSuperview];
                }

            });            
        });

        
        /*PhotoSource *photoSource = [[[PhotoSource alloc] init] autorelease];
        self.photoSource = photoSource;
        
        UIView* label = [self.view viewWithTag:LOADING_LABEL_TAG];
        if (label) {
            [label removeFromSuperview];
        }*/
        
        //@TODO: POSSITBLE MEMORY LEAK - DOES NOT SEEM LIKE I CAN RELEASE IT
        //[timer invalidate];
        //[timer release];
        //timer = nil;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = NO;
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
    [self updatePublicFeed];
    
    
    // Adding refresh button
    /*UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"UIButtonBarRefresh.png"] style:UIBarButtonItemStylePlain target:self action:@selector(updatePublicFeed)];*/          
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] 
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
                                      target:self action:@selector(updatePublicFeed)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    [anotherButton autorelease];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES]; //This needs to be called in order for there not be scrolling
    //UIWindow *mWindow = self.view.window;
    //[[mWindow viewWithTag:8] setHidden:NO];    
}

- (void) viewWillDisappear:(BOOL)animated
{
    //UIWindow *mWindow = self.view.window;
    //[[mWindow viewWithTag:8] setHidden:YES];
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

// We want to override with like/dislike with two images side by side
- (TTPhotoViewController*) createPhotoViewController 
{   
    // Set the PublicPoll url Location
    PublicPollController *publicPollController = [[[PublicPollController alloc] init] autorelease];
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:publicPollController] autorelease];
    [navController setTitle:@"What's Hot"];
    publicPollController.navigationController.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"What's Hot" style: UIBarButtonItemStylePlain target: nil action: nil] autorelease];    
    [publicPollController setTitle:@"What's Hot"];
    [publicPollController.navigationController setTitle:@"What's Hot"];
    [self presentModalViewController:publicPollController.navigationController animated:NO]; 
 
    return publicPollController;
}

/*
 - (void)thumbsTableViewCell:(TTThumbsTableViewCell*)cell didSelectPhoto:(id<TTPhoto>)photo 
 {
 YourImageViewControler *controller =  [[[YourImageViewControler alloc] initWithNibName:nil bundle:nil] autorelease];
 
 //Set photo
 [self.navigationController pushViewController:controller animated:YES];
 }
*/

@end
