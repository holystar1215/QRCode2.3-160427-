//
//  CModifyRecordModel.m
//  QRCode
//
//  Created by CarlLiu on 16/2/25.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CModifyRecordModel.h"

@implementation CModifyRecordModel
- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    
    // Store a value that needs to be determined locally upon initialization.
    //_retrievedAt = [NSDate date];
    
    return self;
}

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"zcbh" : @"zcbh",
             @"sydwh" : @"sydwh",
             // 要修改的领用人
             @"lyr" : @"lyr",
             // 要修改的存放地点
             @"cfdd" : @"cfdd",
             // 要修改的使用单位号
             @"x_sydwh" : @"x_sydwh",
             @"x_lyr" : @"x_lyr",
             @"x_cfdd" : @"x_cfdd",
             @"xgrgh" : @"xgrgh",
             @"fjmc" : @"fjmc",
             @"x_lyrgh" : @"x_lyrgh"
    };
}

@end
