//
//  CUnCheckRecordModel.m
//  QRCode
//
//  Created by CarlLiu on 16/2/26.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CUnCheckRecordModel.h"

@implementation CUnCheckRecordModel

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

    };
}

@end
