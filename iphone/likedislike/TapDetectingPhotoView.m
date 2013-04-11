//
//  TapDetectingPhotoView.m
//  likedislike
//
//  Created by Herbert Yeung on 26/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TapDetectingPhotoView.h"
#import "Photo.h"
#import "SBJson.h"
#import <QuartzCore/QuartzCore.h>

@interface TapDetectingPhotoView (Private)
- (void)createSensibleAreas;
@end


@implementation TapDetectingPhotoView

@synthesize sensibleAreas, pollID, tappableAreaDelegate, centerPoll;


// designated initializer
- (id)initWithSensibleAreas:(NSArray *)areasList {
    if (self = [super initWithFrame:CGRectZero]) {
        self.sensibleAreas = areasList;
        [self createSensibleAreas];
    }
    
    return self;
}

- (id)init {
    return [self initWithSensibleAreas:nil];
}

- (id)initWithPhoto:(NSString*)poll_ID  {
    [self setPollID:poll_ID];
    return [self initWithSensibleAreas:nil];
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithSensibleAreas:nil];
}
- (void)setSensibleAreas:(NSArray *)newSensibleAreas {
    if (newSensibleAreas != self.sensibleAreas) {
        // destroy previous sensible area and ensure that only sensible area's subviews are removed
        for (UIView *subview in self.subviews)
            if ([subview isMemberOfClass:[OpinionAreaView class]])
                [subview removeFromSuperview];
        
        [newSensibleAreas retain];
        [sensibleAreas release];
        sensibleAreas = newSensibleAreas;
        [self createSensibleAreas];
    }
}

