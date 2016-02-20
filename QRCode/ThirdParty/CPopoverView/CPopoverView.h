//
//  CPopoverView.h
//  
//
//  Created by CarlLiu on 15/6/7.
//  Copyright (c) 2015年 Carl Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^dismiss_block)();

@interface CPopoverView : UIView
@property (nonatomic, copy) dismiss_block block;

/**
 *  背景点击自动收起
 */
@property (nonatomic, assign, setter=setAutoHidden:) BOOL autoHidden;

- (void)setupContentView:(UIView *)contentView andHeaderView:(UIView *)headerView;
/**
 *  展示
 */
- (void)showPopoverView;

/**
 *  收起
 */
- (void)dismissPopoverView;


@end
