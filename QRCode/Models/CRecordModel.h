//
//  CRecordModel.h
//  QRCode
//
//  Created by CarlLiu on 16/2/25.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface CRecordModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *zcbh;
@property (nonatomic, strong) NSString *changjia;
@property (nonatomic, strong) NSString *jine;
@property (nonatomic, strong) NSString *cfdd;
@property (nonatomic, strong) NSString *lyr;
@property (nonatomic, strong) NSString *mc;
@property (nonatomic, strong) NSString *syfxm;
@property (nonatomic, strong) NSString *sydwh;
@property (nonatomic, strong) NSString *jfkmm;
@property (nonatomic, strong) NSString *jxs;
@property (nonatomic, strong) NSString *sydwm;
@property (nonatomic, strong) NSString *zcnr;
@property (nonatomic, strong) NSString *rksj;
@property (nonatomic, strong) NSString *gg;
@property (nonatomic, strong) NSString *xh;

@end
