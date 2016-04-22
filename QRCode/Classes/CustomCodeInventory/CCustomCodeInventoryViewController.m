//
//  CCustomCodeInventoryViewController.m
//  QRCode
//
//  Created by CarlLiu on 16/2/22.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CCustomCodeInventoryViewController.h"
#import <UIControl+BlocksKit.h>

@interface CCustomCodeInventoryViewController ()
@property (nonatomic, weak) IBOutlet UIButton *readCodeButton;
@property (nonatomic, weak) IBOutlet UITextField *codeTextField;
@property (nonatomic, weak) IBOutlet UIScrollView *resultScrollView;

@property (nonatomic, weak) IBOutlet UILabel *resultLabel;

@end

@implementation CCustomCodeInventoryViewController

- (void)resetPage {
    self.readCodeButton.titleLabel.text = @"读取数据";
    self.resultLabel.text = @"";
    
    [self.readCodeButton bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [self.readCodeButton bk_addEventHandler:^(id sender) {
        [[CWebService sharedInstance] manual_code:self.codeTextField.text pddw:[[CDataSource sharedInstance].loginModel pddw] success:^(NSString *obj, NSInteger code, NSString *msg) {
            switch (code) {
                case 1002: {
                    self.resultLabel.text = @"服务器异常";
                    break;
                }
                case 1006: {
                    if ([[CDataSource sharedInstance].schoolModel.gbpy isEqualToString:@"1"]) {
                        UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:@"不能盘点"];
                        [alertView bk_addButtonWithTitle:@"确定" handler:^{
                            self.codeTextField.text = @"";
                            [self.codeTextField becomeFirstResponder];
                            [self resetPage];
                        }];
                        [alertView show];
                        break;
                    }
                    self.resultLabel.text = @"资产编号不存在";
                    self.readCodeButton.titleLabel.text = @"点击盘点";
                    [self.readCodeButton bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
                    [self.readCodeButton bk_addEventHandler:^(id sender) {
                        UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:@"无此资产的实物账信息,请确认是否为您单位的盘盈资产?"];
                        [alertView bk_addButtonWithTitle:@"取消" handler:^{
                            self.codeTextField.text = @"";
                            [self.codeTextField becomeFirstResponder];
                            
                            [self resetPage];
                        }];
                        [alertView bk_addButtonWithTitle:@"确定" handler:^{
                            [[CWebService sharedInstance] manual_profit_code:self.codeTextField.text dlmc:[[CDataSource sharedInstance].loginModel dlmc] pddw:[[CDataSource sharedInstance].loginModel pddw] mc:@"人工" success:^(NSString *msg, NSInteger code) {
                                [MBProgressHUD showSuccess:msg];
                                
                                [self resetPage];
                            } failure:^(CWebServiceError *error) {
                                [MBProgressHUD showError:error.errorMessage];
                            } animated:YES message:nil];
                        }];
                        [alertView show];
                    } forControlEvents:UIControlEventTouchUpInside];
                    break;
                }
                case 2000: case 2002: {
                    if ([obj indexOfCharacter:'#'] != -1) {
                        UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:@"当前资产不在本次盘点范围内，不能盘点。"];
                        [alertView bk_addButtonWithTitle:@"确定" handler:^{
                            self.codeTextField.text = @"";
                            [self.codeTextField becomeFirstResponder];
                            [self resetPage];
                        }];
                        [alertView show];
                        break;
                    }
                    obj = [obj stringByReplacingOccurrencesOfString:@"#" withString:@""];
                    NSInteger chartIndex = [obj indexOfCharacter:'@'] == -1 ? 0 : [obj indexOfCharacter:'@'] + 1;
                    self.resultLabel.text = [obj substringFromIndex:chartIndex];
                    self.readCodeButton.titleLabel.text = @"点击盘点";
                    [self.readCodeButton bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
                    [self.readCodeButton bk_addEventHandler:^(id sender) {
                        if ([[obj substringToCharacter:'@'] isEqualToString:[[CDataSource sharedInstance].loginModel pddw]]) {
                            UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:@"是否盘盈?"];
                            [alertView bk_addButtonWithTitle:@"取消" handler:^{
                                self.codeTextField.text = @"";
                                [self.codeTextField becomeFirstResponder];
                                
                                [self resetPage];
                            }];
                            [alertView bk_addButtonWithTitle:@"确定" handler:^{
                                [[CWebService sharedInstance] manual_profit_code:self.codeTextField.text dlmc:[[CDataSource sharedInstance].loginModel dlmc] pddw:[[CDataSource sharedInstance].loginModel pddw] mc:@"人工" success:^(NSString *msg, NSInteger code) {
                                    [self resetPage];
                                } failure:^(CWebServiceError *error) {
                                    [MBProgressHUD showError:error.errorMessage];
                                } animated:YES message:@""];
                            }];
                            [alertView show];
                        } else {
                            NSString *tip;
                            if ([[obj substringToCharacter:'@'] isEqualToString:@""]) {
                                tip = @"无此资产的实物账信息，点击盘盈";
                            } else {
                                tip = @"该资产的隶属单位,与您的隶属单位不一样,请确认是否标记为您单位的盘盈资产?";
                            }
                            UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:tip];
                            [alertView bk_addButtonWithTitle:@"取消" handler:^{
                                self.codeTextField.text = @"";
                                [self.codeTextField becomeFirstResponder];
                                
                                [self resetPage];
                            }];
                            [alertView bk_addButtonWithTitle:@"确定" handler:^{
                                NSString *tip = nil;
                                if ([[obj substringToCharacter:'@'] isEqualToString:@""]) {
                                    tip = @"无此资产的实物账信息，请确认是否为您单位的盘盈资产？";
                                } else {
                                    tip = @"该资产的隶属单位，与您的隶属单位不一样，请确认是否标记为您单位的盘盈资产？";
                                }
                                if (code == 2002) {
                                    tip = msg;
                                }
                                UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:tip];
                                [alertView bk_addButtonWithTitle:@"取消" handler:^{
                                    self.codeTextField.text = @"";
                                    [self.codeTextField becomeFirstResponder];
                                    
                                    [self resetPage];
                                }];
                                [alertView bk_addButtonWithTitle:@"确定" handler:^{
                                    [[CWebService sharedInstance] manual_confirm_code:self.codeTextField.text dlmc:[[CDataSource sharedInstance].loginModel dlmc] pddw:[[CDataSource sharedInstance].loginModel pddw] mc:@"人工" success:^(NSString *msg, NSInteger code) {
                                        [MBProgressHUD showSuccess:msg];
                                        
                                        [self resetPage];
                                    } failure:^(CWebServiceError *error) {
                                        [MBProgressHUD showError:error.errorMessage];
                                    } animated:YES message:@""];
                                }];
                                [alertView show];
                            }];
                            [alertView show];
                        }
                    } forControlEvents:UIControlEventTouchUpInside];
                    break;
                }
                case 2003: {//对不起,您的优先级小于1,不能二次盘点.
                    self.resultLabel.text = @"资产编号不存在";
                    [MBProgressHUD showError:@"对不起,您的优先级小于1,不能二次盘点"];
                    break;
                }
                default:
                    break;
            }
        } failure:^(CWebServiceError *error) {
            [MBProgressHUD showError:error.errorMessage];
        } animated:YES message:@""];
    } forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back-arrow"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.readCodeButton createBordersWithColor:[UIColor groupTableViewBackgroundColor] withCornerRadius:6 andWidth:1];
    
    [self resetPage];
    
    [self.codeTextField bk_addEventHandler:^(id sender) {
        [self resetPage];
    } forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
