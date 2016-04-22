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

#import <BlocksKit/UITextField+BlocksKit.h>
#import <BlocksKit/UIControl+BlocksKit.h>

static NSString * const reuseIdentifier = @"CLoginViewCell";

@interface CLoginViewController () <UITableViewDelegate, UITableViewDataSource, CListPopoverViewDelegate, CLoginViewCellDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@property (weak, nonatomic) IBOutlet UIImageView *loadImageView;
@property (weak, nonatomic) IBOutlet UIButton *demoButton;

@property (strong, nonatomic) CListPopoverView *popupListView;
@property (strong, nonatomic) NSArray *schoolArray;
@property (strong, nonatomic) NSArray *resultArray;
@property (assign, nonatomic) NSInteger currentSchool;

@property (strong, nonatomic) CSchoolModel *demoSchoolModel;

@end

@implementation CLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.logoImageView createBordersWithColor:[UIColor groupTableViewBackgroundColor] withCornerRadius:self.logoImageView.bounds.size.height / 2 andWidth:1];
     
    [self.contentTableView registerNib:[UINib nibWithNibName:@"CLoginViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    [self.contentTableView createBordersWithColor:[UIColor groupTableViewBackgroundColor] withCornerRadius:0 andWidth:1];
    
    self.logoImageView.image = [UIImage imageNamed:@"login_account"];
    
    [[CWebService sharedInstance] school_list_success:^(NSArray *models) {
        NSError *jsonError;
        self.schoolArray = [MTLJSONAdapter modelsOfClass:[CSchoolModel class] fromJSONArray:models error:&jsonError];
        self.resultArray = [NSArray arrayWithArray:self.schoolArray];
        self.demoButton.hidden = YES;
        [self.resultArray enumerateObjectsUsingBlock:^(CSchoolModel *obj, NSUInteger idx, BOOL * stop) {
            if ([obj.schoolName isEqualToString:@"雁南师范学院"]) {
                self.demoButton.hidden = NO;

                self.demoSchoolModel = obj;
                *stop = YES;
            }
        }];
        [self.resultArray enumerateObjectsUsingBlock:^(CSchoolModel *obj, NSUInteger idx, BOOL * stop) {
            NSString *name = [USER_DEFAULT objectForKey:kCompanyDefault];
            if ([obj.schoolName isEqualToString:name]) {
                self.currentSchool = idx;
                *stop = YES;
            }
        }];
        self.loadImageView.hidden = YES;
    } failure:^(CWebServiceError *error) {
        self.demoButton.hidden = YES;
        self.loadImageView.hidden = YES;
        [MBProgressHUD showError:error.errorMessage];
    } animated:YES message:@""];
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

- (IBAction)onDemo:(id)sender {
    [[Configuration sharedInstance] saveServerAddr:@"202.119.81.162:8080"];
    [USER_DEFAULT setObject:[[Configuration sharedInstance] demoAccount] forKey:kUserNameDefault];
    [USER_DEFAULT synchronize];
    [[CDataSource sharedInstance] setIsDemoAccount:YES];
    [[CWebService sharedInstance] login_username:[[Configuration sharedInstance] demoAccount] password:[[Configuration sharedInstance] demoPassword] success:^(NSDictionary *models) {
        NSError *jsonError;
        [[CDataSource sharedInstance] setLoginModel:[MTLJSONAdapter modelOfClass:[CLoginModel class] fromJSONDictionary:models error:&jsonError]];
        [[CDataSource sharedInstance] setSchoolModel:self.demoSchoolModel];
        [USER_DEFAULT setObject:@"YES" forKey:kDemoLogin];
        [USER_DEFAULT synchronize];
        [APP_DELEGATE setupHomeViewController];
    } failure:^(CWebServiceError *error) {
        if (error.errorCode == eWebServiceErrorTimeout) {
            UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:@"请重新选择学校名称或修改账户信息"];
            [alertView bk_addButtonWithTitle:@"确定" handler:^{
                
            }];
            [MBProgressHUD hideHUD];
        } else {
            [MBProgressHUD showError:error.errorMessage];
        }
    } animated:YES message:@""];
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
    
    [[CWebService sharedInstance] login_username:userName password:passWord success:^(NSDictionary *models) {
        NSError *jsonError;
        [[CDataSource sharedInstance] setLoginModel:[MTLJSONAdapter modelOfClass:[CLoginModel class] fromJSONDictionary:models error:&jsonError]];
        CSchoolModel *school = self.resultArray[self.currentSchool];
    	[[CDataSource sharedInstance] setSchoolModel:school];
        [USER_DEFAULT setObject:userName forKey:kUserNameDefault];
        [USER_DEFAULT setObject:passWord forKey:kPasswordDefault];
        [USER_DEFAULT synchronize];
        [[CDataSource sharedInstance] setIsDemoAccount:NO];
        [APP_DELEGATE setupHomeViewController];
    } failure:^(CWebServiceError *error) {
        if (error.errorCode == eWebServiceErrorTimeout) {
            UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:@"请重新选择学校名称或修改账户信息"];
            [alertView bk_addButtonWithTitle:@"确定" handler:^{
                
            }];
            [MBProgressHUD hideHUD];
        } else {
            [MBProgressHUD showError:error.errorMessage];
        }
    } animated:YES message:@""];
}

