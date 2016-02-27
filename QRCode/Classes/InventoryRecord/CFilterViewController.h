//
//  CFilterViewController.h
//  QRCode
//
//  Created by CarlLiu on 16/2/25.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CBaseViewController.h"

@protocol CCFilterViewControllerDelegate <NSObject>
- (void)didSearchByLyr:(NSString *)lyr andZcbh:(NSString *)zcbh andCfdd:(NSString *)cfdd;

@end

@interface CFilterViewController : CBaseViewController
@property (nonatomic, strong) NSString *lyr;
@property (nonatomic, strong) NSString *zcbh;
@property (nonatomic, strong) NSString *cfdd;

@property (nonatomic, weak) id<CCFilterViewControllerDelegate> delegate;

@end
