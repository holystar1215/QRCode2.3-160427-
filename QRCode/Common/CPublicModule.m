//
//  CPublicModule.m
//  
//
//  Created by LiuCarl on 15/1/8.
//  Copyright (c) 2015年 Carl Liu. All rights reserved.
//

#import "CPublicModule.h"
#import "GTMBase64.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>

#define kChosenDigestLength		CC_SHA1_DIGEST_LENGTH
#define DESKEY @"D6D2402F1C98E208FF2E863AA29334BD65AE1932A821502D9E5673CDE3C713ACFE53E2103CD40ED6BEBB101B484CAE83D537806C6CB611AEE86ED2CA8C97BBE95CF8476066D419E8E833376B850172107844D394016715B2E47E0A6EECB3E83A361FA75FA44693F90D38C6F62029FCD8EA395ED868F9D718293E9C0E63194E87"

@implementation CPublicModule

DEFINE_SINGLETON_FOR_CLASS(CPublicModule);

- (NSString *)getDeviceSSID {
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }

    NSDictionary *dctySSID = (NSDictionary *)info;
    NSString *ssid = [dctySSID objectForKey:@"SSID"]; //SSID Name
//    NSString *ssidData = [dctySSID objectForKey:@"SSIDDATA"];
//    NSString *bssid = [dctySSID objectForKey:@"BSSID"]; //Mac address
    
    return ssid;
}

#pragma mark -
#pragma mark UI Method
+ (CGSize)text:(NSString *)text font:(UIFont *)font size:(CGSize)size {
    NSDictionary *attribute = @{NSFontAttributeName:font};
    CGSize theSize = [text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    theSize.height = roundf(theSize.height) + 2;
    theSize.width = roundf(theSize.width) + 2;
    return theSize;
}

#pragma mark -
#pragma mark Data&Time
/**
 *  Get location time
 *
 *  @return location time
 */
+ (NSDate *)currentLocalTime {
    NSLog(@"knownTimeZoneNames:%@", [NSTimeZone knownTimeZoneNames]);
    
    NSDate *date = [NSDate date];
    
    NSLog(@"date:%@", date);
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate:date];
    
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    
    NSLog(@"localeDate:%@", localeDate);
    
    return localeDate;
}

+ (NSString *)convertLongToDate:(long long)time {
    NSDate *date =  [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)currentShortLocalTime {
    NSDate *date = [NSDate date];
    
//    NSLog(@"date:%@", date);
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate:date];
    
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    
//    NSLog(@"localeDate:%@", localeDate);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:localeDate];
    return dateStr;
}

+ (NSString *)shortDate:(NSDate *)aDate {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate:aDate];
    
    NSDate *localeDate = [aDate dateByAddingTimeInterval:interval];
    
    //    NSLog(@"localeDate:%@", localeDate);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:localeDate];
    return dateStr;
}

#pragma mark -
#pragma mark View Controller
/**
 *  Load XIB by Stroyboard Id
 *
 *  @param storyboardId storyboard Id
 *
 *  @return view controller
 */
+ (id)mainStoryboardId:(NSString *)storyboardId {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:storyboardId];
}

/**
 *  Load XIB by Stroyboard Id
 *
 *  @param storyboardIdName stroyboard name
 *  @param storyboardId     storyboard Id
 *
 *  @return storyboard Id对应的视图控制器
 */
+ (UIViewController *)storyboardIdName:(NSString *)storyboardIdName withStoryboardIdId:(NSString *)storyboardId {
    return [[UIStoryboard storyboardWithName:storyboardIdName bundle:nil] instantiateViewControllerWithIdentifier:storyboardId];
}

#pragma mark - Image
+ (NSString *)encodeStringBase64WithJPEGImage:(UIImage *)image {
    return [UIImageJPEGRepresentation(image, 1.0) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

+ (NSString *)encodeStringBase64WithPNGImage:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

+ (UIImage *)decodeStringBase64WithImage:(NSString *)str {
    return [UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters]];
}

#pragma mark - DES
- (NSString*)tripleDES:(NSString*)plainText keyString:(NSString *)keyString encryptOrDecrypt:(CCOperation)encryptOrDecrypt {
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)//解密
    {
        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else //加密
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    const void *vkey = (const void *)[DESKEY UTF8String];
    // NSString *initVec = @"init Vec";
    //const void *vinitVec = (const void *) [initVec UTF8String];
    //  Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                       vkey,
                       kCCKeySize3DES,
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    //if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
    /*else if (ccStatus == kCC ParamError) return @"PARAM ERROR";
     else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
     else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
     else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
     else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
     else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED"; */
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                               length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:myData];
    }
    
    return result;
}

@end