- (void)createSensibleAreas {
    OpinionAreaView *leftArea;
    OpinionAreaView *rightArea;
    
    if (![self isDualPicPoll:[self pollID]])
    {
        //leftArea = [[LeftLikeAreaView alloc] initWithFrame: CGRectMake(0, 280, 1024, 38)];
        leftArea = [[OpinionAreaView alloc] initWithFrame: CGRectMake(0, 280, 35, 38) withButton:LIKE_BUTTON];
        leftArea.delegate = self;
        [self addSubview:leftArea];
        [leftArea release];
        
        rightArea = [[OpinionAreaView alloc] initWithFrame: CGRectMake(80, 280, 35, 38) withButton:DISLIKE_BUTTON];
        rightArea.delegate = self;
        [self addSubview:rightArea];
        [rightArea release];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    
    // Check what time of subview this is
    //NSLog(@"Value of POLL ID is %@", [self pollID]); 
    if (![self isDualPicPoll:[self pollID]] || ![self centerPoll])
    {
        [super layoutSubviews];
    }
    else
    { 
        // Use iCarousel to get the values of many images
        /*CoverFlowController *coverFlowController = [[CoverFlowController alloc] init];
         [self addSubview:coverFlowController.view];
         [coverFlowController release];*/
        
        // Remove any unwanted images & like/dislike buttons as we need to redraw these
        [self unsetImage];
        
        CALayer *photoLayer = [self layer];        
        //[layer setFrame:CGRectMake(0, 65, self.bounds.size.width, self.bounds.size.height*1.2)];
        [photoLayer setFrame:CGRectMake(0, 65, self.bounds.size.width, self.bounds.size.height*1.55)];
        [photoLayer setBackgroundColor:[UIColor grayColor].CGColor];
        //[photoLayer setBorderColor:[UIColor brownColor].CGColor];
        //[photoLayer setBorderWidth:2];
        
        
        CALayer *firstPhotoFrame = [CALayer layer];
        
        CGFloat offset = 10.0f;
        CGFloat photoFrameWidth = self.bounds.size.width - offset;
        CGFloat photoFrameHeight = self.bounds.size.height - offset*20;
        [firstPhotoFrame setBackgroundColor:[UIColor whiteColor].CGColor];
        [firstPhotoFrame setShadowOffset:CGSizeMake(0, 3)];
        [firstPhotoFrame setShadowRadius:3.0];
        [firstPhotoFrame setShadowOpacity:0.4];
        [firstPhotoFrame setShadowColor:[UIColor blackColor].CGColor];
        [firstPhotoFrame setFrame:CGRectMake(offset, offset, photoFrameWidth - offset, photoFrameHeight/2 - offset)];
        
        //Fetch img from server
        NSMutableArray *imgArray = [self imagesFromPoll:[self pollID]];
        NSString* url_photo = [@"https://whichone.funkhq.com/uploads/" stringByAppendingString:
                               (NSString *)[imgArray objectAtIndex:0]];
        
        
        
        NSURL *url = [NSURL URLWithString:url_photo];
        //Using GCD
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        url = [NSURL URLWithString:url_photo];
        dispatch_async(queue, ^{
            
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [[UIImage alloc] initWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [firstPhotoFrame setContents:(id)img.CGImage];
                [img release];   
                //[firstPhotoFrame setNeedsDisplay];
                [firstPhotoFrame setNeedsLayout];
            });
        });
        [photoLayer addSublayer:firstPhotoFrame];        
        //End GCD
        
        /*
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];

        [firstPhotoFrame setContents:(id)img.CGImage];
        [img release];
        [photoLayer addSublayer:firstPhotoFrame];*/
        
        
        //[CATransaction flush];
        //[photoLayer setNeedsDisplay];
        //[firstPhotoFrame autorelease];
        //[layer sublayers];
        
        CALayer *secondPhotoFrame = [CALayer layer];
        [secondPhotoFrame setBackgroundColor:[UIColor whiteColor].CGColor];
        [secondPhotoFrame setShadowOffset:CGSizeMake(0, 3)];
        [secondPhotoFrame setShadowRadius:3.0];
        [secondPhotoFrame setShadowOpacity:0.4];
        [secondPhotoFrame setShadowColor:[UIColor blackColor].CGColor];
        [secondPhotoFrame setFrame:CGRectMake(offset, offset*2.0f + firstPhotoFrame.frame.size.height, photoFrameWidth - offset, photoFrameHeight/2 - offset*2.0f)];
        url_photo = [@"https://whichone.funkhq.com/uploads/" stringByAppendingString:
                     (NSString *)[imgArray objectAtIndex:1]];
        
        
        //Using GCD
        //dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        url = [NSURL URLWithString:url_photo];
        dispatch_async(queue, ^{
            
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [[UIImage alloc] initWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [secondPhotoFrame setContents:(id)img.CGImage];
                [img release];   
                //[secondPhotoFrame setNeedsDisplay];
                [secondPhotoFrame setNeedsLayout];
            });
        });
        [photoLayer addSublayer:secondPhotoFrame];        
        //End GCD
        
        /*url = [NSURL URLWithString:url_photo];
        data = [NSData dataWithContentsOfURL:url];
        img = [[UIImage alloc] initWithData:data];
        
        [secondPhotoFrame setContents:(id)img.CGImage];
        [img release];
        [photoLayer addSublayer:secondPhotoFrame];*/
        
        
        
        /*[self setContentMode:UIViewContentModeCenter];
         [layer setShadowColor:[UIColor blackColor].CGColor];
         [layer setShadowOffset:CGSizeMake(-3.0, 3.0)];
         [layer setShadowRadius:3.0];
         [layer setShadowOpacity:0.4];*/
        
        /*CGRect screenBounds = TTScreenBounds();
         //CGFloat width = self.bounds.size.width;
         //CGFloat height = self.bounds.size.height;
         CGFloat width = self.bounds.size.height;
         CGFloat height = self.bounds.size.width;
         CGFloat cx = self.bounds.origin.x + width/2;
         CGFloat cy = self.bounds.origin.y + height/2;
         CGFloat marginRight = 0.0f, marginLeft = 0.0f, marginBottom = TTToolbarHeight();
         
         // Since the photo view is constrained to the size of the image, but we want to position
         // the status views relative to the screen, offset by the difference
         CGFloat screenOffset = -floor(screenBounds.size.height/2 - height/2);
         
         // Vertically center in the space between the bottom of the image and the bottom of the screen
         CGFloat imageBottom = screenBounds.size.height/2 + self.defaultImage.size.height/2;
         CGFloat textWidth = screenBounds.size.width - (marginLeft+marginRight);
         
         if (_statusLabel.text.length) {
         CGSize statusSize = [_statusLabel sizeThatFits:CGSizeMake(textWidth, 0)];
         _statusLabel.frame =
         CGRectMake(marginLeft + (cx - screenBounds.size.width/2),
         cy + floor(screenBounds.size.height/2 - (statusSize.height+marginBottom)),
         textWidth, statusSize.height);
         
         } else {
         _statusLabel.frame = CGRectZero;
         }
         
         if (_captionLabel.text.length) {
         CGSize captionSize = [_captionLabel sizeThatFits:CGSizeMake(textWidth, 0)];
         _captionLabel.frame = CGRectMake(marginLeft + (cx - screenBounds.size.width/2),
         cy + floor(screenBounds.size.height/2
         - (captionSize.height+marginBottom)),
         textWidth, captionSize.height);
         
         } else {
         _captionLabel.frame = CGRectZero;
         }
         
         CGFloat spinnerTop = _captionLabel.bounds.size.height
         ? _captionLabel.bounds.origin.x - floor(_statusSpinner.bounds.size.height + _statusSpinner.bounds.size.height/2)
         : screenOffset + imageBottom + floor(_statusSpinner.bounds.size.height/2);
         
         _statusSpinner.frame =
         CGRectMake(self.bounds.origin.x + floor(self.bounds.size.width/2 - _statusSpinner.bounds.size.width/2),
         spinnerTop, _statusSpinner.bounds.size.width, _statusSpinner.bounds.size.height);*/
        
    }
}

