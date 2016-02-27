//
//  CRecordViewController.h
//  QRCode
//
//  Created by CarlLiu on 16/2/25.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CBaseViewController.h"

@interface CRecordViewController : CBaseViewController
@property (nonatomic, assign) NSInteger recordType;
@property (nonatomic, strong) NSString *assetCompany;
@property (nonatomic, strong) id modelSelected;

@end
