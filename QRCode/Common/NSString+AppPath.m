//
//  NSString+AppPath.m
//  
//
//  Created by Carl Liu on 13-11-8.
//  Copyright (c) 2013年 Carl Liu. All rights reserved.
//

#import "NSString+AppPath.h"

#import <BFKit.h>

// - App Path
#define APP_OPENIN_PATH ((APP_DOCUMENT_PATH != nil) ? [APP_DOCUMENT_PATH stringByAppendingPathComponent:@"InBox"] : nil)

@implementation NSString (AppPath)

#pragma mark - Check path
- (BOOL)isExistPath
{
    return [[NSFileManager defaultManager] fileExistsAtPath:self];
}

- (BOOL)isExistDirectoryPath
{
    BOOL isDir = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:self isDirectory:&isDir]) {
        return isDir;
    }
    return isDir;
}

- (BOOL)createDirectoryIfNeed {
    if ([self isExistPath]) {
        return YES;
    } else {
        NSError *error = nil;
        if ([[NSFileManager defaultManager] createDirectoryAtPath:self withIntermediateDirectories:YES attributes:nil error:&error]) {
            return YES;
        } else {
            ERROR(@"%@", error.localizedDescription);
            return NO;
        }
    }
}

#pragma mark - Chanage path
// Root Path == /Documents
- (NSString *)absolutePath
{
    return [NSFileManager getDocumentsDirectoryForFile:self];
}

- (NSString *)relativePath
{
    NSRange docRange = [self rangeOfString:@"/Documents"];
    if (docRange.location != NSNotFound) {
        NSString *relPath = [self substringFromIndex:docRange.location + docRange.length];
        if ([relPath isEqualToString:@""]) {
            return @"/";
        }
        return relPath;
    }
    
    return nil;
}

@end
