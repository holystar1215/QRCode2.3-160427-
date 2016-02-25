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

@interface CHomeViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, QRCodeReaderDelegate>
@property (weak, nonatomic) IBOutlet CHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UICollectionView *contentTableView;

@property (nonatomic, strong) NSArray *itemsArray;

@end

@implementation CHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    self.headerView.titleLabel.text = [NSString stringWithFormat:@"姓名:%@", [CDataSource sharedInstance].loginDict.yhmc];
    self.headerView.subTitleLabel.text = [NSString stringWithFormat:@"隶属单位:%@", [CDataSource sharedInstance].loginDict.lxdh];
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
        case 0:
        case 1: {
            if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
                static CCodeScanViewController *vc = nil;
                static dispatch_once_t onceToken;
                
                dispatch_once(&onceToken, ^{
                    QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil]];
                    vc                   = [CCodeScanViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:NO showTorchButton:NO];
                    vc.modalPresentationStyle = UIModalPresentationFormSheet;
                });
                vc.delegate = self;
                
                [vc setCompletionWithBlock:^(NSString *resultAsString) {
                    NSLog(@"Completion with result: %@", resultAsString);
                }];
                
                vc.title = dict[@"kItemName"];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Reader not supported by the current device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
            }
            
            break;
        }
        case 2: {
            CCustomCodeInventoryViewController *vc = [[CCustomCodeInventoryViewController alloc] initWithNibName:@"CCustomCodeInventoryViewController" bundle:nil];
            vc.title = dict[@"kItemName"];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3: {
            CInventoryRecordViewController *vc = [[CInventoryRecordViewController alloc] initWithNibName:@"CInventoryRecordViewController" bundle:nil];
            vc.title = dict[@"kItemName"];
            vc.recordType = 1;
            vc.assetCompany = [CDataSource sharedInstance].loginDict.cxdw;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 4: {
            CInventoryRecordViewController *vc = [[CInventoryRecordViewController alloc] initWithNibName:@"CInventoryRecordViewController" bundle:nil];
            vc.title = dict[@"kItemName"];
            vc.recordType = 2;
            vc.assetCompany = [CDataSource sharedInstance].loginDict.cxdw;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 5: {
            CInventoryRecordViewController *vc = [[CInventoryRecordViewController alloc] initWithNibName:@"CInventoryRecordViewController" bundle:nil];
            vc.title = dict[@"kItemName"];
            vc.recordType = 3;
            vc.assetCompany = [CDataSource sharedInstance].loginDict.cxdw;
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

#pragma mark - <QRCodeReaderDelegate>
- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result {
    [self dismissViewControllerAnimated:YES completion:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QRCodeReader" message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader {
    [reader.navigationController popViewControllerAnimated:YES];
}

@end
