//
//  LeftLikeAreaView.m
//  likedislike
//
//  Created by Herbert Yeung on 26/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "OpinionAreaView.h"

@implementation OpinionAreaView

@synthesize delegate, liked, likeButtonType, disclosureButton;

/*- (void)buttonTouched {
    [delegate tapDidOccur:self];
}*/

- (id)initWithFrame:(CGRect)frame  withButton:(NSUInteger)buttonType
{
    if (self = [super initWithFrame:frame]) {
        self.liked = (NSUInteger*)2;
        self.userInteractionEnabled = YES;
        
        UIColor *color = [[UIColor alloc] initWithWhite:0.2 alpha:0.0]; 
        self.backgroundColor = color;
        [color release];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        CGRect buttonFrame = button.frame;        
        
        if (buttonType == LIKE_BUTTON)
        {
            self.likeButtonType = (NSUInteger*)LIKE_BUTTON;
            [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"likeButton" ofType:@"png"]] forState:UIControlStateNormal];
            [button setTitle:@"  likes" forState:UIControlStateNormal];
            buttonFrame.size.width = 80.0f;
        }
        else if (buttonType == DISLIKE_BUTTON)
        {
            self.likeButtonType = (NSUInteger*)DISLIKE_BUTTON;
            
            [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dislikeButton" ofType:@"png"]] forState:UIControlStateNormal];
            [button setTitle:@"  dislikes" forState:UIControlStateNormal];
            buttonFrame.size.width = 120.0f;   
        }
        //[button addTarget:self action:@selector(buttonTouched) forControlEvents:UIControlEventAllTouchEvents];
        buttonFrame.origin.x = 3.0f;
        buttonFrame.origin.y = frame.size.height/2 - 15.0f;
        button.frame = buttonFrame;
        button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
        self.disclosureButton = button;
        self.disclosureButton.userInteractionEnabled = YES;
        self.disclosureButton.imageView.userInteractionEnabled = YES;
        [self addSubview:button];
        [self bringSubviewToFront:button];
        [button release];

        // notification used to make sure that the button is properly scaled together with the photoview. I do not want the button looks bigger if the photoview is zoomed, I want to preserve its default dimensions
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zoomFactorChanged:) name:@"zoomFactorChanged" object:nil];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    if ([[touches anyObject] tapCount] == 1)
    {
        if((self.liked == (NSUInteger*)2) && (self.likeButtonType == (NSUInteger*)LIKE_BUTTON))
        {
            // Show the image that is unliked
            [disclosureButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"likeButtonLiked" ofType:@"png"]] forState:UIControlStateNormal];
            self.liked = (NSUInteger*)1;
        }
        else if((self.liked == (NSUInteger*)1) && (self.likeButtonType == (NSUInteger*)LIKE_BUTTON))
        {
            // Show the image that is unliked
            [disclosureButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"likeButton" ofType:@"png"]] forState:UIControlStateNormal];
            self.liked = (NSUInteger*)2;
        }
        else if(self.liked == (NSUInteger*)2 && (self.likeButtonType == (NSUInteger*)DISLIKE_BUTTON))
        {
            // Show the image that is unliked
            [disclosureButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dislikeButtonDisliked" ofType:@"png"]] forState:UIControlStateNormal];
            self.liked = (NSUInteger*)1;
        }
        else if((self.liked == (NSUInteger*)1) && (self.likeButtonType == (NSUInteger*)DISLIKE_BUTTON))
        {
            // Show the image that is unliked
            [disclosureButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dislikeButton" ofType:@"png"]] forState:UIControlStateNormal];
            self.liked = (NSUInteger*)2;
        }

        
        
        [delegate tapDidOccur:self];
    }
        
}

- (void)zoomFactorChanged:(NSNotification *)message {
    NSDictionary *userInfo = [message userInfo];
    CGFloat factor = [[userInfo valueForKey:@"zoomFactor"] floatValue];
    BOOL withAnimation = [[userInfo valueForKey:@"useAnimation"] boolValue];
    
    if (withAnimation) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.18];
    }
    
    disclosureButton.transform = CGAffineTransformMake(1/factor, 0.0, 0.0, 1/factor, 0.0, 0.0);
    
    if (withAnimation)
        [UIView commitAnimations];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"zoomFactorChanged"   object:nil];
    [disclosureButton release];
    [super dealloc];
}


@end
