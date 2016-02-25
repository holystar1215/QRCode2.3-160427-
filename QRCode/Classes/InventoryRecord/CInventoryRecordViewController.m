//
//  CInventoryRecordViewController.m
//  QRCode
//
//  Created by CarlLiu on 16/2/24.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CInventoryRecordViewController.h"
#import "CRecordViewController.h"
#import "CFilterViewController.h"
#import "CRecordTableViewCell.h"
#import "CRecordModel.h"

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
    self.currentPage = 1;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back-arrow"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"筛选" style:UIBarButtonItemStylePlain handler:^(id sender) {
        CFilterViewController *vc = [[CFilterViewController alloc] initWithNibName:@"CFilterViewController" bundle:nil];
        vc.title = @"筛选";
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    NSString *company = [[CDataSource sharedInstance].loginDict pddw];
    if (company) {
        [[CWebService sharedInstance] record_currentpage:[NSString stringWithFormat:@"%d", self.currentPage] company:company type:[NSString stringWithFormat:@"%d", self.recordType] success:^(NSArray *models) {
            NSError *jsonError;
            self.itemsArray = [MTLJSONAdapter modelsOfClass:[CRecordModel class] fromJSONArray:models error:&jsonError];
            __block CGFloat sumValue = 0.0;
            [self.itemsArray enumerateObjectsUsingBlock:^(CRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                sumValue = sumValue + [obj.jine floatValue];
            }];
            [self setCount:[self.itemsArray count] andAmount:sumValue];
        } failure:^(CWebServiceError *error) {
            [MBProgressHUD showError:error.localizedDescription];
        } animated:YES message:@""];
    }
    
    self.contentTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        NSString *company = [[CDataSource sharedInstance].loginDict pddw];
        if (company) {
            [[CWebService sharedInstance] record_currentpage:[NSString stringWithFormat:@"%d", self.currentPage] company:company type:[NSString stringWithFormat:@"%d", self.recordType] success:^(NSArray *models) {
                NSError *jsonError;
                NSMutableArray *moreItems = [[NSMutableArray alloc] initWithArray:self.itemsArray];
                [moreItems addObjectsFromArray:[MTLJSONAdapter modelsOfClass:[CRecordModel class] fromJSONArray:models error:&jsonError]];
                self.itemsArray = moreItems;
                __block CGFloat sumValue = 0.0;
                [self.itemsArray enumerateObjectsUsingBlock:^(CRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    sumValue = sumValue + [obj.jine floatValue];
                }];
                [self.contentTableView reloadData];
                [self setCount:[self.itemsArray count] andAmount:sumValue];
            } failure:^(CWebServiceError *error) {
                [MBProgressHUD showError:error.localizedDescription];
            } animated:YES message:@""];
        }
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

- (NSAttributedString *)type:(NSInteger)type recordIndex:(NSInteger)recordIndex {
    NSString *recordString = @"";
//    CRecordModel *model = self.itemsArray[recordIndex];
    switch (type) {
        case 1: {
            
            break;
        }
        case 2: {
//            recordString = [NSString stringWithFormat:@"资产编号：%@\n名称：%@\n单位名称：%@\n盘点人：%@\n盘点时间：%@", model.zcbh, model.mc, model.sydwm, model];
            break;
        }
        case 3: {
            break;
        }
        default:
            break;
    }
    NSMutableAttributedString *recordAttributedString = [[NSMutableAttributedString alloc] initWithString:recordString];
    
    return recordAttributedString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.itemsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.recordType == 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
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
    switch (self.recordType) {
        case 1: {
            
            break;
        }
        case 2: {
            CRecordViewController *vc = [[CRecordViewController alloc] initWithNibName:@"CRecordViewController" bundle:nil];
            vc.title = self.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3: {
            CRecordViewController *vc = [[CRecordViewController alloc] initWithNibName:@"CRecordViewController" bundle:nil];
            vc.title = self.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
