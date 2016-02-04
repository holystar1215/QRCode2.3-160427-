//
//  CHeaderView.m
//  QRCode
//
//  Created by CarlLiu on 16/1/30.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CHeaderView.h"

@implementation CHeaderView

- (void)awakeFromNib {
    [self.headerImageView createBordersWithColor:[UIColor whiteColor] withCornerRadius:30 andWidth:2];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
