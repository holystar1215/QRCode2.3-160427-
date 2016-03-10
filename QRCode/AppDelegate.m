//
//  AppDelegate.m
//  QRCode
//
//  Created by CarlLiu on 16/1/29.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "AppDelegate.h"
#import "CLoginViewController.h"
#import "CHomeViewController.h"
#import "DSNavigationBar.h"
#import "CPopoverView.h"
#import "CNavigationController.h"

@interface AppDelegate ()
@property (strong, nonatomic) UINavigationController *navigationController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    [self setupSignInViewController];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Setup ViewController Method
- (void)setupSignInViewController {
    CLoginViewController *loginViewController = [[CLoginViewController alloc] initWithNibName:@"CLoginViewController" bundle:nil];
    self.window.rootViewController = loginViewController;
    [self.window makeKeyAndVisible];
}

- (void)setupHomeViewController {
    CHomeViewController *homeViewController = [[CHomeViewController alloc] initWithNibName:@"CHomeViewController" bundle:nil];
    homeViewController.title = @"资产盘点系统";
    self.navigationController = [[CNavigationController alloc] initWithNavigationBarClass:[DSNavigationBar class] toolbarClass:nil];
    self.navigationController.viewControllers = @[homeViewController];
    DSNavigationBar *bar = (DSNavigationBar *)self.navigationController.navigationBar;
    [bar setNavigationBarWithColor:RGBA(255, 255, 255, 0.8)];
    [bar setTintColor:[UIColor blueColor]];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
}

@end
