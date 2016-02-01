//
//  QRCodeViewController.h
//  ShopManager-iOS
//
//  Created by liwei on 15/4/16.
//  Copyright (c) 2015年 liwei. All rights reserved.
//
//  二维码扫描 门店和在线验证共用
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <SafariServices/SafariServices.h>
#import "TZImagePickerController.h"
@protocol QRCodeViewControllerDelegate <NSObject>

- (void)scanQRCodeResultForSalesAgentNo:(NSString *)salesAgentNo licenceSerial:(NSString *)licenceSerial;

@end

@interface QRCodeViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, assign) NSInteger qrTag;
//@property (nonatomic, assign) BOOL isHome; //在线验证 YES， 其它 NO

@property (nonatomic, weak) id<QRCodeViewControllerDelegate> delegate;
@property (nonatomic, strong) void (^didDismissed)();
@property (strong, nonatomic) AVCaptureDevice *device;
@property (strong, nonatomic) AVCaptureDeviceInput *input;
@property (strong, nonatomic) AVCaptureMetadataOutput *output;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;
@property (assign, nonatomic) BOOL inPhoto;
@property (strong, nonatomic) TZImagePickerController *imagePickerVc;

-(void)selectFromLib;
-(void)disPhotoVC;

@end
