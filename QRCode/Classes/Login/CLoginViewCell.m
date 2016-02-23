//
//  CLoginViewCell.m
//  QRCode
//
//  Created by CarlLiu on 16/2/1.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CLoginViewCell.h"

@interface CLoginViewCell () <UITextFieldDelegate>

@end

@implementation CLoginViewCell

- (void)awakeFromNib {
    self.textField.delegate = self;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(didSelectCell:)]) {
        [self.delegate didSelectCell:self];
    }
}

@end
