//
//  CCustomCodeInventoryViewController.m
//  QRCode
//
//  Created by CarlLiu on 16/2/22.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CCustomCodeInventoryViewController.h"

@interface CCustomCodeInventoryViewController ()
@property (nonatomic, weak) IBOutlet UIButton *loadButton;

@end

@implementation CCustomCodeInventoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back-arrow"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.loadButton createBordersWithColor:[UIColor groupTableViewBackgroundColor] withCornerRadius:6 andWidth:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoad:(id)sender {
    
}

@end
