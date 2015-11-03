//
//  WebContentViewController.m
//  NightKiss
//
//  Created by Tolecen on 15/7/26.
//  Copyright © 2015年 Tolecen. All rights reserved.
//

#import "WebContentViewController.h"

@implementation WebContentViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
    webview = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 20.0f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-20)];
    //    agreeWebView.delegate = self;
    webview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:webview];
    webview.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    webview.scrollView.delegate = self;
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    webview.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
//    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    
    [self.view addSubview:_progressView];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn setFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height-20-10-42, 42, 42)];
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"bottom_btn_back"] forState:UIControlStateNormal];
    [self.view addSubview:self.backBtn];
    self.backBtn.tag = 1;
    self.backBtn.alpha=0.8;
    [self.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [webview loadRequest:request];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }
}
#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if (!self.title) {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
-(void)scrollViewWillBeginDragging:(nonnull UIScrollView *)scrollView
{
    lastOffsetY = scrollView.contentOffset.y;
}
-(void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y>lastOffsetY&&self.backBtn.tag==1) {
        
        self.backBtn.tag = 2;
        self.backBtn.hidden = NO;
        self.backBtn.alpha = 1;
        
        [UIView animateWithDuration:0.5 animations:^{

            self.backBtn.alpha = 0;
        } completion:^(BOOL finished) {
            self.backBtn.hidden = YES;
        }];
        
    }
    else if(scrollView.contentOffset.y<lastOffsetY&&self.backBtn.tag==2){

        
        self.backBtn.tag = 1;
        self.backBtn.hidden = NO;
        self.backBtn.alpha = 0;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.backBtn.alpha = 0.8;
        } completion:^(BOOL finished) {
            self.backBtn.hidden = NO;
        }];
    }

}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    self.backBtn.tag = 1;
    self.backBtn.hidden = NO;
    self.backBtn.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.backBtn.alpha = 0.8;
    } completion:^(BOOL finished) {
        self.backBtn.hidden = NO;
    }];
}
-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
