//
//  CCodeScanViewController.m
//  QRCode
//
//  Created by CarlLiu on 16/2/24.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CCodeScanViewController.h"
#import "MBProgressHUD+UIView.h"
#import "DSNavigationBar.h"
#import "CScanView.h"
#import "CCodeInfoView.h"

#import <UIBarButtonItem+BlocksKit.h>
#import <UIAlertView+BlocksKit.h>
#import <UIControl+BlocksKit.h>
#import <QRCameraSwitchButton.h>
#import <QRToggleTorchButton.h>

typedef NS_ENUM(NSInteger, ScanType) {
    eQRCode,
    eBarCode
};

@interface CCodeScanViewController ()
@property (strong, nonatomic) QRCameraSwitchButton *switchCameraButton;
@property (strong, nonatomic) QRToggleTorchButton  *toggleTorchButton;
@property (strong, nonatomic) CScanView            *cameraView;
@property (strong, nonatomic) UIButton             *cancelButton;
@property (strong, nonatomic) QRCodeReader         *codeReader;
@property (assign, nonatomic) BOOL                 startScanningAtLoad;
@property (assign, nonatomic) BOOL                 showSwitchCameraButton;
@property (assign, nonatomic) BOOL                 showTorchButton;

@property (strong, nonatomic) CCodeInfoView *infoView;
@property (assign, nonatomic) ScanType scanType;

@property (copy, nonatomic) void (^completionBlock) (NSString * __nullable);

@end

@implementation CCodeScanViewController

