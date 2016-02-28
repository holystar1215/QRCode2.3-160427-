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

@interface CCodeScanViewController () <CCodeInfoViewDelegate>
@property (strong, nonatomic) QRCameraSwitchButton *switchCameraButton;
@property (strong, nonatomic) QRToggleTorchButton *toggleTorchButton;
@property (strong, nonatomic) CScanView     *cameraView;
@property (strong, nonatomic) UIButton             *cancelButton;
@property (strong, nonatomic) QRCodeReader         *codeReader;
@property (assign, nonatomic) BOOL                 startScanningAtLoad;
@property (assign, nonatomic) BOOL                 showSwitchCameraButton;
@property (assign, nonatomic) BOOL                 showTorchButton;

@property (strong, nonatomic) CCodeInfoView *infoView;
@property (strong, nonatomic) NSString *codeInfo;

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
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    weakSelf(wSelf);
    [self setCompletionWithBlock:^(NSString *resultAsString) {
        MAINTHREAD_RUN_BLOCK((^{
            wSelf.codeInfo = resultAsString;
            [wSelf stopScanning];
            wSelf.infoView.codeLabel.text = [NSString stringWithFormat:@"编码：%@", wSelf.codeInfo];
            [wSelf.view.layer addSublayer:wSelf.infoView.layer];
        }));
        NSLog(@"Completion with result: %@", resultAsString);
        
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

+ (instancetype)readerWithCancelButtonTitle:(NSString *)cancelTitle codeReader:(QRCodeReader *)codeReader startScanningAtLoad:(BOOL)startScanningAtLoad showSwitchCameraButton:(BOOL)showSwitchCameraButton showTorchButton:(BOOL)showTorchButton
{
    return [[self alloc] initWithCancelButtonTitle:cancelTitle codeReader:codeReader startScanningAtLoad:startScanningAtLoad showSwitchCameraButton:showSwitchCameraButton showTorchButton:showTorchButton];
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

- (BOOL)shouldAutorotate
{
    return YES;
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
- (void)didCheckedButton:(UIButton *)sender {
    [self.infoView.layer removeFromSuperlayer];
    
    [[CWebService sharedInstance] manual_code:self.codeInfo pddw:[[CDataSource sharedInstance].loginModel pddw] success:^(NSString *obj, NSInteger code) {
        
        switch (code) {
            case 1002: {
                [MBProgressHUD showError:@"服务器异常"];
                break;
            }
            case 1006: {
                [MBProgressHUD showError:@"资产编号不存在"];
                UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:@"该资产不在本次清查的记录中,请确认是否标记为盘盈资产"];
                [alertView bk_addButtonWithTitle:@"取消" handler:^{
                    
                }];
                [alertView bk_addButtonWithTitle:@"确定" handler:^{
                    [[CWebService sharedInstance] manual_profit_code:self.codeInfo dlmc:[[CDataSource sharedInstance].loginModel dlmc] pddw:[[CDataSource sharedInstance].loginModel pddw] mc:@"人工" success:^(NSString *msg, NSInteger code) {
                        //TODO:
                    } failure:^(CWebServiceError *error) {
                        [MBProgressHUD showError:error.errorMessage];
                    } animated:YES message:@""];
                }];
                [alertView show];
                break;
            }
            case 2000: {
                if ([[obj substringToCharacter:'@'] isEqualToString:[[CDataSource sharedInstance].loginModel pddw]]) {
                    UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:@"是否盘盈?"];
                    [alertView bk_addButtonWithTitle:@"取消" handler:^{
                        
                    }];
                    [alertView bk_addButtonWithTitle:@"确定" handler:^{
                        
                        
                        [[CWebService sharedInstance] manual_confirm_code:self.codeInfo dlmc:[[CDataSource sharedInstance].loginModel dlmc] pddw:[[CDataSource sharedInstance].loginModel pddw] mc:@"人工" success:^(NSString *msg, NSInteger code) {
                            
                        } failure:^(CWebServiceError *error) {
                            
                        } animated:YES message:@""];
                    }];
                    [alertView show];
                } else {
                    UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:@"该资产的隶属单位,与您的隶属单位不一样,请确认是否标记为您单位的盘盈资产?"];
                    [alertView bk_addButtonWithTitle:@"取消" handler:^{
                        
                    }];
                    [alertView bk_addButtonWithTitle:@"确定" handler:^{
                        
                    }];[alertView bk_addButtonWithTitle:@"确定" handler:^{
                        [[CWebService sharedInstance] manual_profit_code:self.codeInfo dlmc:[[CDataSource sharedInstance].loginModel dlmc] pddw:[[CDataSource sharedInstance].loginModel pddw] mc:@"人工" success:^(NSString *msg, NSInteger code) {
                            //TODO:
                        } failure:^(CWebServiceError *error) {
                            [MBProgressHUD showError:error.errorMessage];
                        } animated:YES message:@""];
                    }];
                    [alertView show];
                }
                break;
            }
            case 2002: {
                self.infoView.infoLabel.text = obj;
                UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:@"对不起,您的优先级小于1,不能二次盘点"];
                [alertView bk_addButtonWithTitle:@"确定" handler:^{
                    
                }];
                [alertView show];
                break;
            }
            case 2003: {//对不起,您的优先级小于1,不能二次盘点.
                self.infoView.infoLabel.text = @"页面上显示 资产不存在";
                UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:@"对不起,您的优先级小于1,不能二次盘点"];
                [alertView bk_addButtonWithTitle:@"确定" handler:^{
                    
                }];
                [alertView show];
                break;
            }
            default:
                break;
        }
    } failure:^(CWebServiceError *error) {
        [MBProgressHUD showError:error.errorMessage];
        
    } animated:YES message:@""];
}

@end
