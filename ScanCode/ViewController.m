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
    QRCodeViewController * qrCodeController;
    GenerateCodeViewController * gcodeV;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectWhichVC:) name:@"SelectVC" object:nil];
    firstIn = YES;
    self.view.backgroundColor = [UIColor colorWithRed:108.f/255 green:151.f/255 blue:185.f/255 alpha:1.f];
    UILabel * d = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.center.y-10, [[UIScreen mainScreen] bounds].size.width, 20)];
    d.backgroundColor = [UIColor clearColor];
    d.textAlignment = NSTextAlignmentCenter;
    d.textColor = [UIColor whiteColor];
    [self.view addSubview:d];
    d.text = @"Waiting...";
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)selectWhichVC:(NSNotification *)noti
{
    firstIn = NO;
    NSLog(@"%@",noti.object);
    int index = [noti.object intValue];
    if (index==1) {
        [self toScanV];
    }
    else if (index==2){
        [self toSelectPhoto];
    }
    else if (index==3){
        [self toGenerateVC];
    }
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
    if (gcodeV) {
        [gcodeV dismissViewControllerAnimated:NO completion:^{
            gcodeV = nil;
            [self toScanV];
        }];
        return;
    }
    if (!qrCodeController) {
        __block ViewController * weakSelf = self;
        qrCodeController = [[QRCodeViewController alloc] init];
        qrCodeController.delegate = self;
        qrCodeController.didDismissed = ^(){
            qrCodeController = nil;
            [weakSelf toGenerateVC];
        };
        qrCodeController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:qrCodeController animated:YES completion:^{
            [qrCodeController disPhotoVC];
        }];
    }
    else
    {
        [qrCodeController disPhotoVC];
    }

}
-(void)toGenerateVC
{
    if (qrCodeController) {
        if (qrCodeController.inPhoto) {
            qrCodeController.inPhoto = NO;
            [qrCodeController.imagePickerVc dismissViewControllerAnimated:NO completion:^{
                [qrCodeController dismissViewControllerAnimated:NO completion:^{
                    qrCodeController = nil;
                    [self toGenerateVC];
                }];
            }];
            return;
        }
        else
        {

            [qrCodeController dismissViewControllerAnimated:NO completion:^{
                qrCodeController = nil;
                [self toGenerateVC];
            }];
            return;
     
        }
        
    }
    if (!gcodeV) {
        __block ViewController * weakSelf = self;
        gcodeV = [[GenerateCodeViewController alloc] init];
        //    qrCodeController.delegate = self;
        gcodeV.didDismissed = ^(){
            gcodeV = nil;
            [weakSelf toScanV];
        };
        gcodeV.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:gcodeV animated:YES completion:nil];
    }

}
-(void)toSelectPhoto
{
    if (gcodeV) {
        [gcodeV dismissViewControllerAnimated:NO completion:^{
            gcodeV = nil;
            
        }];
    }
    if (!qrCodeController) {
        __block ViewController * weakSelf = self;
        qrCodeController = [[QRCodeViewController alloc] init];
        qrCodeController.delegate = self;
        qrCodeController.didDismissed = ^(){
            qrCodeController = nil;
            [weakSelf toGenerateVC];
        };
        qrCodeController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:qrCodeController animated:YES completion:^{
            [qrCodeController selectFromLib];
        }];
    }
    else
        [qrCodeController selectFromLib];
}

- (void)scanQRCodeResultForSalesAgentNo:(NSString *)salesAgentNo licenceSerial:(NSString *)licenceSerial
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
