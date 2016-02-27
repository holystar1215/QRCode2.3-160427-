//
//  CRecordViewController.m
//  QRCode
//
//  Created by CarlLiu on 16/2/25.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CRecordViewController.h"
#import "CListPopoverView.h"
#import "CRecordTableViewCell.h"

static NSString * const reuseIdentifier = @"CRecordTableViewCell";

@interface CRecordViewController () <UITableViewDataSource, UITableViewDelegate, CListPopoverViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *contentTableView;
@property (strong, nonatomic) CListPopoverView *popupListView;
@property (strong, nonatomic) NSArray *schoolArray;
@property (strong, nonatomic) NSArray *resultArray;
@property (assign, nonatomic) NSInteger currentSchool;

@property (weak, nonatomic) IBOutlet UITextField *xcfddTextField;
@property (weak, nonatomic) IBOutlet UITextField *xlyrTextField;
@property (weak, nonatomic) IBOutlet UITextField *xlyrghTextField;
@property (weak, nonatomic) IBOutlet UITextField *xsydwhTextField;

@end

@implementation CRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.contentTableView registerNib:[UINib nibWithNibName:@"CRecordTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back-arrow"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSAttributedString *)recordByType:(NSInteger)type andModel:(id)aModel {
    if (!aModel) {
        return nil;
    }
    
    NSString *recordString = @"";
    NSMutableAttributedString *attributedString;
    
    switch (type) {
        case 1: {
            CLogRecordModel *model = aModel;
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
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor groupTableViewBackgroundColor] range:NSMakeRange(offset, len)];
            
            offset = [[NSString stringWithFormat:@"资产编号：%@\n领用人：%@\n使用单位号：%@\n使用单位名：%@\n存放地点：%@\n入库时间：%@\n使用方向名：%@\n经费科目名：%@\n", model.zcbh, model.lyr, model.sydwh, model.syfxm, model.cfdd, model.rksj, model.syfxm, model.jfkmm] length];
            len = [[NSString stringWithFormat:@"名称：%@\n型号：%@\n规格：%@\n金额：%@\n厂家：%@\n经销商：%@\n资产内容：%@", model.mc, model.xh, model.gg, model.jine, model.changjia, model.jxs, model.zcnr] length];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor groupTableViewBackgroundColor] range:NSMakeRange(offset, len)];
            
            break;
        }
        case 2: {
            COverageRecordModel *model = aModel;
            recordString = [NSString stringWithFormat:@"资产编号：%@\n名称：%@\n单位名称：%@\n盘点人：%@\n盘点时间：%@", model.zcbh, model.mc, model.sydwm, model.lyr, model.rksj];
            attributedString = [[NSMutableAttributedString alloc] initWithString:recordString];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(0, recordString.length)];
            
            NSInteger offset = 0, len = 0;
            
            offset = [[NSString stringWithFormat:@"资产编号："] length];
            len = model.zcbh.length;
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(offset, len)];
            
            offset = [[NSString stringWithFormat:@"资产编号：%@\n名称：%@\n单位名称：%@\n", model.zcbh, model.mc, model.sydwm] length];
            len = [[NSString stringWithFormat:@"盘点人：%@\n盘点时间：%@", model.lyr, model.rksj] length];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(offset, len)];
            
            break;
        }
        case 3: {
            CLogRecordModel *model = aModel;
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
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor groupTableViewBackgroundColor] range:NSMakeRange(offset, len)];
            
            offset = [[NSString stringWithFormat:@"资产编号：%@\n领用人：%@\n使用单位号：%@\n使用单位名：%@\n存放地点：%@\n入库时间：%@\n使用方向名：%@\n经费科目名：%@\n", model.zcbh, model.lyr, model.sydwh, model.syfxm, model.cfdd, model.rksj, model.syfxm, model.jfkmm] length];
            len = [[NSString stringWithFormat:@"名称：%@\n型号：%@\n规格：%@\n金额：%@\n厂家：%@\n经销商：%@\n资产内容：%@", model.mc, model.xh, model.gg, model.jine, model.changjia, model.jxs, model.zcnr] length];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(offset, len)];
            
            break;
        }
        default:
            break;
    }
    
    return attributedString;
}

