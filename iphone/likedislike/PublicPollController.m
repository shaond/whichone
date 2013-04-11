//
//  PublicPoll.m
//  likedislike
//
//  Created by Herbert Yeung on 20/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PublicPollController.h"
#import "TapDetectingPhotoView.h"
#import "Photo.h"

@implementation PublicPollController

@synthesize urlLocation, images, pollID;

-(void) viewDidLoad
{
    [super viewDidLoad];
}

-(void) viewWillDisappear:(BOOL)animated
{
    UIWindow *mWindow = self.view.window;
    [[mWindow viewWithTag:8] setHidden:NO];
}


- (TTPhotoView*)createPhotoView {
    // Get the details of the photo poll UID
    Photo *currentPhoto = (Photo*)[self centerPhoto];
    
    TapDetectingPhotoView *photoView = [[TapDetectingPhotoView alloc] initWithPhoto:[currentPhoto _poll_url]];
    photoView.tappableAreaDelegate = self;
    
    
    return [photoView autorelease];
}

/*- (TapDetectingPhotoView*)createPhotoView {
    // Get the details of the photo poll UID
    Photo *currentPhoto = (Photo*)[self centerPhoto];
    
    TapDetectingPhotoView *photoView = [[TapDetectingPhotoView alloc] initWithPhoto:[currentPhoto _poll_url]];
    photoView.tappableAreaDelegate = self;
    
    
    return [photoView autorelease];
}*/


#pragma mark -
#pragma mark TTPhotoViewController

- (void)didMoveToPhoto:(id<TTPhoto>)photo fromPhoto:(id<TTPhoto>)fromPhoto {
    [super didMoveToPhoto:photo fromPhoto:fromPhoto];
    
    //@TODO - Figure out how to use the previousPhotoView when swiping to clear contents
    //TapDetectingPhotoView *previousPhotoView = (TapDetectingPhotoView *)[_scrollView pageAtIndex:fromPhoto.index];
    TapDetectingPhotoView *currentPhotoView = (TapDetectingPhotoView *)[_scrollView pageAtIndex:photo.index];
    
    // destroy sensible areas from previous photoview, because photo could be reused by TTPhotoViewController!
    /*if (previousPhotoView)
        previousPhotoView.sensibleAreas = nil;*/
    
    // if sensible areas has not been already created, create new
    if (currentPhotoView && currentPhotoView.sensibleAreas == nil) {
        currentPhotoView.sensibleAreas = [[self.images objectAtIndex:photo.index] valueForKey:@"aMap"];
        //[self showSensibleAreas:YES animated:YES]; //BROKEN
    }
}


// We are overriding this so that we can keep track of POLL ID
- (UIView*)scrollView:(TTScrollView*)scrollView pageAtIndex:(NSInteger)pageIndex {
    TapDetectingPhotoView* photoView = (TapDetectingPhotoView*)[_scrollView dequeueReusablePage];
    if (!photoView) {
        photoView = (TapDetectingPhotoView*) [self createPhotoView];
        photoView.captionStyle = _captionStyle;
        photoView.defaultImage = _defaultImage;
        photoView.hidesCaption = _toolbar.alpha == 0;

        if (pageIndex == [scrollView centerPageIndex])
            photoView.centerPoll = true;  
        else
            photoView.centerPoll = false;  
        //photoView.pollID = pollID;
    }
    
    id<TTPhoto> photo = [_photoSource photoAtIndex:pageIndex];
    [self showPhoto:photo inView:photoView];
    
    return photoView;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
/*- (void)showPhoto:(id<TTPhoto>)photo inView:(TTPhotoView*)photoView {
    photoView.photo = photo;
    if (!photoView.photo && _statusText) {
        [photoView showStatus:_statusText];
    }
}*/



#pragma mark -
#pragma mark TappablePhotoViewDelegate

// show a detail view when a sensible area is tapped
- (void)tapDidOccurOnSensibleAreaWithId:(NSUInteger*)ids {
    NSLog(@"SENSIBLE AREA TAPPED ids:%u", (NSUInteger)ids); 
    // ..push new view controller...
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    // Check if it is also one image
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait)
        return YES;
    
    // If it is two images, do a landscape view - UIInterfaceOrientationIsLandscape
    
    return NO;
}


/*- (TTPhotoView*) createPhotoView 
{
    //Check the url
    if(!urlLocation)
    {
        return [super createPhotoView];        
    }
    else
    {
        // Check what the URL refers to 
        
        
        // If the URL 
    }
    return [super createPhotoView];
}*/

@end
