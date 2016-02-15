//
//  CLoginViewController.m
//  QRCode
//
//  Created by CarlLiu on 16/1/30.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CLoginViewController.h"
#import "CLoginViewCell.h"

static NSString * const reuseIdentifier = @"CLoginViewCell";

@interface CLoginViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@end

@implementation CLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.contentTableView registerNib:[UINib nibWithNibName:@"CLoginViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    [self.contentTableView createBordersWithColor:[UIColor whiteColor] withCornerRadius:6 andWidth:1];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CLoginViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    // Configure the cell...
    switch (indexPath.row) {
        case 0: {
            cell.imageView.image = [UIImage imageNamed:@"shcool_image"];
            cell.textField.placeholder = @"学校";
            cell.textField.enabled = NO;
            break;
        }
        case 1: {
            cell.imageView.image = [UIImage imageNamed:@"password_image"];
            cell.textField.placeholder = @"用户";
            break;
        }
        case 2: {
            cell.imageView.image = [UIImage imageNamed:@"username_image"];
            cell.textField.placeholder = @"密码";
            cell.textField.secureTextEntry = YES;
            cell.lineView.hidden = YES;
            break;
        }
        default:
            break;
    }
    
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
