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
    
    UILabel * al = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, screenWidth, 20)];
    [al setBackgroundColor:[UIColor whiteColor]];
    al.textAlignment = NSTextAlignmentCenter;
    al.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    al.font = [UIFont systemFontOfSize:12];
    al.text = @"Long press text area, copy the result.";
    [self.view addSubview:al];
    
    UILabel * tl = [[UILabel alloc] initWithFrame:CGRectMake(0, screenHeight/2-100, screenWidth, 20)];
    [tl setBackgroundColor:[UIColor whiteColor]];
    tl.textAlignment = NSTextAlignmentCenter;
    tl.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    tl.font = [UIFont systemFontOfSize:20];
    tl.text = @"Result";
    [self.view addSubview:tl];
    
    cv = [[UIView alloc] initWithFrame:CGRectMake((screenWidth-120)/2, screenHeight/2-160, 120, 30)];
    cv.backgroundColor = [UIColor blackColor];
    cv.alpha = 0.8;
    cv.layer.cornerRadius = 8;
    cv.layer.masksToBounds = YES;
    [self.view addSubview:cv];
    
    UILabel * pl = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 120, 20)];
    [pl setBackgroundColor:[UIColor clearColor]];
    pl.textAlignment = NSTextAlignmentCenter;
    pl.textColor = [UIColor whiteColor];
    pl.font = [UIFont systemFontOfSize:15];
    pl.text = @"Copy success";
    [cv addSubview:pl];
    
    cv.hidden = YES;
    
    UILabel * xl = [[UILabel alloc] initWithFrame:CGRectMake(20, screenHeight/2-40, screenWidth-40, 20)];
    [xl setBackgroundColor:[UIColor whiteColor]];
    xl.textAlignment = NSTextAlignmentCenter;
    xl.lineBreakMode = NSLineBreakByCharWrapping;
    xl.numberOfLines = 0;
    xl.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    xl.font = [UIFont systemFontOfSize:16];
    xl.text = self.str;
    [self.view addSubview:xl];
    xl.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer * d = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressLabel:)];
    [xl addGestureRecognizer:d];
    
    CGRect z = [self.str boundingRectWithSize:CGSizeMake(screenWidth-40, 800.f)
                                  options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}
                                      context:nil];
    [xl setFrame:CGRectMake((screenWidth-z.size.width)/2, screenHeight/2-40, z.size.width, z.size.height)];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn setFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height-20-10-42, 42, 42)];
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"bottom_btn_back"] forState:UIControlStateNormal];
    [self.view addSubview:self.backBtn];
    self.backBtn.tag = 1;
    self.backBtn.alpha=0.8;
    [self.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];

}
-(void)showCV
{
    cv.alpha = 0;
    cv.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        cv.alpha = 1;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(hideCV) withObject:nil afterDelay:1.5];
    }];
}
-(void)hideCV
{
    [UIView animateWithDuration:0.5 animations:^{
        cv.alpha = 0;
    } completion:^(BOOL finished) {
        cv.hidden = YES;
    }];
}

-(void)longPressLabel:(UIGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.str;
        [self showCV];
    }
    
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
