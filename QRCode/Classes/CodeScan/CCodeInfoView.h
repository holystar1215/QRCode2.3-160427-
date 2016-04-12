//
//  CCodeInfoView.h
//  QRCode
//
//  Created by CarlLiu on 16/2/27.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCodeInfoView : UIView
@property (nonatomic, strong) IBOutlet UIImageView *codeImageView;
@property (nonatomic, strong) IBOutlet UILabel *codeLabel;
@property (nonatomic, strong) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *overageButton;

- (void)showInfo:(NSString *)info andCode:(NSString *)code toView:(UIView *)toView;
- (void)closeInfoView;

@end
