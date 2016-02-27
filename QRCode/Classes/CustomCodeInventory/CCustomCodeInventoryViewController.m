//
//  CCustomCodeInventoryViewController.m
//  QRCode
//
//  Created by CarlLiu on 16/2/22.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CCustomCodeInventoryViewController.h"

@interface CCustomCodeInventoryViewController ()
@property (nonatomic, weak) IBOutlet UIButton *readCodeButton;
@property (nonatomic, weak) IBOutlet UITextField *codeTextField;

@end

@implementation CCustomCodeInventoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back-arrow"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.readCodeButton createBordersWithColor:[UIColor groupTableViewBackgroundColor] withCornerRadius:6 andWidth:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onReadCode:(id)sender {
    [[CWebService sharedInstance] manual_code:self.codeTextField.text pddw:[[CDataSource sharedInstance].loginDict pddw] success:^(NSArray *models) {
        
    } failure:^(CWebServiceError *error) {
        [MBProgressHUD showError:error.errorMessage];
    } animated:YES message:@""];
}

@end
