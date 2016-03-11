//
//  CHomeViewController.m
//  QRCode
//
//  Created by CarlLiu on 16/1/30.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CHomeViewController.h"
#import "CHeaderView.h"
#import "CHomeViewCollectionViewCell.h"
#import "CInventoryRecordViewController.h"
#import "CCustomCodeInventoryViewController.h"
#import "CCodeScanViewController.h"

#import <QRCodeReader.h>

static NSString * const reuseIdentifier = @"CHomeViewCollectionViewCell";

@interface CHomeViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet CHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UICollectionView *contentTableView;

@property (nonatomic, strong) NSArray *itemsArray;

@end

@implementation CHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.logoutButton createBordersWithColor:[UIColor groupTableViewBackgroundColor] withCornerRadius:6 andWidth:1];
    
    [self.contentTableView registerNib:[UINib nibWithNibName:@"CHomeViewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.itemsArray = @[
                        @[
                            @{@"kItemName" : @"条码盘点", @"kIconName" : @"bar_code"},
                            @{@"kItemName" : @"二维码盘点", @"kIconName" : @"qr_code"},
                            @{@"kItemName" : @"自定义编码号盘点", @"kIconName" : @"custom"},
                            @{@"kItemName" : @"已经盘点的记录", @"kIconName" : @"checked"},
                            @{@"kItemName" : @"查询盘盈记录", @"kIconName" : @"search"},
                            @{@"kItemName" : @"尚未盘点的记录", @"kIconName" : @"unchecked"}
                          ]
                        ];
    
    self.headerView.headerImageView.image = [UIImage imageNamed:@"login_account"];
    self.headerView.titleLabel.text = [NSString stringWithFormat:@"姓名:%@", [CDataSource sharedInstance].loginModel.yhmc];
    self.headerView.subTitleLabel.text = [NSString stringWithFormat:@"隶属单位:%@", [CDataSource sharedInstance].loginModel.lxdh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Activity Method
- (IBAction)onLogout:(id)sender {
    [APP_DELEGATE setupSignInViewController];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CHomeViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [cell createBordersWithColor:[UIColor lightGrayColor] withCornerRadius:0 andWidth:0.5];
    NSDictionary *dict = self.itemsArray[indexPath.section][indexPath.row];
    cell.titleLabel.text = dict[@"kItemName"];
    cell.iconImageView.image = [UIImage imageNamed:dict[@"kIconName"]];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor whiteColor];
    NSDictionary *dict = self.itemsArray[indexPath.section][indexPath.row];
    switch (indexPath.row) {
        case 0: {
            if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code]]) {
                static CCodeScanViewController *vc = nil;
                static dispatch_once_t onceToken;
                
                dispatch_once(&onceToken, ^{
                    QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, nil]];
                    reader.metadataOutput.rectOfInterest = CGRectMake (( 80 )/ SCREEN_HEIGHT ,(( SCREEN_WIDTH - 295 )/ 2 )/ SCREEN_WIDTH , 295 / SCREEN_HEIGHT , 295 / SCREEN_WIDTH );
                    vc                   = [CCodeScanViewController readerWithCancelButtonTitle:@"取消" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:NO showTorchButton:NO];
                });
                
                vc.title = dict[@"kItemName"];
                
                DSNavigationBar *bar = (DSNavigationBar *)self.navigationController.navigationBar;
                [bar setNavigationBarWithColor:RGBA(0, 0, 0, 0.5)];
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"当前设备不支持扫码功能！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                
                [alert show];
            }
            
            break;
        }
        case 1: {
            if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
                static CCodeScanViewController *vc = nil;
                static dispatch_once_t onceToken;
                
                dispatch_once(&onceToken, ^{
                    QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil]];
                    reader.metadataOutput.rectOfInterest = CGRectMake (( 80 )/ SCREEN_HEIGHT ,(( SCREEN_WIDTH - 295 )/ 2 )/ SCREEN_WIDTH , 295 / SCREEN_HEIGHT , 295 / SCREEN_WIDTH );
                    vc                   = [CCodeScanViewController readerWithCancelButtonTitle:@"取消" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:NO showTorchButton:NO];
                    vc.modalPresentationStyle = UIModalPresentationFormSheet;
                });
                
                vc.title = dict[@"kItemName"];
                
                DSNavigationBar *bar = (DSNavigationBar *)self.navigationController.navigationBar;
                [bar setNavigationBarWithColor:RGBA(0, 0, 0, 0.5)];
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"当前设备不支持扫码功能！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                
                [alert show];
            }
            
            break;
        }
        case 2: {
			if ([[[CDataSource sharedInstance].schoolModel customizeNo] isEqualToString:@"0"]) {
				UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:@"抱歉,贵校未开通自定义资产编号盘点功能,请通过条形码或二维码扫描功能读取资产编号"];
				[alertView bk_addButtonWithTitle:@"知道了" handler:^{
					
				}];
				[alertView show];
			} else {
				CCustomCodeInventoryViewController *vc = [[CCustomCodeInventoryViewController alloc] initWithNibName:@"CCustomCodeInventoryViewController" bundle:nil];
				vc.title = dict[@"kItemName"];
				[self.navigationController pushViewController:vc animated:YES];
			}
            break;
        }
        case 3: {
            CInventoryRecordViewController *vc = [[CInventoryRecordViewController alloc] initWithNibName:@"CInventoryRecordViewController" bundle:nil];
            vc.title = dict[@"kItemName"];
            vc.recordType = 1;
            vc.assetCompany = [CDataSource sharedInstance].loginModel.cxdw;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 4: {
            CInventoryRecordViewController *vc = [[CInventoryRecordViewController alloc] initWithNibName:@"CInventoryRecordViewController" bundle:nil];
            vc.title = dict[@"kItemName"];
            vc.recordType = 2;
            vc.assetCompany = [CDataSource sharedInstance].loginModel.cxdw;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 5: {
            CInventoryRecordViewController *vc = [[CInventoryRecordViewController alloc] initWithNibName:@"CInventoryRecordViewController" bundle:nil];
            vc.title = dict[@"kItemName"];
            vc.recordType = 3;
            vc.assetCompany = [CDataSource sharedInstance].loginModel.cxdw;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(318 / 3, 70);
}

- (CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

@end
