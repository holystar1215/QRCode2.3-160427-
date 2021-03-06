//
//  CLoginViewCell.h
//  QRCode
//
//  Created by CarlLiu on 16/2/1.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLoginViewCell;
@protocol CLoginViewCellDelegate <NSObject>
@optional
- (void)didSelectCell:(CLoginViewCell *)cell;

@end

@interface CLoginViewCell : UITableViewCell
@property (weak, nonatomic) id<CLoginViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
