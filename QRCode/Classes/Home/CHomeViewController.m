//
//  CHomeViewController.m
//  QRCode
//
//  Created by CarlLiu on 16/1/30.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CHomeViewController.h"
#import "CHeaderView.h"
#import "CStatusBarView.h"
#import "CHomeTableViewCell.h"

static NSString * const reuseIdentifier = @"CHomeTableViewCell";

@interface CHomeViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet CHeaderView *headerView;
@property (weak, nonatomic) IBOutlet CStatusBarView *statusBarView;
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@property (nonatomic, strong) NSArray *itemsArray;

@end

@implementation CHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.contentTableView registerNib:[UINib nibWithNibName:@"CHomeTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    self.itemsArray = @[
                        @[
                            @{@"kItemName" : @"条码盘点", @"kIconName" : @""},
                            @{@"kItemName" : @"二维码盘点", @"kIconName" : @""},
                            @{@"kItemName" : @"自定义编码号盘点", @"kIconName" : @""},
                            @{@"kItemName" : @"已经盘点的记录", @"kIconName" : @""},
                            @{@"kItemName" : @"查询盘盈记录", @"kIconName" : @""},
                            @{@"kItemName" : @"尚未盘点的记录", @"kIconName" : @""}
                          ]
                        ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Activity Method
- (IBAction)onExitButton:(id)sender {
    
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    // Configure the cell...
    NSDictionary *dict = self.itemsArray[indexPath.section][indexPath.row];
    cell.titleLabel.text = dict[@"kItemName"];
//    if ([dict[@"kHasSubItem"] boolValue]) {
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    } else {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
    
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
