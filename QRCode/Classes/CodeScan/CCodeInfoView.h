//
//  CCodeInfoView.h
//  QRCode
//
//  Created by CarlLiu on 16/2/27.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCodeInfoViewDelegate <NSObject>
- (void)didClickedButtonAtIndex:(NSInteger)btnIndex;

@end

@interface CCodeInfoView : UIView
@property (nonatomic, strong) IBOutlet UILabel *codeLabel;
@property (nonatomic, strong) IBOutlet UILabel *infoLabel;
@property (nonatomic, strong) IBOutlet UIImageView *codeImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoHeight;

@property (nonatomic, weak) id<CCodeInfoViewDelegate> delegate;
@end
