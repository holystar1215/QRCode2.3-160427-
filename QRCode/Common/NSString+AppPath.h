//
//  NSString+AppPath.h
//  
//
//  Created by Carl Liu on 13-11-8.
//  Copyright (c) 2013年 Carl Liu. All rights reserved.
//

#import "CPublicModule.h"

@interface NSString (AppPath)

- (BOOL)isExistPath;
- (BOOL)isExistDirectoryPath;

- (NSString *)absolutePath;

- (NSString *)relativePath;

- (BOOL)createDirectoryIfNeed;

@end
