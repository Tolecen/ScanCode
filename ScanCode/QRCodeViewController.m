//
//  QRCodeViewController.m
//  ShopManager-iOS
//
//  Created by liwei on 15/4/16.
//  Copyright (c) 2015年 liwei. All rights reserved.
//

#import "QRCodeViewController.h"
#import "ProgressHUD.h"
#import "QRView.h"
#import "ZBarSDK.h"
#import "QRCodeDao.h"
#import "WebContentViewController.h"
#import "TextContentViewController.h"
#import "ZBarReaderController.h"
#import "TZImagePickerController.h"
@interface QRCodeViewController ()<TZImagePickerControllerDelegate>

{
    QRView *qrRectView;
    CGRect cropRect;
    UILabel * labIntroudction;
    UILabel * bottomL;
    UIButton * lbBtn;
    
    BOOL canScan;
}

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    canScan = YES;
//    [self setupCamera];
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    qrRectView = [[QRView alloc] initWithFrame:screenRect];
    qrRectView.transparentArea = CGSizeMake(220, 220);
    qrRectView.backgroundColor = [UIColor clearColor];
    qrRectView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    
    
    //修正扫描区域
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat screenWidth = self.view.frame.size.width;
    cropRect = CGRectMake((screenWidth - qrRectView.transparentArea.width) / 2,
                                 (screenHeight - qrRectView.transparentArea.height) / 2,
                                 qrRectView.transparentArea.width,
                                 qrRectView.transparentArea.height);
    
    
    
    //--
//    UIButton *pop = [UIButton buttonWithType:UIButtonTypeCustom];
//    pop.frame = CGRectMake(20, 20, 50, 50);
//    [pop setTitle:@"返回" forState:UIControlStateNormal];
//    [pop addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:pop];
    
    
    labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(20, (screenHeight-220)/2-60, screenWidth-40, 50)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines=2;
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"Put the QR code in the square";
    [self.view addSubview:labIntroudction];
    
    lbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lbBtn setFrame:CGRectMake((self.view.frame.size.width-140)/2, screenHeight/2+110+20, 140, 35)];
    lbBtn.backgroundColor = [UIColor clearColor];
    lbBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [lbBtn setTitle:@"Select Photo" forState:UIControlStateNormal];
    lbBtn.layer.cornerRadius = 5;
    lbBtn.layer.borderWidth = 1;
    lbBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    lbBtn.layer.masksToBounds = YES;
    [self.view addSubview:lbBtn];
    [lbBtn addTarget:self action:@selector(selectFromLib) forControlEvents:UIControlEventTouchUpInside];
    
    bottomL= [[UILabel alloc] initWithFrame:CGRectMake(20, screenHeight-50, screenWidth-40, 20)];
    bottomL.backgroundColor = [UIColor clearColor];
    bottomL.font = [UIFont systemFontOfSize:12];
    bottomL.textAlignment = NSTextAlignmentCenter;
    bottomL.textColor=[UIColor whiteColor];
    bottomL.text=@"Made by Tolecen";
    [self.view addSubview:bottomL];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [_session stopRunning];
    [qrRectView removeFromSuperview];
    [_preview removeFromSuperlayer];
    _output = nil;
    _input = nil;
    _session = nil;
    _preview = nil;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self setupCamera];
    [self.view addSubview:qrRectView];
    [self.view bringSubviewToFront:labIntroudction];
    [self.view bringSubviewToFront:bottomL];
    [self.view bringSubviewToFront:lbBtn];
    
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat screenWidth = self.view.frame.size.width;
    [_output setRectOfInterest:CGRectMake(cropRect.origin.y / screenHeight,
                                          cropRect.origin.x / screenWidth,
                                          cropRect.size.height / screenHeight,
                                          cropRect.size.width / screenWidth)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupCamera
{
    // Device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:self.input])
    {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output])
    {
        [self.session addOutput:self.output];
    }
    
    // 条码类型
    if ([self.output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
        self.output.metadataObjectTypes = [NSArray arrayWithObject:AVMetadataObjectTypeQRCode];
    }
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity =AVLayerVideoGravityResize;
    _preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    // Start
    [self.session startRunning];


}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    
    
    NSLog(@"stringValue = %@", stringValue);
    
    if ([stringValue hasPrefix:@"http"]) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
            NSLog(@"111");
            SFSafariViewController * sv = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:stringValue]];
            sv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            [self presentViewController:sv animated:YES completion:^{
                
            }];
        }
        else{
            NSLog(@"222");
            WebContentViewController * web = [[WebContentViewController alloc] init];
            web.urlStr = stringValue;
            web.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:web animated:YES completion:^{
                
            }];
        }
    }
    else
    {
        NSLog(@"333");
        TextContentViewController * tb = [[TextContentViewController alloc] init];
        tb.str = stringValue;
        tb.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:tb animated:YES completion:^{
            
        }];
    }
}

-(void)selectFromLib
{
//    ZBarReaderController * zv = [[ZBarReaderController alloc] init];
////    zv.view.backgroundColor = [UIColor blackColor];
//    zv.navigationBar.barTintColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8];
//    zv.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    [self presentViewController:zv animated:YES completion:^{
//        
//    }];
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
#pragma mark TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
     NSLog(@"cancel");
}

/// User finish picking photo，if assets are not empty, user picking original photo.
/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    [ProgressHUD show:@"Scaning..."];
    [picker dismissViewControllerAnimated:YES completion:^{
        if (photos.count>0) {
            NSString * stringValue;
            UIImage * img = [photos firstObject];
            ZBarImageScanner * sc = [[ZBarImageScanner alloc] init];
            if ([sc scanImage:[[ZBarImage alloc] initWithCGImage:img.CGImage]]) {
                ZBarSymbol * symbol;
                for(symbol in sc.results)
                    break;
                stringValue = symbol.data;
                NSLog(@"result:%@",symbol.data);
                [self showResultWithStr:stringValue];
                
            }
            else
            {
                [self showResultWithStr:nil];
            }
        }
        
    }];
    
}

-(void)showResultWithStr:(NSString *)stringValue
{
    if (!stringValue) {
        [ProgressHUD showError:@"No Results"];
        return;
    }
    [ProgressHUD dismiss];
    if ([stringValue hasPrefix:@"http"]) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
            NSLog(@"111");
            SFSafariViewController * sv = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:stringValue]];
            sv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            [self presentViewController:sv animated:YES completion:^{
                
            }];
        }
        else{
            NSLog(@"222");
            WebContentViewController * web = [[WebContentViewController alloc] init];
            web.urlStr = stringValue;
            web.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:web animated:YES completion:^{
                
            }];
        }
    }
    else
    {
        NSLog(@"333");
        TextContentViewController * tb = [[TextContentViewController alloc] init];
        tb.str = stringValue;
        tb.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:tb animated:YES completion:^{
            
        }];
    }

}

/// User finish picking video,
/// 用户选择好了视频
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
