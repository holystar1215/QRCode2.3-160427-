//
//  CStatusView.h
//  QRCode
//
//  Created by CarlLiu on 16/2/24.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CStatusView : UIView
@property (nonatomic, weak) IBOutlet UIImageView *countImageView;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;

@property (nonatomic, weak) IBOutlet UIImageView *amountImageView;
@property (nonatomic, weak) IBOutlet UILabel *amountLabel;

@end
