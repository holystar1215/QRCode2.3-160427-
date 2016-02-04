//
//  CBaseViewController.m
//
//
//  Created by CarlLiu on 16/1/4.
//  Copyright © 2016年 CarlLiu. All rights reserved.
//

#import "CBaseViewController.h"

@interface CBaseViewController ()

@end

@implementation CBaseViewController
#pragma mark - View Method
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public UI Method
//- (void)setupStatusBarView {
//    self.statusBarView = [[CStatusBarView alloc] initWithFrame:CGRectZero];
//    [self.view addSubview:self.statusBarView];
//    [self.statusBarView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
//    [self.statusBarView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
//    [self.statusBarView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
//    [self.statusBarView autoSetDimension:ALDimensionHeight toSize:50];
//}


@end
