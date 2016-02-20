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
#import "CShoolModel.h"

#import <UIView+BlocksKit.h>

static NSString * const reuseIdentifier = @"CLoginViewCell";

@interface CLoginViewController () <UITableViewDelegate, UITableViewDataSource, CListPopoverViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *savePasswordButton;
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@property (strong, nonatomic) CListPopoverView *popupListView;
@property (strong, nonatomic) NSArray *schoolArray;
@property (strong, nonatomic) NSArray *resultArray;

@end

@implementation CLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.contentTableView registerNib:[UINib nibWithNibName:@"CLoginViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    [self.contentTableView createBordersWithColor:[UIColor whiteColor] withCornerRadius:6 andWidth:1];
    
    [[CWebService sharedInstance] school_list_success:^(NSArray *models) {
        NSError *jsonError;
        self.schoolArray = [MTLJSONAdapter modelsOfClass:[CShoolModel class] fromJSONArray:models error:&jsonError];
        self.resultArray = [NSArray arrayWithArray:self.schoolArray];
        self.popupListView = [[CListPopoverView alloc] initWithFrame:CGRectZero andTarget:self];
    } failure:^(CWebServiceError *error) {
        
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

- (IBAction)onSavePassword:(id)sender {
    UIButton *aButton = sender;
    [self.savePasswordButton setSelected:!aButton.selected];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    if (indexPath.row == 0) {
        [self.popupListView showPopoverView];
    }
}

#pragma mark - <CListPopoverViewDelegate>
- (NSInteger)numberOfItems {
    return [self.resultArray count];
}

- (NSString *)itemAtIndexPath:(NSIndexPath *)indexPath {
    CShoolModel *school = self.resultArray[indexPath.row];
    return school.schoolName;
}

- (void)didSelectedItemIndex:(NSInteger)index {
    CLoginViewCell *cell = [self.contentTableView cellForRowAtIndexPath:INDEX_PATH(0, 0)];
    CShoolModel *school = self.resultArray[index];
    cell.textField.text = school.schoolName;
}

- (void)didChangeSearchText:(NSString *)searchText {
    NSString *match = [NSString stringWithFormat:@"*%@*", searchText];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"schoolName like[cd] %@", match];
    self.resultArray = [self.schoolArray filteredArrayUsingPredicate:predicate];
    
    [self.popupListView reloadData];
}

@end