- (IBAction)onSubmit:(id)sender {
    if ([self.xcfddTextField.text isEqualToString:@""] && [self.xlyrTextField.text isEqualToString:@""] && [self.xsydwhTextField.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"提交修改的参数不能全部为空"];
        return;
    }
    
    if ([self.xlyrTextField.text isEqualToString:@""] && ![self.xlyrghTextField.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"领用人工号错误,请重新输入"];
        return;
    }
    
    CLogRecordModel *model = self.modelSelected;
    NSDictionary *dict = @{
                           @"cfdd":@"*",
                           @"fjmc":@"",
                           @"lyr":[model lyr],
                           @"sydwh":[model sydwh],
                           @"x_cfdd":@"*",
                           @"x_lyr":@"*",
                           @"x_lyrgh":@"*",
                           @"x_sydwh":@"*",
                           @"xgrgh":[[CDataSource sharedInstance].loginDict yhmc],
                           @"zcbh":[model zcbh]
                           };
    NSError *modelError;
    CModifyRecordModel *modifyModel = [[CModifyRecordModel alloc] initWithDictionary:dict error:&modelError];
    if (!modelError) {
        if (![self.xcfddTextField.text isEqualToString:@""]) {
            modifyModel.x_cfdd = self.xcfddTextField.text;
        }
        if (![self.xlyrTextField.text isEqualToString:@""]) {
            modifyModel.x_lyr = self.xlyrTextField.text;
        }
        if (![self.xlyrghTextField.text isEqualToString:@""]) {
            modifyModel.x_lyrgh = self.xlyrghTextField.text;
        }
        if (![self.xsydwhTextField.text isEqualToString:@""]) {
            modifyModel.x_sydwh = self.xsydwhTextField.text;
        }
    }
    
    [[CWebService sharedInstance] modify_record:modifyModel success:^(NSString *msg) {
        [MBProgressHUD showSuccess:msg];
    } failure:^(CWebServiceError *error) {
        [MBProgressHUD showError:error.localizedDescription];
    } animated:YES message:@""];
}

- (void)showPopList {
    [[CWebService sharedInstance] school_list_success:^(NSArray *models) {
        NSError *jsonError;
        self.schoolArray = [MTLJSONAdapter modelsOfClass:[CSchoolModel class] fromJSONArray:models error:&jsonError];
        self.resultArray = [NSArray arrayWithArray:self.schoolArray];
        self.popupListView = [[CListPopoverView alloc] initWithFrame:CGRectZero andTarget:self];
        self.popupListView.autoHidden = YES;
        [self.popupListView showPopoverView];
    } failure:^(CWebServiceError *error) {
        [MBProgressHUD showError:error.localizedDescription];
    } animated:YES message:@""];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    // Configure the cell...
    cell.recordLabel.attributedText = [self recordByType:self.recordType andModel:self.modelSelected];
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
    cell.recordLabel.attributedText = [self recordByType:self.recordType andModel:self.modelSelected];
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
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - <CListPopoverViewDelegate>
- (NSInteger)numberOfItems {
    return [self.resultArray count];
}

- (NSString *)itemAtIndexPath:(NSIndexPath *)indexPath {
    CSchoolModel *school = self.resultArray[indexPath.row];
    return school.schoolName;
}

- (void)didSelectedItemIndex:(NSInteger)index {
    self.currentSchool = index;
    
    CSchoolModel *school = self.resultArray[self.currentSchool];
    self.xsydwhTextField.text = school.schoolName;
}

- (void)didChangeSearchText:(NSString *)searchText {
    NSString *match = [NSString stringWithFormat:@"*%@*", searchText];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"schoolName like[cd] %@", match];
    self.resultArray = [self.schoolArray filteredArrayUsingPredicate:predicate];
    
    [self.popupListView reloadData];
}

@end
