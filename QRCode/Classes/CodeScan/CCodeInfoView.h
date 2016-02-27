//
//  CCodeInfoView.h
//  QRCode
//
//  Created by CarlLiu on 16/2/27.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCodeInfoViewDelegate <NSObject>
- (void)didCheckedButton:(UIButton *)sender;

@end

@interface CCodeInfoView : UIView
@property (nonatomic, strong) IBOutlet UILabel *codeLabel;
@property (nonatomic, strong) IBOutlet UILabel *infoLabel;
@property (nonatomic, strong) IBOutlet UIImageView *codeImageView;

@property (nonatomic, weak) id<CCodeInfoViewDelegate> delegate;
@end
