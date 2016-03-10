//
//  CCodeInfoView.m
//  QRCode
//
//  Created by CarlLiu on 16/2/27.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CCodeInfoView.h"
#import <UIControl+BlocksKit.h>

@interface CCodeInfoView ()
@property (nonatomic, strong) IBOutlet UIButton *checkButton;


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

}

- (IBAction)onCheck:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didCheckedButton:)]) {
        [self.delegate didCheckedButton:self.checkButton];
    }
}

@end
