//
//  ViewController.m
//  ScanCode
//
//  Created by TaoXinle on 15/11/2.
//  Copyright © 2015年 TaoXinle. All rights reserved.
//

#import "ViewController.h"
#import "QRCodeViewController.h"
#import "GenerateCodeViewController.h"
@interface ViewController ()<QRCodeViewControllerDelegate>
{
    BOOL firstIn;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    firstIn = YES;
    self.view.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    UILabel * d = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.center.y-10, [[UIScreen mainScreen] bounds].size.width, 20)];
    d.backgroundColor = [UIColor clearColor];
    d.textAlignment = NSTextAlignmentCenter;
    d.textColor = [UIColor whiteColor];
    [self.view addSubview:d];
    d.text = @"Waiting...";
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    if (firstIn) {
        [self toScanV];
        firstIn = NO;
    }
    
    
    
}
-(void)toScanV
{
    QRCodeViewController * qrCodeController = [[QRCodeViewController alloc] init];
    qrCodeController.delegate = self;
    qrCodeController.didDismissed = ^(){
        [self toGenerateVC];
    };
    qrCodeController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:qrCodeController animated:YES completion:nil];
}
-(void)toGenerateVC
{
    GenerateCodeViewController * qrCodeController = [[GenerateCodeViewController alloc] init];
//    qrCodeController.delegate = self;
    qrCodeController.didDismissed = ^(){
        [self toScanV];
    };
    qrCodeController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:qrCodeController animated:YES completion:nil];
}

- (void)scanQRCodeResultForSalesAgentNo:(NSString *)salesAgentNo licenceSerial:(NSString *)licenceSerial
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
