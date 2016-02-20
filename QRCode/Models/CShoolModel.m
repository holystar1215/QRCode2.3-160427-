//
//  
//  AutomaticCoder
//
//  Created by 张玺自动代码生成器  http://zhangxi.me
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//
#import "CShoolModel.h"

@implementation CShoolModel

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
             @"unifiedCode" : @"unifiedCode"
             };
}

@end
