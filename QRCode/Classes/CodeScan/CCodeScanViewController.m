//
//  CCodeScanViewController.m
//  QRCode
//
//  Created by CarlLiu on 16/2/24.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CCodeScanViewController.h"
#import <UIBarButtonItem+BlocksKit.h>
#import <UIAlertView+BlocksKit.h>
#import "MBProgressHUD+UIView.h"
#import "DSNavigationBar.h"

#import <QRCameraSwitchButton.h>
#import "CScanView.h"
#import "CCodeInfoView.h"
#import <QRToggleTorchButton.h>

typedef NS_ENUM(NSInteger, ScanType) {
    eQRCode,
    eBarCode
};

@interface CCodeScanViewController () <CCodeInfoViewDelegate>
@property (strong, nonatomic) QRCameraSwitchButton *switchCameraButton;
@property (strong, nonatomic) QRToggleTorchButton  *toggleTorchButton;
@property (strong, nonatomic) CScanView            *cameraView;
@property (strong, nonatomic) UIButton             *cancelButton;
@property (strong, nonatomic) QRCodeReader         *codeReader;
@property (assign, nonatomic) BOOL                 startScanningAtLoad;
@property (assign, nonatomic) BOOL                 showSwitchCameraButton;
@property (assign, nonatomic) BOOL                 showTorchButton;

@property (strong, nonatomic) CCodeInfoView *infoView;
@property (strong, nonatomic) NSString *codeInfo;
@property (assign, nonatomic) NSInteger serverCode;
@property (strong, nonatomic) NSString *serverPddw;

@property (assign, nonatomic) ScanType scanType;

@property (copy, nonatomic) void (^completionBlock) (NSString * __nullable);

@end

