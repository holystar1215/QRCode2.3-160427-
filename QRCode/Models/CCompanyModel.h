//
//  CCompanyModel.h
//  QRCode
//
//  Created by CarlLiu on 16/2/27.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface CCompanyModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *bm; //部门
@property (nonatomic, strong) NSString *bzdwm; //
@property (nonatomic, strong) NSString *dw;//单位
@property (nonatomic, strong) NSString *dwdm;//单位代码
@property (nonatomic, strong) NSString *dwjc;//单位简称
@property (nonatomic, strong) NSString *dwmc;//单位名称
@property (nonatomic, strong) NSString *dwqc;//单位全称
@property (nonatomic, strong) NSString *dwxz;//单位性质
@property (nonatomic, strong) NSString *dwxzm;//单位性质名
@property (nonatomic, strong) NSString *hbdwm;//合并单位码
@property (nonatomic, strong) NSString *jfkm;//经费科目
@property (nonatomic, strong) NSString *jfkmm;//经费科目名
@property (nonatomic, strong) NSString *jlnf;//建立年份
@property (nonatomic, strong) NSString *ks;//科室
@property (nonatomic, strong) NSString *mxj; // 明细级

@end
