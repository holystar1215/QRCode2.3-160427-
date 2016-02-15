//
//  AppDelegate.h
//  QRCode
//
//  Created by CarlLiu on 16/1/29.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)setupSignInViewController;
- (void)setupHomeViewController;

@end

