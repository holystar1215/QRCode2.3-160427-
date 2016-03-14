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

static NSString * const reuseIdentifier = @"CRecordTableViewCell";

@interface CInventoryRecordViewController () <UITableViewDataSource, UITableViewDelegate, CCFilterViewControllerDelegate>
@property (nonatomic, weak) IBOutlet UITableView *contentTableView;
@property (weak, nonatomic) IBOutlet CStatusView *statusView;

@property (nonatomic, strong) NSArray *itemsArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger recordCount;

@property (nonatomic, strong) NSString *lyr;
@property (nonatomic, strong) NSString *zcbh;
@property (nonatomic, strong) NSString *cfdd;

@end

@implementation CInventoryRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.currentPage = 1;
    [self.statusView createBordersWithColor:[UIColor groupTableViewBackgroundColor] withCornerRadius:0 andWidth:1];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"CRecordTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back-arrow"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    self.lyr = @"";
    self.zcbh = @"";
    self.cfdd = @"";
    
    switch (self.recordType) {
        case 2: {
            break;
        }
        case 1:
        case 3: {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"筛选" style:UIBarButtonItemStylePlain handler:^(id sender) {
                CFilterViewController *vc = [[CFilterViewController alloc] initWithNibName:@"CFilterViewController" bundle:nil];
                vc.title = @"筛选";
                vc.delegate = self;
                vc.lyr = self.lyr;
                vc.zcbh = self.zcbh;
                vc.cfdd = self.cfdd;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            break;
        }
        default:
            break;
    }
    
    
    weakSelf(wSelf);
    self.contentTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if ([wSelf.itemsArray count] < wSelf.recordCount) {
            wSelf.currentPage += 1;
            
            NSString *company = [[CDataSource sharedInstance].loginModel pddw];
            if (company) {
                [[CWebService sharedInstance] record_currentpage:[NSString stringWithFormat:@"%ld", (long)wSelf.currentPage] company:company type:[NSString stringWithFormat:@"%ld", (long)wSelf.recordType] lyr:self.lyr zcbh:self.zcbh cfdd:self.cfdd success:^(NSArray *models, NSString *msg) {
                    NSError *jsonError;
                    NSMutableArray *moreItems = [[NSMutableArray alloc] initWithArray:self.itemsArray];
                    switch (wSelf.recordType) {
                        case 1: {
                            [moreItems addObjectsFromArray:[MTLJSONAdapter modelsOfClass:[CLogRecordModel class] fromJSONArray:models error:&jsonError]];
                            break;
                        }
                        case 2: {
                            [moreItems addObjectsFromArray:[MTLJSONAdapter modelsOfClass:[COverageRecordModel class] fromJSONArray:models error:&jsonError]];
                            break;
                        }
                        case 3: {
                            [moreItems addObjectsFromArray:[MTLJSONAdapter modelsOfClass:[CLogRecordModel class] fromJSONArray:models error:&jsonError]];
                            break;
                        }
                        default:
                            break;
                    }
                    wSelf.itemsArray = moreItems;
                    [wSelf.contentTableView reloadData];
                    [wSelf.contentTableView.footer resetNoMoreData];
                } failure:^(CWebServiceError *error) {
                    [MBProgressHUD showError:error.errorMessage];
                } animated:NO message:nil];
            }
        } else {
            [wSelf.contentTableView.footer endRefreshingWithNoMoreData];
        }
    }];
    
    [self reloadRecordData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadRecordData {
    weakSelf(wSelf);
    NSString *company = [[CDataSource sharedInstance].loginModel pddw];
    if (company) {
        [[CWebService sharedInstance] record_currentpage:[NSString stringWithFormat:@"%ld", (long)wSelf.currentPage] company:company type:[NSString stringWithFormat:@"%ld", (long)self.recordType] lyr:self.lyr zcbh:self.zcbh cfdd:self.cfdd success:^(NSArray *models, NSString *msg) {
            NSError *jsonError;
            switch (wSelf.recordType) {
                case 1: {
                    wSelf.itemsArray = [MTLJSONAdapter modelsOfClass:[CLogRecordModel class] fromJSONArray:models error:&jsonError];
                    break;
                }
                case 2: {
                    wSelf.itemsArray = [MTLJSONAdapter modelsOfClass:[COverageRecordModel class] fromJSONArray:models error:&jsonError];
                    break;
                }
                case 3: {
                    wSelf.itemsArray = [MTLJSONAdapter modelsOfClass:[CLogRecordModel class] fromJSONArray:models error:&jsonError];
                    break;
                }
                default:
                    break;
            }
            [wSelf.contentTableView reloadData];
            wSelf.recordCount = [wSelf formatStatusMsg:msg];
            [wSelf.contentTableView.footer resetNoMoreData];
        } failure:^(CWebServiceError *error) {
            [MBProgressHUD showError:error.errorMessage];
        } animated:YES message:@""];
    }
}

- (void)setCount:(NSString *)count andAmount:(NSString *)amount {
//    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSString *countText = [NSString stringWithFormat:@"记录数：%@", count];//[formatter stringFromNumber:[NSNumber numberWithInteger:count]]
    NSMutableAttributedString *countAttributedString = [[NSMutableAttributedString alloc] initWithString:countText];
    [countAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(0, countText.length)];
    [countAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
    [countAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(4, countText.length - 4)];
    
    self.statusView.countLabel.attributedText = countAttributedString;
    
    NSString *amountText = [NSString stringWithFormat:@"金额总计：%@", amount];//[formatter stringFromNumber:[NSNumber numberWithFloat:amount]]
    NSMutableAttributedString *amountAttributedString = [[NSMutableAttributedString alloc] initWithString:amountText];
    [amountAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(0, amountText.length)];
    [amountAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
    [amountAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, amountText.length - 5)];
    
    self.statusView.amountLabel.attributedText = amountAttributedString;
}

- (NSInteger)formatStatusMsg:(NSString *)msg {
    NSString *cj = msg;
    cj = [cj stringByReplacingOccurrencesOfString:@"记录数:" withString:@""];
    cj = [cj stringByReplacingOccurrencesOfString:@"、金额合计:" withString:@","];

    NSArray *cjArray = [cj componentsSeparatedByString:@","];
    if (cjArray && [cjArray count] > 0) {
        [self setCount:cjArray[0] andAmount:cjArray[1]];
        return [cjArray[0] integerValue];
    } else {
        [self setCount:@"" andAmount:@""];
        return 0;
    }
}

- (NSAttributedString *)type:(NSInteger)type recordIndex:(NSInteger)recordIndex {
    NSString *recordString = @"";
    NSMutableAttributedString *attributedString;
    
    switch (type) {
        case 1: {
            CLogRecordModel *model = self.itemsArray[recordIndex];
            recordString = [NSString stringWithFormat:@"资产编号：%@\n领用人：%@\n使用单位号：%@\n使用单位名：%@\n存放地点：%@\n入库时间：%@\n使用方向名：%@\n经费科目名：%@\n名称：%@\n型号：%@\n规格：%@\n金额：%@\n厂家：%@\n经销商：%@\n资产内容：%@", model.zcbh, model.lyr, model.sydwh, model.syfxm, model.cfdd, model.rksj, model.syfxm, model.jfkmm, model.mc, model.xh, model.gg, model.jine, model.changjia, model.jxs, model.zcnr];
            attributedString = [[NSMutableAttributedString alloc] initWithString:recordString];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(0, recordString.length)];
            
            NSInteger offset = 0, len = 0;
            
            offset = [[NSString stringWithFormat:@"资产编号："] length];
            len = model.zcbh.length;
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(offset, len)];
            
            offset = [[NSString stringWithFormat:@"资产编号：%@\n领用人：", model.zcbh] length];
            len = [model.lyr length];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(offset, len)];
            
            offset = [[NSString stringWithFormat:@"资产编号：%@\n领用人：%@\n使用单位号：%@\n使用单位名：%@\n存放地点：", model.zcbh, model.lyr, model.sydwh, model.syfxm] length];
            len = [model.cfdd length];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(offset, len)];
            
            offset = [[NSString stringWithFormat:@"资产编号：%@\n领用人：%@\n使用单位号：%@\n使用单位名：%@\n存放地点：%@\n入库时间：%@\n使用方向名：%@\n经费科目名：%@\n", model.zcbh, model.lyr, model.sydwh, model.syfxm, model.cfdd, model.rksj, model.syfxm, model.jfkmm] length];
            len = [[NSString stringWithFormat:@"名称：%@\n型号：%@\n规格：%@\n金额：%@\n厂家：%@\n经销商：%@\n资产内容：%@", model.mc, model.xh, model.gg, model.jine, model.changjia, model.jxs, model.zcnr] length];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(offset, len)];
            
            break;
        }
        case 2: {
            COverageRecordModel *model = self.itemsArray[recordIndex];
            recordString = [NSString stringWithFormat:@"资产编号：%@\n名称：%@\n单位名称：%@\n盘点人：%@\n盘点时间：%@", model.zcbh, model.mc, model.sydwm, model.lyr, model.rksj];
            attributedString = [[NSMutableAttributedString alloc] initWithString:recordString];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(0, recordString.length)];
            
            NSInteger offset = 0, len = 0;
            
            offset = [[NSString stringWithFormat:@"资产编号："] length];
            len = model.zcbh.length;
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(offset, len)];
            
            offset = [[NSString stringWithFormat:@"资产编号：%@\n名称：%@\n单位名称：%@\n", model.zcbh, model.mc, model.sydwm] length];
            len = [[NSString stringWithFormat:@"盘点人：%@\n盘点时间：%@", model.lyr, model.rksj] length];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(offset, len)];
            
            break;
        }
        case 3: {
            CLogRecordModel *model = self.itemsArray[recordIndex];
            recordString = [NSString stringWithFormat:@"资产编号：%@\n领用人：%@\n使用单位号：%@\n使用单位名：%@\n存放地点：%@\n入库时间：%@\n使用方向名：%@\n经费科目名：%@\n名称：%@\n型号：%@\n规格：%@\n金额：%@\n厂家：%@\n经销商：%@\n资产内容：%@", model.zcbh, model.lyr, model.sydwh, model.syfxm, model.cfdd, model.rksj, model.syfxm, model.jfkmm, model.mc, model.xh, model.gg, model.jine, model.changjia, model.jxs, model.zcnr];
            attributedString = [[NSMutableAttributedString alloc] initWithString:recordString];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(0, recordString.length)];
            
            NSInteger offset = 0, len = 0;
            
            offset = [[NSString stringWithFormat:@"资产编号："] length];
            len = model.zcbh.length;
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(offset, len)];
            
            offset = [[NSString stringWithFormat:@"资产编号：%@\n领用人：", model.zcbh] length];
            len = [model.lyr length];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(offset, len)];
            
            offset = [[NSString stringWithFormat:@"资产编号：%@\n领用人：%@\n使用单位号：%@\n使用单位名：%@\n存放地点：", model.zcbh, model.lyr, model.sydwh, model.syfxm] length];
            len = [model.cfdd length];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(offset, len)];
            
            offset = [[NSString stringWithFormat:@"资产编号：%@\n领用人：%@\n使用单位号：%@\n使用单位名：%@\n存放地点：%@\n入库时间：%@\n使用方向名：%@\n经费科目名：%@\n", model.zcbh, model.lyr, model.sydwh, model.syfxm, model.cfdd, model.rksj, model.syfxm, model.jfkmm] length];
            len = [[NSString stringWithFormat:@"名称：%@\n型号：%@\n规格：%@\n金额：%@\n厂家：%@\n经销商：%@\n资产内容：%@", model.mc, model.xh, model.gg, model.jine, model.changjia, model.jxs, model.zcnr] length];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(offset, len)];
            
            break;
        }
        default:
            break;
    }
    
    return attributedString;
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.itemsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    // Configure the cell...
    cell.recordLabel.attributedText = [self type:self.recordType recordIndex:indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.recordType == 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    return cell;
}

#pragma mark - <UITableViewDelegate>
//如果要支持iOS7这个方法必须实现
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.recordLabel.attributedText = [self type:self.recordType recordIndex:indexPath.row];
    cell.recordLabel.numberOfLines = 0;
    
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
    cell.recordLabel.attributedText = nil;
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.recordType) {
        case 1: {
            
            break;
        }
        case 2: {
            
            break;
        }
        case 3: {
            CRecordViewController *vc = [[CRecordViewController alloc] initWithNibName:@"CRecordViewController" bundle:nil];
            vc.title = @"数据修改";
            vc.modelSelected = self.itemsArray[indexPath.row];
            vc.recordType = self.recordType;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - <CCFilterViewControllerDelegate>
- (void)didSearchByLyr:(NSString *)lyr andZcbh:(NSString *)zcbh andCfdd:(NSString *)cfdd {
    self.lyr = lyr;
    self.zcbh = zcbh;
    self.cfdd = cfdd;
    [self reloadRecordData];
}

@end
