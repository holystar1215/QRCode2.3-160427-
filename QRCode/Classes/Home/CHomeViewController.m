//
//  CHomeViewController.m
//  QRCode
//
//  Created by CarlLiu on 16/1/30.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CHomeViewController.h"
#import "CHeaderView.h"
#import "CStatusBarView.h"
#import "CHomeViewCollectionViewCell.h"

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Activity Method
- (IBAction)onLogout:(id)sender {
    
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
    NSDictionary *dict = self.itemsArray[indexPath.section][indexPath.row];
    cell.titleLabel.text = dict[@"kItemName"];
    cell.iconImageView.image = [UIImage imageNamed:dict[@"kIconName"]];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(106, 70);
}

@end
