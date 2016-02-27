//
//  COverageRecordModel.h
//  QRCode
//
//  Created by CarlLiu on 16/2/25.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface COverageRecordModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *lyr;
@property (nonatomic, strong) NSString *mc;
@property (nonatomic, strong) NSString *rksj;
@property (nonatomic, strong) NSString *sydwm;
@property (nonatomic, strong) NSString *zcbh;

@end
