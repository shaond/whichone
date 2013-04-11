//
//  LeftLikeAreaView.h
//  likedislike
//
//  Created by Herbert Yeung on 26/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@protocol OpinionAreaViewDelegate;

enum 
{
    LIKE_BUTTON = 1,
    DISLIKE_BUTTON =2
}; 

@interface OpinionAreaView : UIView {
    
    id <OpinionAreaViewDelegate> delegate;
    NSUInteger *liked;
    NSUInteger *likeButtonType;
    UIButton *disclosureButton;
    
    NSString *pollURL;
}

@property (nonatomic, assign) id <OpinionAreaViewDelegate> delegate;
@property (nonatomic, assign) NSUInteger *liked;
@property (nonatomic, assign) NSUInteger *likeButtonType;
@property (nonatomic, retain) UIButton *disclosureButton;

- (id)initWithFrame:(CGRect)frame withButton: (NSUInteger) buttonType;

@end


@protocol OpinionAreaViewDelegate <NSObject>
@required
- (void)tapDidOccur:(OpinionAreaView *)aView;
@end