- (void)showPopListWithBlock:(void (^)(void))block {
//    [[CWebService sharedInstance] school_list_success:^(NSArray *models) {
//        NSError *jsonError;
//        self.schoolArray = [MTLJSONAdapter modelsOfClass:[CSchoolModel class] fromJSONArray:models error:&jsonError];
//        self.resultArray = [NSArray arrayWithArray:self.schoolArray];
        self.popupListView = [[CListPopoverView alloc] initWithFrame:CGRectZero andTarget:self];
        self.popupListView.autoHidden = YES;
        [self.popupListView showPopoverViewWithBlock:^(void) {
            block();
        }];
//    } failure:^(CWebServiceError *error) {
//        [MBProgressHUD showError:error.errorMessage];
//    } animated:YES message:@""];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CLoginViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    // Configure the cell...
    cell1.delegate = self;
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0: {
            cell1.imageView.image = [UIImage imageNamed:@"school"];
            cell1.textField.placeholder = @"学校";
            cell1.textField.enabled = NO;
            
            NSString *schoolName = [USER_DEFAULT objectForKey:kCompanyDefault];
            if ([[USER_DEFAULT objectForKey:kDemoLogin] isEqualToString:@"YES"]) {
//                [USER_DEFAULT removeObjectForKey:kDemoLogin];
                
                schoolName = nil;
            }
            if (schoolName) {
                cell1.textField.text = schoolName;
            }
            break;
        }
        case 1: {
            cell1.imageView.image = [UIImage imageNamed:@"username"];
            cell1.textField.placeholder = @"用户";

            NSString *userName = [USER_DEFAULT objectForKey:kUserNameDefault];
            if ([[USER_DEFAULT objectForKey:kDemoLogin] isEqualToString:@"YES"]) {
//                [USER_DEFAULT removeObjectForKey:kDemoLogin];
                
                userName = nil;
            }
            
            if (userName) {
                if ([userName isEqualToString:[[Configuration sharedInstance] demoAccount]]) {
                    cell1.textField.text = @"";
                } else {
                    cell1.textField.text = userName;
                }
            }
            break;
        }
        case 2: {
            cell1.imageView.image = [UIImage imageNamed:@"password"];
            cell1.textField.placeholder = @"密码";
            cell1.textField.secureTextEntry = YES;

            NSString *passWord = [USER_DEFAULT objectForKey:kPasswordDefault];
            if ([[USER_DEFAULT objectForKey:kDemoLogin] isEqualToString:@"YES"]) {
                [USER_DEFAULT removeObjectForKey:kDemoLogin];
                [USER_DEFAULT removeObjectForKey:kCompanyDefault];
                [USER_DEFAULT removeObjectForKey:kUserNameDefault];
                [USER_DEFAULT removeObjectForKey:kPasswordDefault];
                passWord = nil;
            }
            if (passWord) {
                cell1.textField.text = passWord;
            }
            cell1.lineView.hidden = YES;
            break;
        }
        default:
            break;
    }
    
    return cell1;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    CLoginViewCell *cell;
    switch (indexPath.row) {
        case 0: {
//            cell = [tableView cellForRowAtIndexPath:INDEX_PATH(0, 0)];
//            cell.imageView.image = [UIImage imageNamed:@"school_selected"];
//            cell = [tableView cellForRowAtIndexPath:INDEX_PATH(0, 1)];
//            cell.imageView.image = [UIImage imageNamed:@"username"];
//            cell = [tableView cellForRowAtIndexPath:INDEX_PATH(0, 2)];
//            cell.imageView.image = [UIImage imageNamed:@"password"];
            [self showPopListWithBlock:^{
                
            }];
            break;
        }
        case 1: {
//            cell = [tableView cellForRowAtIndexPath:INDEX_PATH(0, 0)];
//            cell.imageView.image = [UIImage imageNamed:@"school"];
//            cell = [tableView cellForRowAtIndexPath:INDEX_PATH(0, 1)];
//            cell.imageView.image = [UIImage imageNamed:@"username_selected"];
//            cell = [tableView cellForRowAtIndexPath:INDEX_PATH(0, 2)];
//            cell.imageView.image = [UIImage imageNamed:@"password"];
            break;
        }
        case 2: {
//            cell = [tableView cellForRowAtIndexPath:INDEX_PATH(0, 0)];
//            cell.imageView.image = [UIImage imageNamed:@"school"];
//            cell = [tableView cellForRowAtIndexPath:INDEX_PATH(0, 1)];
//            cell.imageView.image = [UIImage imageNamed:@"username"];
//            cell = [tableView cellForRowAtIndexPath:INDEX_PATH(0, 2)];
//            cell.imageView.image = [UIImage imageNamed:@"password_selected"];
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
    [[CDataSource sharedInstance] setSchoolModel:school];
    cell.textField.text = school.schoolName;
    [[Configuration sharedInstance] saveCompanyName:school.schoolName];
    [[Configuration sharedInstance] saveServerAddr:school.serverAddr];
    
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
            cell.imageView.image = [UIImage imageNamed:@"username"];
            cell = [self.contentTableView cellForRowAtIndexPath:INDEX_PATH(0, 2)];
            cell.imageView.image = [UIImage imageNamed:@"password"];
            
            break;
        }
        case 1: {
            cell = [self.contentTableView cellForRowAtIndexPath:INDEX_PATH(0, 0)];
            cell.imageView.image = [UIImage imageNamed:@"school"];
            cell = [self.contentTableView cellForRowAtIndexPath:INDEX_PATH(0, 1)];
            cell.imageView.image = [UIImage imageNamed:@"username_selected"];
            cell = [self.contentTableView cellForRowAtIndexPath:INDEX_PATH(0, 2)];
            cell.imageView.image = [UIImage imageNamed:@"password"];
            break;
        }
        case 2: {
            cell = [self.contentTableView cellForRowAtIndexPath:INDEX_PATH(0, 0)];
            cell.imageView.image = [UIImage imageNamed:@"school"];
            cell = [self.contentTableView cellForRowAtIndexPath:INDEX_PATH(0, 1)];
            cell.imageView.image = [UIImage imageNamed:@"username"];
            cell = [self.contentTableView cellForRowAtIndexPath:INDEX_PATH(0, 2)];
            cell.imageView.image = [UIImage imageNamed:@"password_selected"];
            break;
        }
        default:
            break;
    }
}

@end
