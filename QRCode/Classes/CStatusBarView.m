//
//  CStatusBarView.m
//  QRCode
//
//  Created by CarlLiu on 16/1/30.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CStatusBarView.h"

@implementation CStatusBarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Init your class here.
    }
    
    return self;
}

- (void)dealloc {
    
}

- (void)awakeFromNib {
    [self setBackgroundColor:[UIColor blackColor]];
}

@end
