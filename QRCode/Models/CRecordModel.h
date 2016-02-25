//
//  CRecordModel.h
//  QRCode
//
//  Created by CarlLiu on 16/2/25.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface CRecordModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *zcbh;

@property (nonatomic, copy) NSString *changjia;

@property (nonatomic, copy) NSString *jine;

@property (nonatomic, copy) NSString *cfdd;

@property (nonatomic, copy) NSString *lyr;

@property (nonatomic, copy) NSString *mc;

@property (nonatomic, copy) NSString *syfxm;

@property (nonatomic, copy) NSString *sydwh;

@property (nonatomic, copy) NSString *jfkmm;

@property (nonatomic, copy) NSString *jxs;

@property (nonatomic, copy) NSString *sydwm;

@property (nonatomic, copy) NSString *zcnr;

@property (nonatomic, copy) NSString *rksj;

@property (nonatomic, copy) NSString *gg;

@property (nonatomic, copy) NSString *xh;

@end
