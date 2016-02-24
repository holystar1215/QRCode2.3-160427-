//
//  CStatusView.m
//  QRCode
//
//  Created by CarlLiu on 16/2/24.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CStatusView.h"

@implementation CStatusView

- (void)awakeFromNib {
    self.countImageView.image = [UIImage imageNamed:@"record_count"];
    self.amountImageView.image = [UIImage imageNamed:@"amount"];
}

@end
