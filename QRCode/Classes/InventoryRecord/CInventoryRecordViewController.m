//
//  CInventoryRecordViewController.m
//  QRCode
//
//  Created by CarlLiu on 16/2/24.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CInventoryRecordViewController.h"
#import "CRecordTableViewCell.h"

#import <Masonry.h>
#import <UIBarButtonItem+BlocksKit.h>
#import <MJRefresh/MJRefreshAutoNormalFooter.h>

static NSString * const reuseIdentifier = @"UITableViewCell";

@interface CInventoryRecordViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *contentTableView;
@property (weak, nonatomic) IBOutlet CStatusView *statusView;

@property (nonatomic, strong) NSArray *itemsArray;

@end

@implementation CInventoryRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back-arrow"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"筛选" style:UIBarButtonItemStylePlain handler:^(id sender) {
        
    }];
    
    self.currentPage = 1;
    [[CWebService sharedInstance] record_currentpage:self.currentPage company:self.assetCompany type:self.recordType success:^(NSArray *models) {
        
    } failure:^(CWebServiceError *error) {
        
    } animated:YES message:@""];
    [self setCount:10 andAmount:10.23];
    self.contentTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [[CWebService sharedInstance] record_currentpage:self.currentPage company:self.assetCompany type:self.recordType success:^(NSArray *models) {
            
        } failure:^(CWebServiceError *error) {
            
        } animated:YES message:@""];
    }];
}

- (void)setCount:(NSInteger)count andAmount:(CGFloat)amount {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSString *countText = [NSString stringWithFormat:@"记录数：%@", [formatter stringFromNumber:[NSNumber numberWithInteger:count]]];
    NSMutableAttributedString *countAttributedString = [[NSMutableAttributedString alloc] initWithString:countText];
    [countAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(0, countText.length)];
    [countAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
    [countAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(4, countText.length - 4)];
    
    self.statusView.countLabel.attributedText = countAttributedString;
    
    NSString *amountText = [NSString stringWithFormat:@"金额总计：%@", [formatter stringFromNumber:[NSNumber numberWithFloat:amount]]];
    NSMutableAttributedString *amountAttributedString = [[NSMutableAttributedString alloc] initWithString:amountText];
    [amountAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(0, amountText.length)];
    [amountAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
    [amountAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, amountText.length - 5)];
    
    self.statusView.amountLabel.attributedText = amountAttributedString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    // Configure the cell...
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - <UITableViewDelegate>
//如果要支持iOS7这个方法必须实现
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    //这句代码必须要有，也就是说必须要设定contentView的宽度约束。
    //设置以后，contentView里面的内容才知道什么时候该换行了
    CGFloat contentViewWidth = CGRectGetWidth(tableView.frame);
    [cell.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(contentViewWidth));
    }];
    
    //重新加载约束,每次计算之前一定要重新确认一下约束
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    //自动算高度，+1的原因是因为contentView的高度要比cell的高度小1
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
