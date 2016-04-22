//
//  CPopoverView.m
//  
//
//  Created by CarlLiu on 15/6/7.
//  Copyright (c) 2015年 Carl Liu. All rights reserved.
//

#import "CPopoverView.h"
#import <UIView+BlocksKit.h>
#import "UIView+AutoLayout.h"

//高度，宽度
#define kPopoverViewDefaultWidth  288
#define kPopoverViewDefaultHeight 300

@interface CPopoverView ()
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *backgroudView;
@property (nonatomic, strong) UIButton *handleButton;

@end

@implementation CPopoverView

#pragma mark - Initialization
- (instancetype)initPopoverView {
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        [self setupBackgroud];
    }
    return self;
}

- (void)dealloc {
    [self.headerView removeFromSuperview];
    self.headerView = nil;
    [self.contentView removeFromSuperview];
    self.contentView = nil;
    [self.containerView removeFromSuperview];
    self.containerView = nil;
    [self.backgroudView removeFromSuperview];
    self.backgroudView = nil;
}

- (void)awakeFromNib {
    
}

- (void)setupContentView:(UIView *)contentView andHeaderView:(UIView *)headerView {
    if (self.contentView) {
        [self.contentView removeFromSuperview];
        self.contentView = nil;
    }
    self.contentView = contentView;
    
    if (self.headerView) {
        [self.headerView removeFromSuperview];
        self.headerView = nil;
    }
    self.headerView = headerView;
    
    [self setupBackgroud];
}

- (void)setupBackgroud {
    if (!self.backgroudView) {
        self.backgroudView = [[UIView alloc] initWithFrame:CGRectZero];
        self.backgroudView.backgroundColor = RGBA(0, 0, 0, 0.5);
        [self addSubview:self.backgroudView];
        
        [self.backgroudView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [self.backgroudView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        [self.backgroudView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [self.backgroudView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        
        self.handleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backgroudView addSubview:self.handleButton];
        [self.handleButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [self.handleButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        [self.handleButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [self.handleButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [self.handleButton addTarget:self action:@selector(onBackgroudButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self setupContainerView];
    }
}

- (void)onBackgroudButton:(id)sender {
    if (self.autoHidden) {
        [self dismissPopoverView];
    }
}

- (void)setupContainerView {
    if (self.containerView) {
        [self.containerView removeFromSuperview];
        self.containerView = nil;
    }
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.backgroudView addSubview:self.containerView];
    [self.containerView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.containerView autoConstrainAttribute:ALEdgeTop toAttribute:ALAxisHorizontal ofView:self withMultiplier:0.3];
    [self.containerView autoSetDimensionsToSize:CGSizeMake(kPopoverViewDefaultWidth, kPopoverViewDefaultHeight)];
    
    [self.containerView addSubview:self.headerView];
    [self.headerView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.headerView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.headerView autoSetDimensionsToSize:CGSizeMake(kPopoverViewDefaultWidth, 44)];
    
    [self.containerView addSubview:self.contentView];
    [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:44];
    [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
}

#pragma mark - Method
- (void)showPopoverViewWithBlock:(void (^)(void))block {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    [self autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [self autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    
    
    self.containerView.alpha = 0.f;
    self.containerView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.containerView.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        self.containerView.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.containerView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            block();
        }];
    }];
}

- (void)dismissPopoverView {
    [UIView animateWithDuration:0.3f animations:^{
        self.containerView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.containerView.alpha = 0.f;
    } completion:^(BOOL finished) {
        self.containerView.transform = CGAffineTransformIdentity;
        [self removeFromSuperview];
        if (self.block) {
            self.block();
        }
    }];
}

- (void)setAutoHidden:(BOOL)hidden {
    _autoHidden = hidden;
}

@end
