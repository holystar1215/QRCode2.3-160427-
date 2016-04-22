//
//  CListPopoverView.h
//  QRCode
//
//  Created by CarlLiu on 16/2/20.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CPopoverView.h"

@protocol CListPopoverViewDelegate <NSObject>

- (NSInteger)numberOfItems;
- (NSString *)itemAtIndexPath:(NSIndexPath *)indexPath;

- (void)didSelectedItemIndex:(NSInteger)index;

- (void)didChangeSearchText:(NSString *)searchText;

@end

@interface CListPopoverView : CPopoverView
@property (nonatomic, assign) NSInteger defaultIndex;
@property (nonatomic, weak) id<CListPopoverViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame andTarget:(id<CListPopoverViewDelegate>)target;
- (void)reloadData;

@end
