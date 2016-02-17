//
//  CPopoverView.m
//  
//
//  Created by CarlLiu on 15/6/7.
//  Copyright (c) 2015年 Carl Liu. All rights reserved.
//

#import "CPopoverView.h"

//高度，宽度
#define kWidthDefault 300.0f
#define kHeightDefault 180.0f

@interface CPopoverView ()
@property (nonatomic, weak) UIButton *btnMask;
@property (nonatomic, weak) UIView *customView;

@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) CGFloat viewWidth;

@end

@implementation CPopoverView

#pragma mark - Initialization
- (instancetype)initWithCustomView:(UIView *)customView width:(CGFloat)width height:(CGFloat)height {
    self = [super initWithFrame:CGRectZero];//CGRectMake(0, 0, kWidthDefault, kHeightDefault)
    if (self) {
        self.viewHeight = height;
        self.viewWidth = width;
        self.customView = customView;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}


- (void)commonInit {
    //bg
    UIImageView *imvBG = [[UIImageView alloc] initWithFrame:CGRectZero];
    UIImage *resizeedImage = [UIImage imageNamed:@"bg_window_670x315"];
    imvBG.image = resizeedImage;
    imvBG.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:imvBG];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:imvBG
                                                    attribute:NSLayoutAttributeLeft
                                                    relatedBy:NSLayoutRelationEqual
                                                       toItem:self
                                                    attribute:NSLayoutAttributeLeft
                                                   multiplier:1
                                                     constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imvBG
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imvBG
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imvBG
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:0]];
    
    if (self.customView) {
        self.customView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.customView];

        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.customView
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.customView
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1
                                                          constant:0]];
        [self.customView addConstraint:[NSLayoutConstraint constraintWithItem:self.customView
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1
                                                                     constant:self.viewHeight]];
        [self.customView addConstraint:[NSLayoutConstraint constraintWithItem:self.customView
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1
                                                                     constant:self.viewWidth]];
    }
    
}


#pragma mark - Method
- (void)show {
    UIButton *btnMask = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnMask setBackgroundColor:RGBA(0, 0, 0, 0.5)];
    [btnMask addTarget:self action:@selector(didClickedBackgroud) forControlEvents:UIControlEventTouchUpInside];
    btnMask.alpha = 0.0f;

    self.translatesAutoresizingMaskIntoConstraints = NO;
    [btnMask addSubview:self];
    
    [btnMask addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:btnMask
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];
    [btnMask addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:btnMask
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1
                                                         constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:self.viewHeight]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:self.viewWidth]];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    btnMask.translatesAutoresizingMaskIntoConstraints = NO;
    [window addSubview:btnMask];
    [window addConstraint:[NSLayoutConstraint constraintWithItem:btnMask
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:window
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    [window addConstraint:[NSLayoutConstraint constraintWithItem:btnMask
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:window
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:0]];
    [btnMask addConstraint:[NSLayoutConstraint constraintWithItem:btnMask
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:window.bounds.size.height]];
    [btnMask addConstraint:[NSLayoutConstraint constraintWithItem:btnMask
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:window.bounds.size.width]];

    
    self.btnMask = btnMask;
    
    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        self.alpha = 1.f;
        btnMask.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)didClickedBackgroud {
    if (self.autoHidden) {
        [self dismiss];
    }
}

- (void)dismiss {
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
        self.btnMask.alpha = 0.f;
    } completion:^(BOOL finished) {
        self.transform = CGAffineTransformIdentity;
        [self removeFromSuperview];
        [self.btnMask removeFromSuperview];
        if (self.block) {
            self.block();
        }
    }];
}

- (void)setAutoHidden:(BOOL)hidden {
    _autoHidden = hidden;
}

@end
