//
//  CRecordModel.m
//  QRCode
//
//  Created by CarlLiu on 16/2/25.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CRecordModel.h"

@implementation CRecordModel

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
        @"cfdd": @"cfdd",
        @"changjia": @"changjia",
        @"gg": @"gg",
        @"ID": @"id",
        @"jfkmm": @"jfkmm",
        @"jine": @"jine",
        @"jxs": @"jxs",
        @"lyr": @"lyr",
        @"mc": @"mc",
        @"rksj": @"rksj",
        @"sydwh": @"sydwh",
        @"sydwm": @"sydwm",
        @"syfxm": @"syfxm",
        @"xh": @"xh",
        @"zcbh": @"zcbh",
        @"zcnr": @"zcnr"
    };
}

//- (NSDictionary *)recordDict {
//    return @{
//             @"zcbh" : self.zcbh,
//             @"sydwh" : self.sydwh,
//             @"lyr" : self.lyr,
//             @"cfdd" : self.cfdd,
//             @"grgh" : self.grgh,
//             //修改人工号
//             @"fjmc" : self.fjmc,
//             //房间名称
//             @"lyrgh" : self.lyrgh
//             };
//}

@end