@implementation CCodeScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.infoView = [[CCodeInfoView alloc] initWithFrame:self.view.bounds];
    self.infoView.delegate = self;
    self.infoView.layer.frame = self.view.layer.frame;
    
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
                wSelf.codeInfo = tmp;
                
                wSelf.infoView.codeLabel.text = [NSString stringWithFormat:@"编码：%@", wSelf.codeInfo];
                NSLog(@"Completion with result: %@", resultAsString);
                [wSelf stopScanning];
                [[CWebService sharedInstance] scan_code:wSelf.codeInfo pddw:[[CDataSource sharedInstance].loginModel pddw] success:^(NSString *obj, NSInteger code) {
                    
                    NSInteger chartIndex = [obj indexOfCharacter:'@'] == -1 ? 0 : [obj indexOfCharacter:'@'] + 1;
                    wSelf.infoView.infoLabel.text = [obj substringFromIndex:chartIndex];
                    CGSize infoSize = [CPublicModule text:wSelf.infoView.infoLabel.text font:wSelf.infoView.infoLabel.font size:wSelf.infoView.infoLabel.bounds.size];
                    wSelf.infoView.infoHeight.constant = infoSize.height;
                    wSelf.serverCode = code;
                    wSelf.serverPddw = [obj substringToCharacter:'@'];
                    [wSelf.view addSubview:wSelf.infoView];
                    [wSelf.infoView autoCenterInSuperview];
                    [wSelf.infoView autoSetDimensionsToSize:wSelf.view.bounds.size];
                } failure:^(CWebServiceError *error) {
                    [MBProgressHUD showError:error.errorMessage];
                    [wSelf startScanning];
                } animated:NO message:@""];
                break;
            }
            case eBarCode: {
                wSelf.codeInfo = [resultAsString stringByReplacingOccurrencesOfString:@"*" withString:@""];
                
                wSelf.infoView.codeLabel.text = [NSString stringWithFormat:@"编码：%@", wSelf.codeInfo];
                NSLog(@"Completion with result: %@", resultAsString);
                [wSelf stopScanning];
                [[CWebService sharedInstance] scan_code:wSelf.codeInfo pddw:[[CDataSource sharedInstance].loginModel pddw] success:^(NSString *obj, NSInteger code) {
                    
                    NSInteger chartIndex = [obj indexOfCharacter:'@'] == -1 ? 0 : [obj indexOfCharacter:'@'] + 1;
                    wSelf.infoView.infoLabel.text = [obj substringFromIndex:chartIndex];
                    CGSize infoSize = [CPublicModule text:wSelf.infoView.infoLabel.text font:wSelf.infoView.infoLabel.font size:wSelf.infoView.infoLabel.bounds.size];
                    wSelf.infoView.infoHeight.constant = infoSize.height;
                    wSelf.serverCode = code;
                    wSelf.serverPddw = [obj substringToCharacter:'@'];
                    [wSelf.view addSubview:wSelf.infoView];
                    [wSelf.infoView autoCenterInSuperview];
                    [wSelf.infoView autoSetDimensionsToSize:wSelf.view.bounds.size];
                } failure:^(CWebServiceError *error) {
                    [MBProgressHUD showError:error.errorMessage];
                    [wSelf startScanning];
                } animated:NO message:@""];
                break;
            }
            default:
                break;
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self stopScanning];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithCancelButtonTitle:(nullable NSString *)cancelTitle codeReader:(nonnull QRCodeReader *)codeReader startScanningAtLoad:(BOOL)startScanningAtLoad showSwitchCameraButton:(BOOL)showSwitchCameraButton showTorchButton:(BOOL)showTorchButton
{
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

+ (instancetype)qrCodeReader:(QRCodeReader *)codeReader startScanningAtLoad:(BOOL)startScanningAtLoad
{
    CCodeScanViewController *vc = [[self alloc] initWithCancelButtonTitle:nil codeReader:codeReader startScanningAtLoad:startScanningAtLoad showSwitchCameraButton:NO showTorchButton:NO];
    vc.scanType = eQRCode;
    return vc;
}

+ (instancetype)barCodeReader:(QRCodeReader *)codeReader startScanningAtLoad:(BOOL)startScanningAtLoad
{
    CCodeScanViewController *vc = [[self alloc] initWithCancelButtonTitle:nil codeReader:codeReader startScanningAtLoad:startScanningAtLoad showSwitchCameraButton:NO showTorchButton:NO];
    vc.scanType = eBarCode;
    return vc;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_startScanningAtLoad) {
        [self startScanning];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopScanning];
    
    [super viewWillDisappear:animated];
    
    DSNavigationBar *bar = (DSNavigationBar *)self.navigationController.navigationBar;
    [bar setNavigationBarWithColor:RGBA(255, 255, 255, 0.8)];
    [bar setTintColor:[UIColor blueColor]];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _codeReader.previewLayer.frame = self.view.bounds;
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

- (void)setCompletionWithBlock:(void (^) (NSString *resultAsString))completionBlock
{
    self.completionBlock = completionBlock;
}

#pragma mark - Initializing the AV Components

- (void)setupUIComponentsWithCancelButtonTitle:(NSString *)cancelButtonTitle
{
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

- (void)setupAutoLayoutConstraints
{
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

- (void)switchDeviceInput
{
    [_codeReader switchDeviceInput];
}

#pragma mark - Catching Button Events
- (void)cancelAction:(UIButton *)button
{
    [_codeReader stopScanning];
    
    if (_completionBlock) {
        _completionBlock(nil);
    }
}

- (void)switchCameraAction:(UIButton *)button
{
    [self switchDeviceInput];
}

- (void)toggleTorchAction:(UIButton *)button
{
    [_codeReader toggleTorch];
}

#pragma mark - <CCodeInfoViewDelegate>
- (void)didClickedButtonAtIndex:(NSInteger)btnIndex {
    switch (btnIndex) {
        case 0: {
            break;
        }
        case 1: {
            break;
        }
        default:
            break;
    }
    
    switch (self.serverCode) {
        case 1002: {
            [MBProgressHUD showError:@"服务器异常"];
            break;
        }
        case 1006: {
            UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:@"该资产不在本次清查的记录中,请确认是否标记为盘盈资产"];
            [alertView bk_addButtonWithTitle:@"取消" handler:^{
                
            }];
            [alertView bk_addButtonWithTitle:@"确定" handler:^{
                [[CWebService sharedInstance] scan_profit_code:self.codeInfo dlmc:[[CDataSource sharedInstance].loginModel dlmc] pddw:[[CDataSource sharedInstance].loginModel pddw] mc:@"人工" success:^(NSString *msg, NSInteger code) {
                    [MBProgressHUD showSuccess:msg];
                } failure:^(CWebServiceError *error) {
                    [MBProgressHUD showError:error.errorMessage];
                } animated:YES message:@""];
            }];
            [alertView show];
            break;
        }
        case 2000: {
            if ([self.serverPddw isEqualToString:[[CDataSource sharedInstance].loginModel pddw]]) {
                UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:@"是否盘盈?"];
                [alertView bk_addButtonWithTitle:@"取消" handler:^{
                    
                }];
                [alertView bk_addButtonWithTitle:@"确定" handler:^{
                    [[CWebService sharedInstance] scan_profit_code:self.codeInfo dlmc:[[CDataSource sharedInstance].loginModel dlmc] pddw:[[CDataSource sharedInstance].loginModel pddw] mc:@"人工" success:^(NSString *msg, NSInteger code) {
                        [MBProgressHUD showSuccess:msg];
                    } failure:^(CWebServiceError *error) {
                        [MBProgressHUD showError:error.errorMessage];
                    } animated:YES message:@""];
                }];
                [alertView show];
            } else {
                UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:@"该资产的隶属单位,与您的隶属单位不一样,请确认是否标记为您单位的盘盈资产?"];
                [alertView bk_addButtonWithTitle:@"取消" handler:^{
                    
                }];
                [alertView bk_addButtonWithTitle:@"确定" handler:^{
                    [[CWebService sharedInstance] scan_confirm_code:self.codeInfo dlmc:[[CDataSource sharedInstance].loginModel dlmc] pddw:[[CDataSource sharedInstance].loginModel pddw] mc:@"人工" success:^(NSString *msg, NSInteger code) {
                        [MBProgressHUD showSuccess:msg];
                    } failure:^(CWebServiceError *error) {
                        [MBProgressHUD showError:error.errorMessage];
                    } animated:YES message:@""];
                }];
                [alertView show];
            }
            break;
        }
        case 2002: {
            if ([self.serverPddw isEqualToString:[[CDataSource sharedInstance].loginModel pddw]]) {
                UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:@"该资产已盘点，请确认是否再次盘点"];
                [alertView bk_addButtonWithTitle:@"取消" handler:^{
                    
                }];
                [alertView bk_addButtonWithTitle:@"确定" handler:^{
                    [[CWebService sharedInstance] scan_profit_code:self.codeInfo dlmc:[[CDataSource sharedInstance].loginModel dlmc] pddw:[[CDataSource sharedInstance].loginModel pddw] mc:@"人工" success:^(NSString *msg, NSInteger code) {
                        [MBProgressHUD showSuccess:msg];
                    } failure:^(CWebServiceError *error) {
                        [MBProgressHUD showError:error.errorMessage];
                    } animated:YES message:@""];
                }];
                [alertView show];
            } else {
                UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:@"该资产的隶属单位,与您的隶属单位不一样,请确认是否标记为您单位的盘盈资产?"];
                [alertView bk_addButtonWithTitle:@"取消" handler:^{
                    
                }];
                [alertView bk_addButtonWithTitle:@"确定" handler:^{
                    [[CWebService sharedInstance] scan_confirm_code:self.codeInfo dlmc:[[CDataSource sharedInstance].loginModel dlmc] pddw:[[CDataSource sharedInstance].loginModel pddw] mc:@"人工" success:^(NSString *msg, NSInteger code) {
                        [MBProgressHUD showSuccess:msg];
                    } failure:^(CWebServiceError *error) {
                        [MBProgressHUD showError:error.errorMessage];
                    } animated:YES message:@""];
                }];
                [alertView show];
            }
            break;
        }
        default:
            break;
    }
}

@end
