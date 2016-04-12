//
//  CCodeInfoView.m
//  QRCode
//
//  Created by CarlLiu on 16/2/27.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CCodeInfoView.h"
#import "MBProgressHUD+UIView.h"

@interface CCodeInfoView ()


@end

@implementation CCodeInfoView
- (instancetype)initWithFrame:(CGRect)frame {
    NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CCodeInfoView" owner:self options:nil];
    if (arrayOfViews.count < 1) {
        self = [super initWithFrame:frame];
    } else {
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[CCodeInfoView class]]){
            self = [super initWithFrame:frame];
        } else {
            self = [arrayOfViews objectAtIndex:0];
            self.frame = frame;
        }
    }
    return self;
}

- (void)awakeFromNib {
    [self.cancelButton setTitle:@"取消盘点" forState:UIControlStateNormal];
}

- (void)showInfo:(NSString *)info andCode:(NSString *)code toView:(UIView *)toView {
    self.infoLabel.text = info;
    self.codeLabel.text = code;
    
    [toView addSubview:self];
    [self autoCenterInSuperview];
    [self autoSetDimensionsToSize:self.bounds.size];
}

- (void)closeInfoView {
    [self removeFromSuperview];
}

@end
