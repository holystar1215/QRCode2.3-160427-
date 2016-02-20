//
//  Configuration.h
//  
//
//  Created by CarlLiu on 16/1/4.
//  Copyright © 2016年 CarlLiu. All rights reserved.
//

#import <Foundation/Foundation.h>

// Default Colors
#define kColorNavBarBackgroud               RGBA(14, 101, 181, 1)
#define kColorBlueText                      RGBA(17, 94, 255, 1)

#define kColorTabbarTextNormal              RGBA(12, 98, 255, 1)
#define kColorTabbarTextSeleced             RGBA(98, 98, 98, 1)

#define kColorNavigationBar                 RGBA(29, 139, 242, 1)

#define kColorTextBlue                      RGB(29, 139, 242)
#define kColorTextGray                      RGB(50, 50, 50)

// UI Notification


// User Default


@interface Configuration : NSObject

DEFINE_SINGLETON_FOR_HEADER(Configuration)

- (NSString *)dbVersion;
- (NSString *)dbFileName;

- (NSString *)serverUrl;
- (NSString *)totalUrl;

@end