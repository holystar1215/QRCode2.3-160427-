//
//  CCodeScanViewController.h
//  QRCode
//
//  Created by CarlLiu on 16/2/24.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import <QRCodeReader.h>

@interface CCodeScanViewController : UIViewController
#pragma mark - Creating and Inializing QRCodeReader Controllers
/**
 * @abstract Initializes a view controller using a cancel button title and
 * a code reader.
 * @param cancelTitle The title of the cancel button.
 * @param codeReader The reader to decode the codes.
 * @param startScanningAtLoad Flag to know whether the view controller start
 * scanning the codes when the view will appear.
 * @param showSwitchCameraButton Flag to display the switch camera button.
 * @param showTorchButton Flag to know whether the view controller start
 * scanning the codes when the view will appear.
 * @since 4.0.0
 */
- (nonnull id)initWithCancelButtonTitle:(nullable NSString *)cancelTitle codeReader:(nonnull QRCodeReader *)codeReader startScanningAtLoad:(BOOL)startScanningAtLoad showSwitchCameraButton:(BOOL)showSwitchCameraButton showTorchButton:(BOOL)showTorchButton;

/**
 * @abstract Initializes a view controller using a cancel button title and
 * a code reader.
 * @param cancelTitle The title of the cancel button.
 * @param codeReader The reader to decode the codes.
 * @param startScanningAtLoad Flag to know whether the view controller start
 * scanning the codes when the view will appear.
 * @param showSwitchCameraButton Flag to display the switch camera button.
 * @param showTorchButton Flag to know whether the view controller start
 * scanning the codes when the view will appear.
 * @see initWithCancelButtonTitle:codeReader:startScanningAtLoad:showSwitchCameraButton:showTorchButton:
 * @since 4.0.0
 */
+ (nonnull instancetype)readerWithCancelButtonTitle:(nullable NSString *)cancelTitle codeReader:(nonnull QRCodeReader *)codeReader startScanningAtLoad:(BOOL)startScanningAtLoad showSwitchCameraButton:(BOOL)showSwitchCameraButton showTorchButton:(BOOL)showTorchButton;

#pragma mark - Controlling the Reader
/** @name Controlling the Reader */

/**
 * @abstract Starts scanning the codes.
 * @since 3.0.0
 */
- (void)startScanning;

/**
 * @abstract Stops scanning the codes.
 * @since 3.0.0
 */
- (void)stopScanning;

#pragma mark - Managing the Delegate
/**
 * @abstract Sets the completion with a block that executes when a QRCode
 * or when the user did stopped the scan.
 * @param completionBlock The block to be executed. This block has no
 * return value and takes one argument: the `resultAsString`. If the user
 * stop the scan and that there is no response the `resultAsString` argument
 * is nil.
 * @since 1.0.1
 */
- (void)setCompletionWithBlock:(nullable void (^) (NSString * __nullable resultAsString))completionBlock;

#pragma mark - Managing the Reader
/** @name Managing the Reader */

/**
 * @abstract The default code reader created with the controller.
 * @since 3.0.0
 */
@property (strong, nonatomic, readonly) QRCodeReader * __nonnull codeReader;

@end
