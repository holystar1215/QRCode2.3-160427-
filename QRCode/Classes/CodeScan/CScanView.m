//
//  CScanView.m
//  QRCode
//
//  Created by CarlLiu on 16/2/28.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CScanView.h"

@interface CScanView ()
@property (nonatomic, strong) CAShapeLayer *overlay;
@end

@implementation CScanView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self addOverlayView];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)addOverlayView {
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    infoLabel.numberOfLines = 0;
    infoLabel.text = @"将取景框对准条形码，既可自动扫描";
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.font = [UIFont systemFontOfSize:13.0];
    infoLabel.textColor = [UIColor whiteColor];
    [self addSubview:infoLabel];

    [infoLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [infoLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:75];
    [infoLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [infoLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [infoLabel autoSetDimension:ALDimensionHeight toSize:21.0];
    
    UIImageView *scanFrame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_frame"]];
    [self addSubview:scanFrame];
    
    [scanFrame autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [scanFrame autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:infoLabel withOffset:5];
    [scanFrame autoSetDimensionsToSize:CGSizeMake(295, 295)];
    
//    UIImageView *scanLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_line"]];
//    [self addSubview:scanLine];
//    
//    [scanFrame autoAlignAxis:ALAxisHorizontal toSameAxisOfView:scanFrame];
//    [scanFrame autoAlignAxis:ALAxisVertical toSameAxisOfView:scanFrame];
//    [scanFrame autoSetDimensionsToSize:CGSizeMake(204, 3)];
}

@end
