//  CPublicModule.h
//  
//
//  Created by LiuCarl on 15/1/8.
//  Copyright (c) 2015年 Carl Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <mach/mach_time.h>  // for mach_absolute_time() and friends
                            // adapted from http://blog.bignerdranch.com/316-a-timing-utility/
#import <CoreGraphics/CGBase.h>

#define APP_BUNDLE_ID [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
#define APP_DOMAIN [APP_BUNDLE_ID stringByAppendingString:@".Domain"]
#define APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

// GUUID
#pragma mark - GUUID Maker
#define MK_GUUID [[NSUUID UUID] UUIDString]

#pragma mark - Safe Perform
#define SAFE_PERFORM_WITH_ARG(THE_OBJECT, THE_SELECTOR, THE_ARG)  ((THE_OBJECT) ? ([THE_OBJECT respondsToSelector:THE_SELECTOR]) ? [THE_OBJECT performSelector:THE_SELECTOR withObject:THE_ARG] : nil : nil)
#define SAFE_PERFORM_WITH_ARGS(THE_OBJECT, THE_SELECTOR, THE_ARG1 , THE_ARG2) (([THE_OBJECT respondsToSelector:THE_SELECTOR]) ? [THE_OBJECT performSelector:THE_SELECTOR withObject:THE_ARG1 withObject:THE_ARG2] : nil)

// User Default
#pragma mark -
#pragma mark User Default
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

// Load image by name
#pragma mark -
#pragma mark Load image by name
#define ImageNamed(_pointer) [UIImage imageNamed:_pointer]

/* Localized versions of Info.plist defines */
#pragma mark -
#pragma mark Localized
#define LOCALIZED_STRING(key) (NSLocalizedStringFromTable((key), @"InfoPlist", LocalStr_None))

#pragma mark -
#pragma mark Collections

#define IDARRAY(...) (id []){ __VA_ARGS__ }
#define IDCOUNT(...) (sizeof(IDARRAY(__VA_ARGS__)) / sizeof(id))

#define ARRAY(...) [NSArray arrayWithObjects: IDARRAY(__VA_ARGS__) count: IDCOUNT(__VA_ARGS__)]

#define DICT(...) DictionaryWithIDArray(IDARRAY(__VA_ARGS__), IDCOUNT(__VA_ARGS__) / 2)

//The helper function unpacks the object array and then calls through to NSDictionary to create the dictionary:
static inline NSDictionary *DictionaryWithIDArray(id *array, NSUInteger count) {
    id keys[count];
    id objs[count];
    
    for(NSUInteger i = 0; i < count; i++) {
        keys[i] = array[i * 2];
        objs[i] = array[i * 2 + 1];
    }
    
    return [NSDictionary dictionaryWithObjects: objs forKeys: keys count: count];
}
#define POINTERIZE(x) ((__typeof__(x) []){ x })
#define NSVALUE(x) [NSValue valueWithBytes: POINTERIZE(x) objCType: @encode(__typeof__(x))]

#pragma mark -
#pragma mark Blocks

#define BLOCK_SAFE_RUN(block, ...) block ? block(__VA_ARGS__) : nil

#pragma mark -
#pragma mark Logging

#define LOG(fmt, ...) NSLog(@"%s: " fmt, __PRETTY_FUNCTION__, ## __VA_ARGS__)

#ifdef DEBUG
#define INFO(fmt, ...) LOG(fmt, ## __VA_ARGS__)
#else
// do nothing
#define INFO(fmt, ...)
#endif

#define ERROR(fmt, ...) LOG(fmt, ## __VA_ARGS__)
#define TRACE(fmt, ...) LOG(fmt, ## __VA_ARGS__)

#define METHOD_NOT_IMPLEMENTED() NSAssert(NO, @"You must override %@ in a subclass", NSStringFromSelector(_cmd))

#pragma mark -
#pragma mark NSNumber

#define NUM_INT(int) [NSNumber numberWithInt:int]
#define NUM_FLOAT(float) [NSNumber numberWithFloat:float]
#define NUM_BOOL(bool) [NSNumber numberWithBool:bool]

#define ReplaceNULL2Empty(str)   ((nil == (str)) ? @"" : (str))

#pragma mark -
#pragma mark Frame Geometry

#define CENTER_VERTICALLY(parent,child) floor((parent.frame.size.height - child.frame.size.height) / 2)
#define CENTER_HORIZONTALLY(parent,child) floor((parent.frame.size.width - child.frame.size.width) / 2)

// example: [[UIView alloc] initWithFrame:(CGRect){CENTER_IN_PARENT(parentView,500,500),CGSizeMake(500,500)}];
#define CENTER_IN_PARENT(parent,childWidth,childHeight) CGPointMake(floor((parent.frame.size.width - childWidth) / 2),floor((parent.frame.size.height - childHeight) / 2))
#define CENTER_IN_PARENT_X(parent,childWidth) floor((parent.frame.size.width - childWidth) / 2)
#define CENTER_IN_PARENT_Y(parent,childHeight) floor((parent.frame.size.height - childHeight) / 2)

