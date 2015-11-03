//
//  QRCodeViewController.m
//  ShopManager-iOS
//
//  Created by liwei on 15/4/16.
//  Copyright (c) 2015年 liwei. All rights reserved.
//

#import "QRCodeViewController.h"

#import "QRView.h"

#import "QRCodeDao.h"
#import "WebContentViewController.h"
#import "TextContentViewController.h"
@interface QRCodeViewController ()

{
    QRView *qrRectView;
    CGRect cropRect;
    UILabel * labIntroudction;
    UILabel * bottomL;
}

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
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
    labIntroudction.text=@"请将二维码图像置于矩形方框内";
    [self.view addSubview:labIntroudction];
    
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

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
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
    
    
    [_session stopRunning];
    NSLog(@"stringValue = %@", stringValue);
    
    if ([stringValue hasPrefix:@"http"]) {
        WebContentViewController * web = [[WebContentViewController alloc] init];
        web.urlStr = stringValue;
        web.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:web animated:YES completion:^{
            
        }];
    }
    else
    {
        TextContentViewController * tb = [[TextContentViewController alloc] init];
        tb.str = stringValue;
        tb.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:tb animated:YES completion:^{
            
        }];
    }
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
