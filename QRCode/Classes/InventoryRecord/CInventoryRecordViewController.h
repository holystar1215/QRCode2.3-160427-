//
//  CInventoryRecordViewController.h
//  QRCode
//
//  Created by CarlLiu on 16/2/24.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CBaseViewController.h"

@interface CInventoryRecordViewController : CBaseViewController
@property (nonatomic, assign) NSInteger recordType;
@property (nonatomic, strong) NSString *assetCompany;
@property (nonatomic, assign) NSInteger currentPage;

@end
