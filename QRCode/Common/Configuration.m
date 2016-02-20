//
//  Configuration.m
//  
//
//  Created by CarlLiu on 16/1/4.
//  Copyright © 2016年 CarlLiu. All rights reserved.
//

#import "Configuration.h"

@interface Configuration ()
@property (nonatomic, strong) NSMutableDictionary *info;

@end


@implementation Configuration

DEFINE_SINGLETON_FOR_CLASS(Configuration)

- (instancetype)init {
	self = [super init];
	if (self) {
        NSString *theFile = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
        self.info = [NSMutableDictionary dictionaryWithContentsOfFile:theFile];
	}
	return self;
}

#pragma mark - Config Method
- (NSString *)dbVersion {
    return [[[self.class sharedInstance] info] objectForKey:@"dbVersion"];
}

- (NSString *)dbFileName {
	return [[[self.class sharedInstance] info] objectForKey:@"dbFileName"];
}

- (NSString *)serverUrl {
	return [[[self.class sharedInstance] info] objectForKey:@"serverUrl"];
}

- (NSString *)totalUrl {
    return [[[self.class sharedInstance] info] objectForKey:@"totalUrl"];
}

@end