- (NSMutableArray*) imagesFromPoll:(NSString *)poll_ID
{
    NSUInteger numberOfImgs = 2;
    NSMutableArray *imgArray = [[NSMutableArray alloc] initWithCapacity:numberOfImgs];
    NSString *poll_url = [@"https://whichone.funkhq.com/get/poll/" stringByAppendingString:poll_ID];    
    NSURL *url = [NSURL URLWithString:poll_url];
    
    // Create a request object using the URL.
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Prepare for the response back from the server    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    // Send a synchronous request to the server (i.e. sit and wait for the response)
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Check if an error occurred    
    if (error != nil) {
        NSLog(@"%@", [error localizedDescription]);
        return false;
    }
    
    // Convert the response data to a string.
    NSString *responseString = [[NSString alloc] initWithData:responseData  encoding:NSUTF8StringEncoding];
    
    // View the data returned - should be ready for parsing.
    NSLog(@"imagesFromPoll value is: %@", responseString);
    
    //Process JSON data from the string
    NSDictionary *json = [responseString JSONValue]; 
    
    for (NSDictionary *value_key in json)
    {
        NSDictionary *fields = [value_key objectForKey:@"fields"];
        
        [imgArray insertObject:[fields objectForKey:@"img1"] atIndex:0];
        [imgArray insertObject:[fields objectForKey:@"img2"] atIndex:1];
        
    }
    
    return [imgArray autorelease];
}

- (BOOL) isDualPicPoll: (NSString*) poll_ID
{
    NSString *poll_url = [@"https://whichone.funkhq.com/get/poll/" stringByAppendingString:poll_ID];    
    NSURL *url = [NSURL URLWithString:poll_url];
    
    // Create a request object using the URL.
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Prepare for the response back from the server    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    // Send a synchronous request to the server (i.e. sit and wait for the response)
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Check if an error occurred    
    if (error != nil) {
        NSLog(@"%@", [error localizedDescription]);
        return false;
    }
    
    // Convert the response data to a string.
    NSString *responseString = [[NSString alloc] initWithData:responseData  encoding:NSUTF8StringEncoding];
    
    // View the data returned - should be ready for parsing.
    NSLog(@"isDualPicPoll value is: %@", responseString);
    
    //Process JSON data from the string
    NSDictionary *json = [responseString JSONValue]; 
    
    for (NSDictionary *value_key in json)
    {
        NSDictionary *fields = [value_key objectForKey:@"fields"];
        
        if ([[fields objectForKey:@"img2"] length])
            return TRUE;
    }
    
    return FALSE;
}

// to make sure that if the zoom factor of the TTScrollView is > than 1.0 the subviews continue to respond to the tap events
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event { 
    UIView *result = nil;
    for (UIView *child in self.subviews) {
        CGPoint convertedPoint = [self convertPoint:point toView:child];
        if ([child pointInside:convertedPoint withEvent:event]) {
            result = child;
        }
    }
    
    return result;
}

#pragma mark - TapDetectingPhotoViewDelegate methods

- (void)tapDidOccur:(OpinionAreaView *)aView {
    NSLog(@"tapDidOccur ids:%u tag:%d", (NSUInteger)aView.liked, aView.tag);
    [tappableAreaDelegate tapDidOccurOnSensibleAreaWithId:aView.liked];
}

@end
