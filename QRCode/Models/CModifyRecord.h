//
//  CModifyRecord.h
//  QRCode
//
//  Created by CarlLiu on 16/2/25.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface CModifyRecord : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *zcbh;
@property (nonatomic, strong) NSString *sydwh;
// 要修改的领用人
@property (nonatomic, strong) NSString *lyr;
// 要修改的存放地点
@property (nonatomic, strong) NSString *cfdd;
// 要修改的使用单位号
@property (nonatomic, strong) NSString *x_sydwh;
@property (nonatomic, strong) NSString *x_lyr;
@property (nonatomic, strong) NSString *x_cfdd;
@property (nonatomic, strong) NSString *xgrgh;
@property (nonatomic, strong) NSString *fjmc;
@property (nonatomic, strong) NSString *x_lyrgh;

@end
