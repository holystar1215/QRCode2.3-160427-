//
//  COverageRecordModel.m
//  QRCode
//
//  Created by CarlLiu on 16/2/25.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "COverageRecordModel.h"

@implementation COverageRecordModel

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
             @"ID" : @"id",
             @"lyr" : @"lyr",
             @"mc" : @"mc",
             @"rksj" : @"rksj",
             @"sydwm" : @"sydwm",
             @"zcbh" : @"zcbh"
    };
}

@end
