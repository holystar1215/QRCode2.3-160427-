//
//  CCodeScanViewController.m
//  QRCode
//
//  Created by CarlLiu on 16/2/24.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CCodeScanViewController.h"
#import <UIBarButtonItem+BlocksKit.h>

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
        NSLog(@"Completion with result: %@", resultAsString);
        wSelf.codeInfo = resultAsString;
        [wSelf stopScanning];
        wSelf.infoView.codeLabel.text = [NSString stringWithFormat:@"编码：%@", resultAsString];
        [wSelf.view.layer addSublayer:wSelf.infoView.layer];
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
}

@end