- (id)initWithCancelButtonTitle:(nullable NSString *)cancelTitle codeReader:(nonnull QRCodeReader *)codeReader startScanningAtLoad:(BOOL)startScanningAtLoad showSwitchCameraButton:(BOOL)showSwitchCameraButton showTorchButton:(BOOL)showTorchButton {
    if ((self = [super init])) {
        self.view.backgroundColor   = [UIColor blackColor];
        self.codeReader             = codeReader;
        self.startScanningAtLoad    = startScanningAtLoad;
        self.showSwitchCameraButton = showSwitchCameraButton;
        self.showTorchButton        = showTorchButton;
        
        if (cancelTitle == nil) {
            cancelTitle = NSLocalizedString(@"Cancel", @"Cancel");
        }
        
        [self setupUIComponentsWithCancelButtonTitle:cancelTitle];
        [self setupAutoLayoutConstraints];
        
        [_cameraView.layer insertSublayer:_codeReader.previewLayer atIndex:0];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
        
        __weak typeof(self) weakSelf = self;
        
        [codeReader setCompletionWithBlock:^(NSString *resultAsString) {
            if (weakSelf.completionBlock != nil) {
                weakSelf.completionBlock(resultAsString);
            }
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.infoView = [[CCodeInfoView alloc] initWithFrame:self.view.bounds];
    self.infoView.layer.frame = self.view.layer.frame;
    
    [self.infoView.cancelButton bk_addEventHandler:^(id sender) {
        [self gotoScanView];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.infoView.overageButton bk_addEventHandler:^(id sender) {
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back-arrow"] style:UIBarButtonItemStylePlain handler:^(id sender) {
//        [self.infoView.layer removeFromSuperlayer];
        [self.infoView removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    weakSelf(wSelf);
    [self setCompletionWithBlock:^(NSString *resultAsString) {
        switch (wSelf.scanType) {
            case eQRCode: {
                NSString *tmp = [resultAsString stringByReplacingOccurrencesOfString:@"×Ê²ú±àºÅ£º" withString:@""];
                tmp = [tmp stringByReplacingOccurrencesOfString:@"£»" withString:@"#"];
                tmp = [tmp substringToCharacter:'#'];
                
                NSLog(@"Completion with result: %@", resultAsString);
                [wSelf stopScanning];
                
                // -----
                [[CWebService sharedInstance] scan_code:tmp pddw:[[CDataSource sharedInstance].loginModel pddw] success:^(NSString *info, NSInteger code, NSString *msg) {
                    [wSelf setupInfoViewByServerInfo:(NSString *)info andServerMsg:msg andServerCode:code andCodeInfo:tmp];
                } failure:^(CWebServiceError *error) {
                    [MBProgressHUD showError:error.errorMessage];
                    [wSelf startScanning];
                } animated:YES message:nil];
                break;
            }
            case eBarCode: {
                NSString *tmp = [resultAsString stringByReplacingOccurrencesOfString:@"*" withString:@""];
                
                NSLog(@"Completion with result: %@", resultAsString);
                [wSelf stopScanning];
                
                // -----
                [[CWebService sharedInstance] scan_code:tmp pddw:[[CDataSource sharedInstance].loginModel pddw] success:^(NSString *info, NSInteger code, NSString *msg) {
                    [wSelf setupInfoViewByServerInfo:(NSString *)info andServerMsg:msg andServerCode:code andCodeInfo:tmp];
                } failure:^(CWebServiceError *error) {
                    [MBProgressHUD showError:error.errorMessage];
                    [wSelf startScanning];
                } animated:YES message:nil];
                break;
            }
            default:
                break;
        }
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_startScanningAtLoad) {
        [self startScanning];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self stopScanning];
    
    [super viewWillDisappear:animated];
    
    DSNavigationBar *bar = (DSNavigationBar *)self.navigationController.navigationBar;
    [bar setNavigationBarWithColor:RGBA(255, 255, 255, 0.8)];
    [bar setTintColor:[UIColor blueColor]];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _codeReader.previewLayer.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self stopScanning];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)qrCodeReader:(QRCodeReader *)codeReader startScanningAtLoad:(BOOL)startScanningAtLoad {
    CCodeScanViewController *vc = [[self alloc] initWithCancelButtonTitle:nil codeReader:codeReader startScanningAtLoad:startScanningAtLoad showSwitchCameraButton:NO showTorchButton:NO];
    vc.scanType = eQRCode;
    return vc;
}

+ (instancetype)barCodeReader:(QRCodeReader *)codeReader startScanningAtLoad:(BOOL)startScanningAtLoad {
    CCodeScanViewController *vc = [[self alloc] initWithCancelButtonTitle:nil codeReader:codeReader startScanningAtLoad:startScanningAtLoad showSwitchCameraButton:NO showTorchButton:NO];
    vc.scanType = eBarCode;
    return vc;
}

#pragma mark - Controlling the Reader
- (void)startScanning {
    [_codeReader startScanning];
}

- (void)stopScanning {
    [_codeReader stopScanning];
}

#pragma mark - Managing the Orientation
- (void)orientationChanged:(NSNotification *)notification
{
    [_cameraView setNeedsDisplay];
    
    if (_codeReader.previewLayer.connection.isVideoOrientationSupported) {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        _codeReader.previewLayer.connection.videoOrientation = [QRCodeReader videoOrientationFromInterfaceOrientation:
                                                                orientation];
    }
}

#pragma mark - Managing the Block
- (void)setCompletionWithBlock:(void (^) (NSString *resultAsString))completionBlock {
    self.completionBlock = completionBlock;
}

#pragma mark - Initializing the AV Components
- (void)setupUIComponentsWithCancelButtonTitle:(NSString *)cancelButtonTitle {
    self.cameraView                                       = [[CScanView alloc] init];
    _cameraView.translatesAutoresizingMaskIntoConstraints = NO;
    _cameraView.clipsToBounds                             = YES;
    [self.view addSubview:_cameraView];
    
    [_codeReader.previewLayer setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    if ([_codeReader.previewLayer.connection isVideoOrientationSupported]) {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        _codeReader.previewLayer.connection.videoOrientation = [QRCodeReader videoOrientationFromInterfaceOrientation:orientation];
    }
    
    if (_showSwitchCameraButton && [_codeReader hasFrontDevice]) {
        _switchCameraButton = [[QRCameraSwitchButton alloc] init];
        
        [_switchCameraButton setTranslatesAutoresizingMaskIntoConstraints:false];
        [_switchCameraButton addTarget:self action:@selector(switchCameraAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_switchCameraButton];
    }
    
    if (_showTorchButton && [_codeReader isTorchAvailable]) {
        _toggleTorchButton = [[QRToggleTorchButton alloc] init];
        
        [_toggleTorchButton setTranslatesAutoresizingMaskIntoConstraints:false];
        [_toggleTorchButton addTarget:self action:@selector(toggleTorchAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_toggleTorchButton];
    }
    
    self.cancelButton                                       = [[UIButton alloc] init];
    _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelButton];
    
    [self.cancelButton setHidden:YES];
}

- (void)setupAutoLayoutConstraints {
    NSDictionary *views = NSDictionaryOfVariableBindings(_cameraView, _cancelButton);
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_cameraView][_cancelButton(0)]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_cancelButton]-|" options:0 metrics:nil views:views]];
    
    id topLayoutGuide = self.topLayoutGuide;
    
    if (_switchCameraButton) {
        NSDictionary *switchViews = NSDictionaryOfVariableBindings(_switchCameraButton, topLayoutGuide);
        
        [self.view addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide]-[_switchCameraButton(50)]" options:0 metrics:nil views:switchViews]];
        [self.view addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_switchCameraButton(70)]|" options:0 metrics:nil views:switchViews]];
    }
    
    if (_toggleTorchButton) {
        NSDictionary *torchViews = NSDictionaryOfVariableBindings(_toggleTorchButton, topLayoutGuide);
        
        [self.view addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide]-[_toggleTorchButton(50)]" options:0 metrics:nil views:torchViews]];
        [self.view addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toggleTorchButton(70)]" options:0 metrics:nil views:torchViews]];
    }
}

- (void)switchDeviceInput {
    [_codeReader switchDeviceInput];
}

#pragma mark - Catching Button Events
- (void)cancelAction:(UIButton *)button {
    [_codeReader stopScanning];
    
    if (_completionBlock) {
        _completionBlock(nil);
    }
}

- (void)switchCameraAction:(UIButton *)button {
    [self switchDeviceInput];
}

- (void)toggleTorchAction:(UIButton *)button {
    [_codeReader toggleTorch];
}

#pragma mark - Info View
- (void)setupInfoViewByServerInfo:(NSString *)serverInfo andServerMsg:(NSString *)msg andServerCode:(NSInteger)serverCode andCodeInfo:(NSString *)codeInfo {
    switch (serverCode) {
        case 1002: {
            [MBProgressHUD showError:@"服务器异常"];
            [self startScanning];
            break;
        }
        case 1006: {
            if ([[CDataSource sharedInstance].schoolModel.gbpy isEqualToString:@"1"]) {
                UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:@"不能盘点"];
                [alertView bk_addButtonWithTitle:@"确定" handler:^{
                    [self gotoScanView];
                }];
                [alertView show];
                break;
            }
            [self.infoView.overageButton bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
            [self.infoView.overageButton setTitle:@"无此资产的实物账信息,点击盘盈" forState:UIControlStateNormal];
            [self.infoView.overageButton bk_addEventHandler:^(id sender) {
                UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:@"无此资产的实物账信息,请确认是否为您单位的盘盈资产?"];
                [alertView bk_addButtonWithTitle:@"取消" handler:^{
                    [self gotoScanView];
                }];
                [alertView bk_addButtonWithTitle:@"确定" handler:^{
                    [[CWebService sharedInstance] scan_profit_code:codeInfo dlmc:[[CDataSource sharedInstance].loginModel dlmc] pddw:[[CDataSource sharedInstance].loginModel pddw] mc:@"人工" success:^(NSString *msg, NSInteger code) {
                        [MBProgressHUD showSuccess:msg];
                        [self gotoScanView];
                    } failure:^(CWebServiceError *error) {
                        [MBProgressHUD showError:error.errorMessage];
                    } animated:YES message:nil];
                }];
                [alertView show];
            } forControlEvents:UIControlEventTouchUpInside];
            [self.infoView showInfo:@"资产编号不存在" andCode:[NSString stringWithFormat:@"编码：%@", codeInfo] toView:self.view];
            break;
        }
        case 2000: case 2002: {
            if ([serverInfo indexOfCharacter:'#'] != -1) {
                UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:@"当前资产不在本次盘点范围内，不能盘点。"];
                [alertView bk_addButtonWithTitle:@"确定" handler:^{
                    [self gotoScanView];
                }];
                [alertView show];
                break;
            }
            serverInfo = [serverInfo stringByReplacingOccurrencesOfString:@"#" withString:@""];
            NSString *serverPddw = [serverInfo substringToCharacter:'@'];
            NSInteger chartIndex = [serverInfo indexOfCharacter:'@'] == -1 ? 0 : [serverInfo indexOfCharacter:'@'] + 1;
            NSString *info = [serverInfo substringFromIndex:chartIndex];
            if ([serverPddw isEqualToString:[[CDataSource sharedInstance].loginModel pddw]]) {
                [self.infoView.overageButton setTitle:@"点击盘盈" forState:UIControlStateNormal];
                [self.infoView.overageButton bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
                [self.infoView.overageButton bk_addEventHandler:^(id sender) {
                    [[CWebService sharedInstance] scan_profit_code:codeInfo dlmc:[[CDataSource sharedInstance].loginModel dlmc] pddw:[[CDataSource sharedInstance].loginModel pddw] mc:@"人工" success:^(NSString *msg, NSInteger code) {
                        [MBProgressHUD showSuccess:msg];
                        [self gotoScanView];
                    } failure:^(CWebServiceError *error) {
                        [MBProgressHUD showError:error.errorMessage];
                    } animated:YES message:nil];
                } forControlEvents:UIControlEventTouchUpInside];
            } else {
                if ([serverPddw isEqualToString:@""]) {
                    [self.infoView.overageButton setTitle:@"无此资产的实物账信息，点击盘盈" forState:UIControlStateNormal];
                } else {
                    [self.infoView.overageButton setTitle:@"该资产不是你单位的资产，点击盘盈" forState:UIControlStateNormal];
                }
                [self.infoView.overageButton bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
                [self.infoView.overageButton bk_addEventHandler:^(id sender) {
                    NSString *tip = nil;
                    if ([serverPddw isEqualToString:@""]) {
                        tip = @"无此资产的实物账信息，请确认是否为您单位的盘盈资产？";
                    } else {
                        tip = @"该资产的隶属单位，与您的隶属单位不一样，请确认是否标记为您单位的盘盈资产？";
                    }
                    if (serverCode == 2002) {
                        tip = msg;
                    }
                    UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:tip];
                    [alertView bk_addButtonWithTitle:@"取消" handler:^{
                        [self gotoScanView];
                    }];
                    [alertView bk_addButtonWithTitle:@"确定" handler:^{
                        [[CWebService sharedInstance] scan_confirm_code:codeInfo dlmc:[[CDataSource sharedInstance].loginModel dlmc] pddw:[[CDataSource sharedInstance].loginModel pddw] mc:@"人工" success:^(NSString *msg, NSInteger code) {
                            [MBProgressHUD showSuccess:msg];
                            [self gotoScanView];
                        } failure:^(CWebServiceError *error) {
                            [MBProgressHUD showError:error.errorMessage];
                        } animated:YES message:nil];
                    }];
                    [alertView show];
                } forControlEvents:UIControlEventTouchUpInside];
            }
            [self.infoView showInfo:info andCode:[NSString stringWithFormat:@"编码：%@", codeInfo] toView:self.view];
            
            break;
        }
        default:
            [self startScanning];
            break;
    }
}

- (void)gotoScanView {
    [self.infoView removeFromSuperview];
    
    [self startScanning];
}

@end
