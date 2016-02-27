//
//  CLoginViewController.m
//  QRCode
//
//  Created by CarlLiu on 16/1/30.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CLoginViewController.h"
#import "CLoginViewCell.h"
#import "CListPopoverView.h"
#import "CSchoolModel.h"
#import "CLoginModel.h"

static NSString * const reuseIdentifier = @"CLoginViewCell";

@interface CLoginViewController () <UITableViewDelegate, UITableViewDataSource, CListPopoverViewDelegate, CLoginViewCellDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@property (strong, nonatomic) CListPopoverView *popupListView;
@property (strong, nonatomic) NSArray *schoolArray;
@property (strong, nonatomic) NSArray *resultArray;
@property (assign, nonatomic) NSInteger currentSchool;

@end

@implementation CLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.logoImageView createBordersWithColor:[UIColor groupTableViewBackgroundColor] withCornerRadius:self.logoImageView.bounds.size.height / 2 andWidth:1];
     
    [self.contentTableView registerNib:[UINib nibWithNibName:@"CLoginViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    [self.contentTableView createBordersWithColor:[UIColor groupTableViewBackgroundColor] withCornerRadius:0 andWidth:1];
    
    self.logoImageView.image = [UIImage imageNamed:@"login_account"];
    
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

- (IBAction)onForgetPassword:(id)sender {
    
}

- (IBAction)onLogin:(id)sender {
    CLoginViewCell *cell;
    
    cell = [self.contentTableView cellForRowAtIndexPath:INDEX_PATH(0, 0)];
    NSString *schoolName = cell.textField.text;
    
    cell = [self.contentTableView cellForRowAtIndexPath:INDEX_PATH(0, 1)];
    NSString *userName = cell.textField.text;
    
    cell = [self.contentTableView cellForRowAtIndexPath:INDEX_PATH(0, 2)];
    NSString *passWord = cell.textField.text;
    
    if ([userName isEqualToString:@""] || [passWord isEqualToString:@""] || [schoolName isEqualToString:@""]) {
        [MBProgressHUD showError:@"信息输入不完整！"];
        return;
    }
    
    [USER_DEFAULT setObject:userName forKey:kUserNameDefault];
    [USER_DEFAULT setObject:passWord forKey:kPasswordDefault];
    
    [[CWebService sharedInstance] login_username:userName password:passWord success:^(NSDictionary *models) {
        NSError *jsonError;
        [[CDataSource sharedInstance] setLoginDict:[MTLJSONAdapter modelOfClass:[CLoginModel class] fromJSONDictionary:models error:&jsonError]];
        [APP_DELEGATE setupHomeViewController];
    } failure:^(CWebServiceError *error) {
        [MBProgressHUD showError:error.localizedDescription];
    } animated:YES message:@""];
}

- (void)showPopList {
    [[CWebService sharedInstance] school_list_success:^(NSArray *models) {
        NSError *jsonError;
        self.schoolArray = [MTLJSONAdapter modelsOfClass:[CSchoolModel class] fromJSONArray:models error:&jsonError];
        self.resultArray = [NSArray arrayWithArray:self.schoolArray];
        self.popupListView = [[CListPopoverView alloc] initWithFrame:CGRectZero andTarget:self];
        self.popupListView.autoHidden = YES;
        [self.popupListView showPopoverView];
    } failure:^(CWebServiceError *error) {
        [MBProgressHUD showError:error.localizedDescription];
    } animated:YES message:@""];
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
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0: {
            cell.imageView.image = [UIImage imageNamed:@"school"];
            cell.textField.placeholder = @"学校";
            cell.textField.enabled = NO;
            break;
        }
        case 1: {
            cell.imageView.image = [UIImage imageNamed:@"password"];
            cell.textField.placeholder = @"用户";
            NSString *userName = [USER_DEFAULT objectForKey:kUserNameDefault];
            if (userName) {
                cell.textField.text = userName;
            }
            break;
        }
        case 2: {
            cell.imageView.image = [UIImage imageNamed:@"username"];
            cell.textField.placeholder = @"密码";
            cell.textField.secureTextEntry = YES;
            NSString *passWord = [USER_DEFAULT objectForKey:kPasswordDefault];
            if (passWord) {
                cell.textField.text = passWord;
            }
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
    CLoginViewCell *cell;
    switch (indexPath.row) {
        case 0: {
            cell = [tableView cellForRowAtIndexPath:INDEX_PATH(0, 0)];
            cell.imageView.image = [UIImage imageNamed:@"school_selected"];
            cell = [tableView cellForRowAtIndexPath:INDEX_PATH(0, 1)];
            cell.imageView.image = [UIImage imageNamed:@"password"];
            cell = [tableView cellForRowAtIndexPath:INDEX_PATH(0, 2)];
            cell.imageView.image = [UIImage imageNamed:@"username"];
            [self showPopList];
            break;
        }
        case 1: {
            cell = [tableView cellForRowAtIndexPath:INDEX_PATH(0, 0)];
            cell.imageView.image = [UIImage imageNamed:@"school"];
            cell = [tableView cellForRowAtIndexPath:INDEX_PATH(0, 1)];
            cell.imageView.image = [UIImage imageNamed:@"password_selected"];
            cell = [tableView cellForRowAtIndexPath:INDEX_PATH(0, 2)];
            cell.imageView.image = [UIImage imageNamed:@"username"];
            break;
        }
        case 2: {
            cell = [tableView cellForRowAtIndexPath:INDEX_PATH(0, 0)];
            cell.imageView.image = [UIImage imageNamed:@"school"];
            cell = [tableView cellForRowAtIndexPath:INDEX_PATH(0, 1)];
            cell.imageView.image = [UIImage imageNamed:@"password"];
            cell = [tableView cellForRowAtIndexPath:INDEX_PATH(0, 2)];
            cell.imageView.image = [UIImage imageNamed:@"username_selected"];
            break;
        }
        default:
            break;
    }
}

#pragma mark - <CListPopoverViewDelegate>
- (NSInteger)numberOfItems {
    return [self.resultArray count];
}

- (NSString *)itemAtIndexPath:(NSIndexPath *)indexPath {
    CSchoolModel *school = self.resultArray[indexPath.row];
    return school.schoolName;
}

- (void)didSelectedItemIndex:(NSInteger)index {
    self.currentSchool = index;
    CLoginViewCell *cell = [self.contentTableView cellForRowAtIndexPath:INDEX_PATH(0, 0)];
    CSchoolModel *school = self.resultArray[self.currentSchool];
    cell.textField.text = school.schoolName;
    
    if ([school.isDelete isEqualToString:@"0"]) {
        UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:@"抱歉，贵校目前无此授权，不能使用！"];
        [alertView bk_addButtonWithTitle:@"知道了" handler:^{
            
        }];
        [alertView show];
    } else if ([school.serverAddr isEqualToString:@""]) {
        UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:@"抱歉，贵校的服务器地址未配置！"];
        [alertView bk_addButtonWithTitle:@"知道了" handler:^{
            
        }];
        [alertView show];
    } else {
        UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:@"抱歉,贵校未开通自定义资产编号盘点功能,请通过条形码或二维码扫描功能读取资产编号"];
        [alertView bk_addButtonWithTitle:@"知道了" handler:^{
            
        }];
        [alertView show];
        
    }
}