#define WIDTH(view) view.frame.size.width
#define HEIGHT(view) view.frame.size.height
#define X(view) view.frame.origin.x
#define Y(view) view.frame.origin.y
#define LEFT(view) view.frame.origin.x
#define TOP(view) view.frame.origin.y
#define BOTTOM(view) (view.frame.origin.y + view.frame.size.height)
#define RIGHT(view) (view.frame.origin.x + view.frame.size.width)

#pragma mark -
#pragma mark IndexPath
#define INDEX_PATH(a,b) [NSIndexPath indexPathWithIndexes:(NSUInteger[]){a,b} length:2]

#pragma mark -
#pragma mark Other
#define RPLACE_EMPTY_STRING(var) (var ? var : @"")
#define weakSelf(wSelf) __weak __typeof(self)wSelf = self

#define ALWAYS_TRUE YES ||
#define NEVER_TRUE NO &&

#pragma mark - Transforms
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian * 180.0) / (M_PI)

#define DEGREES_TO_RADIANS(degrees) degrees * M_PI / 180

#pragma mark - Share Instance
#ifndef SHARED_INSTANCE_GCD
#define SHARED_INSTANCE_GCD \
\
+ (instancetype)sharedInstance { \
DEFINE_SHARED_INSTANCE_GCD_USING_BLOCK(^{ \
return [[self alloc] init]; \
}) \
}
#endif

#ifndef SHARED_INSTANCE_GCD_USING_BLOCK
#define SHARED_INSTANCE_GCD_USING_BLOCK(block) \
\
+ (instancetype)sharedInstance { \
DEFINE_SHARED_INSTANCE_GCD_USING_BLOCK(block) \
}
#endif

#ifndef SHARED_INSTANCE_GCD_WITH_NAME
#define SHARED_INSTANCE_GCD_WITH_NAME(classname)                        \
\
+ (instancetype)shared##classname { \
DEFINE_SHARED_INSTANCE_GCD_USING_BLOCK(^{ \
return [[self alloc] init]; \
}) \
}
#endif

#ifndef SHARED_INSTANCE_GCD_WITH_NAME_USING_BLOCK
#define SHARED_INSTANCE_GCD_WITH_NAME_USING_BLOCK(classname, block) \
\
+ (instancetype)shared##classname { \
DEFINE_SHARED_INSTANCE_GCD_USING_BLOCK(block) \
}
#endif

#ifndef DEFINE_SHARED_INSTANCE_GCD_USING_BLOCK
#define DEFINE_SHARED_INSTANCE_GCD_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject;
#endif

//G－C－D
typedef void(^complete_block)(void);
#define BACKGROUD_RUN_BLOCK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAINTHREAD_RUN_BLOCK(block) dispatch_async(dispatch_get_main_queue(),block)

#pragma mark -

#define DEFINE_SINGLETON_FOR_HEADER(className) \
\
+ (className *)sharedInstance;

#define DEFINE_SINGLETON_FOR_CLASS(className) \
\
+ (className *)sharedInstance { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
@synchronized(self){ \
shared##className = [[self alloc] init]; \
} \
}); \
return shared##className; \
}

#if DEBUG
static inline void TimeThisBlock (void (^block)(void), NSString *message) {
    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info) != KERN_SUCCESS) {
        block();
        return;
    };
    
    uint64_t start = mach_absolute_time ();
    block ();
    uint64_t end = mach_absolute_time ();
    uint64_t elapsed = end - start;
    
    uint64_t nanos = elapsed * info.numer / info.denom;
    LOG(@"Took %f seconds to %@", (CGFloat)nanos / NSEC_PER_SEC, message);
}
#endif

#pragma mark -
#pragma mark CPublicModule Class
@interface CPublicModule : NSObject

DEFINE_SINGLETON_FOR_HEADER(CPublicModule);

// Load XIB by Stroyboard Id
+ (id)mainStoryboardId:(NSString *)storyboardId;
+ (UIViewController *)storyboardIdName:(NSString *)storyboardIdName withStoryboardIdId:(NSString *)storyboardId;

+ (CGSize)text:(NSString *)text font:(UIFont *)font size:(CGSize)size;

// Location Time
+ (NSDate *)currentLocalTime;
+ (NSString *)currentShortLocalTime;
+ (NSString *)shortDate:(NSDate *)aDate;

+ (NSString *)convertLongToDate:(long long)time;

- (NSString *)getDeviceSSID;

/**
 *  将JPEG图片编码为base64的文字(当然是通过data转的)
 *
 *  @param image 需要编码的图片
 *
 *  @return 编码后的文字
 */
+ (NSString *)encodeStringBase64WithJPEGImage:(UIImage *)image;

/**
 *  将PNG图片编码为base64的文字(当然是通过data转的)
 *
 *  @param image 需要编码的图片
 *
 *  @return 编码后的文字
 */
+ (NSString *)encodeStringBase64WithPNGImage:(UIImage *)image;

/**
 *  将base64的文字解码为图片
 *
 *  @param str 需要解码的文字
 *
 *  @return 解码后的图片
 */
+ (UIImage *)decodeStringBase64WithImage:(NSString *)str;

@end
