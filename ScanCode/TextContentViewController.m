//
//  TextContentViewController.m
//  ScanCode
//
//  Created by TaoXinle on 15/11/3.
//  Copyright © 2015年 TaoXinle. All rights reserved.
//

#import "TextContentViewController.h"

@implementation TextContentViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat screenWidth = self.view.frame.size.width;
    
    UILabel * tl = [[UILabel alloc] initWithFrame:CGRectMake(0, screenHeight/2-100, screenWidth, 20)];
    [tl setBackgroundColor:[UIColor whiteColor]];
    tl.textAlignment = NSTextAlignmentCenter;
    tl.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    tl.font = [UIFont systemFontOfSize:20];
    tl.text = @"扫描结果";
    [self.view addSubview:tl];
    
    UILabel * xl = [[UILabel alloc] initWithFrame:CGRectMake(0, screenHeight/2-40, screenWidth, 20)];
    [xl setBackgroundColor:[UIColor whiteColor]];
    xl.textAlignment = NSTextAlignmentCenter;
    xl.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    xl.font = [UIFont systemFontOfSize:16];
    xl.text = self.str;
    [self.view addSubview:xl];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn setFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height-20-10-42, 42, 42)];
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"bottom_btn_back"] forState:UIControlStateNormal];
    [self.view addSubview:self.backBtn];
    self.backBtn.tag = 1;
    self.backBtn.alpha=0.8;
    [self.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }
}
-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
