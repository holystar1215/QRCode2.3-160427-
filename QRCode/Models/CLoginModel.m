//
//  CLoginModel.m
//  QRCode
//
//  Created by CarlLiu on 16/2/22.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CLoginModel.h"

@implementation CLoginModel

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
             @"bdmc" : @"bdmc",
             @"bykl" : @"bykl",
             @"cwkxg" : @"cwkxg",
             @"cwkys" : @"cwkys",
             @"cxdw" : @"cxdw",
             @"cxxk" : @"cxxk",
             @"dlmc" : @"dlmc",
             @"dyysd" : @"dyysd",
             @"dzyj" : @"dzyj",
             @"glnr" : @"glnr",
             @"glzz" : @"glzz",
             @"htjdk" : @"htjdk",
             @"jaqx" : @"jaqx",
             @"jgmc" : @"jgmc",
             @"jhkl" : @"jhkl",
             @"jhlb" : @"jhlb",
             @"jm" : @"jm",
             @"jsjmc" : @"jsjmc",
             @"lxdh" : @"lxdh",
             @"m_sbh" : @"m_sbh",
             @"pb" : @"pb",
             @"qtbm" : @"qtbm",
             @"roomFormat" : @"roomFormat",
             @"sbzz" : @"sbzz",
             @"shkl" : @"shkl",
             @"sjssh" : @"sjssh",
             @"spbdw" : @"spbdw",
             @"spbxm" : @"spbxm",
             @"spgl" : @"spgl",
             @"sqksp" : @"sqksp",
             @"sqxsp" : @"sqxsp",
             @"ssbm" : @"ssbm",
             @"systime" : @"systime",
             @"szdw" : @"szdw",
             @"xgkrj" : @"xgkrj",
             @"xskl" : @"xskl",
             @"xskxg" : @"xskxg",
             @"yhbd" : @"yhbd",
             @"yhgw" : @"yhgw",
             @"yhkl" : @"yhkl",
             @"yhmc" : @"yhmc",
             @"yhxx" : @"yhxx",
             @"yskl" : @"yskl",
             @"ysnr" : @"ysnr"
    };
}

- (NSString *)pddw {
    NSString *dw = self.cxdw;
    dw = [dw stringByReplacingOccurrencesOfString:@"][" withString:@","];
    dw = [dw stringByReplacingOccurrencesOfString:@"]" withString:@""];
    dw = [dw stringByReplacingOccurrencesOfString:@"[" withString:@""];
    NSArray *dwArray = [dw componentsSeparatedByString:@","];
    if (dwArray && [dwArray count] > 0) {
        return dwArray[0];
    }
    return nil;
}
@end
