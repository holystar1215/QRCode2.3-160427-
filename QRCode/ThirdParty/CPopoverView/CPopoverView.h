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
 *  初始化
 *
 *  @param customView 通过自定义view初始化
 *
 *  @return 初始化后的对象
 */
- (instancetype)initWithCustomView:(UIView *)customView width:(CGFloat)width height:(CGFloat)height;

/**
 *  背景点击自动收起
 */
@property (nonatomic, assign, setter=setAutoHidden:) BOOL autoHidden;
/**
 *  展示
 */
- (void)show;

/**
 *  收起
 */
-(void)dismiss;


@end
