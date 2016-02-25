//
//  CFilterViewController.m
//  QRCode
//
//  Created by CarlLiu on 16/2/25.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CFilterViewController.h"

@interface CFilterViewController ()
@property (nonatomic, weak) IBOutlet UITextField *lyrTextField;
@property (nonatomic, weak) IBOutlet UITextField *zcbhTextField;
@property (nonatomic, weak) IBOutlet UITextField *cfddTextField;

@property (nonatomic, weak) IBOutlet UIButton *searchAllButton;

@end

@implementation CFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back-arrow"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"查询" style:UIBarButtonItemStylePlain handler:^(id sender) {
        
    }];
    
    [self.searchAllButton createBordersWithColor:[UIColor groupTableViewBackgroundColor] withCornerRadius:6 andWidth:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSearchAll:(id)sender {
    
}

@end
