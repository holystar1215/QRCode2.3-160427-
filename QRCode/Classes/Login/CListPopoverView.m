//
//  CListPopoverView.m
//  QRCode
//
//  Created by CarlLiu on 16/2/20.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CListPopoverView.h"

static NSString * const reuseIdentifier = @"UITableViewCell";

@interface CListPopoverView () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *headerView;
@property (nonatomic, strong) UITableView *contentTableView;

@end

@implementation CListPopoverView

- (instancetype)initWithFrame:(CGRect)frame andTarget:(id<CListPopoverViewDelegate>)target {
    self = [super initWithFrame:frame];
    if (self) {
        self.headerView = [[UISearchBar alloc] initWithFrame:CGRectZero];
        self.headerView.delegate = self;
        
        self.contentTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.contentTableView.delegate = self;
        self.contentTableView.dataSource = self;
        [self.contentTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        
        [self setupContentView:self.contentTableView andHeaderView:self.headerView];
        self.delegate = target;
    }
    
    return self;
}

- (void)reloadData {
    [self.contentTableView reloadData];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(numberOfItems)]) {
        return [self.delegate numberOfItems];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    // Configure the cell...
    cell.backgroundColor = [UIColor whiteColor];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self.delegate respondsToSelector:@selector(itemAtIndexPath:)]) {
        cell.textLabel.text = [self.delegate itemAtIndexPath:indexPath];
    } else {
        cell.textLabel.text = @"Null";
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didSelectedItemIndex:)]) {
        [self.delegate didSelectedItemIndex:indexPath.row];
    }
    
    [self dismissPopoverView];
}

#pragma mark - <UISearchBarDelegate>
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([self.delegate respondsToSelector:@selector(didChangeSearchText:)]) {
        [self.delegate didChangeSearchText:searchText];
    }
}

@end
