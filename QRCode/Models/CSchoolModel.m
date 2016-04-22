//
//  
//  CSchoolModel.m
//
//  Created by Carl
//  Copyright (c) 2016年 Carl. All rights reserved.
//
#import "CSchoolModel.h"

@implementation CSchoolModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue
                             error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil)
        return nil;
    
    // Store a value that needs to be determined locally upon initialization.
    
    return self;
}

- (void)dealloc {
    
}

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"customizeNo" : @"customizeNo",
             @"identifier" : @"id",
             @"isDelete" : @"isdel",
             @"property" : @"property",
             @"schoolName" : @"schoolName",
             @"schoolCode" : @"schoolcode",
             @"serverAddr" : @"serverAddr",
             @"unifiedCode" : @"unifiedCode",
             @"gbpy" : @"gbpy"
    };
}

@end
