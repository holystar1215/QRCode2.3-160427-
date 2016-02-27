//
//  CCompanyModel.m
//  QRCode
//
//  Created by CarlLiu on 16/2/27.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CCompanyModel.h"

@implementation CCompanyModel
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
             @"bm"	:	@"bm",
             @"bzdwm"	:	@"bzdwm",
             @"dw"	:	@"dw",
             @"dwdm"	:	@"dwdm",
             @"dwjc"	:	@"dwjc",
             @"dwmc"	:	@"dwmc",
             @"dwqc"	:	@"dwqc",
             @"dwxz"	:	@"dwxz",
             @"dwxzm"	:	@"dwxzm",
             @"hbdwm"	:	@"hbdwm",
             @"jfkm"	:	@"jfkm",
             @"jfkmm"	:	@"jfkmm",
             @"jlnf"	:	@"jlnf",
             @"ks"	:	@"ks",
             @"mxj"	:	@"mxj"
             };
}

@end