- (void)didChangeSearchText:(NSString *)searchText {
    NSString *match = [NSString stringWithFormat:@"*%@*", searchText];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"schoolName like[cd] %@", match];
    self.resultArray = [self.schoolArray filteredArrayUsingPredicate:predicate];
    
    [self.popupListView reloadData];
}

#pragma mark - <CLoginViewCellDelegate>
- (void)didSelectCell:(CLoginViewCell *)cell {
    NSIndexPath *indexPath = [self.contentTableView indexPathForCell:cell];
    
    switch (indexPath.row) {
        case 0: {
            cell = [self.contentTableView cellForRowAtIndexPath:INDEX_PATH(0, 0)];
            cell.imageView.image = [UIImage imageNamed:@"school_selected"];
            cell = [self.contentTableView cellForRowAtIndexPath:INDEX_PATH(0, 1)];
            cell.imageView.image = [UIImage imageNamed:@"password"];
            cell = [self.contentTableView cellForRowAtIndexPath:INDEX_PATH(0, 2)];
            cell.imageView.image = [UIImage imageNamed:@"username"];
            
            break;
        }
        case 1: {
            cell = [self.contentTableView cellForRowAtIndexPath:INDEX_PATH(0, 0)];
            cell.imageView.image = [UIImage imageNamed:@"school"];
            cell = [self.contentTableView cellForRowAtIndexPath:INDEX_PATH(0, 1)];
            cell.imageView.image = [UIImage imageNamed:@"password_selected"];
            cell = [self.contentTableView cellForRowAtIndexPath:INDEX_PATH(0, 2)];
            cell.imageView.image = [UIImage imageNamed:@"username"];
            break;
        }
        case 2: {
            cell = [self.contentTableView cellForRowAtIndexPath:INDEX_PATH(0, 0)];
            cell.imageView.image = [UIImage imageNamed:@"school"];
            cell = [self.contentTableView cellForRowAtIndexPath:INDEX_PATH(0, 1)];
            cell.imageView.image = [UIImage imageNamed:@"password"];
            cell = [self.contentTableView cellForRowAtIndexPath:INDEX_PATH(0, 2)];
            cell.imageView.image = [UIImage imageNamed:@"username_selected"];
            break;
        }
        default:
            break;
    }
}

@end
