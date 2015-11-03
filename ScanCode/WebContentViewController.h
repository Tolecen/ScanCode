//
//  WebContentViewController.h
//  NightKiss
//
//  Created by Tolecen on 15/7/26.
//  Copyright © 2015年 Tolecen. All rights reserved.
//

#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
@interface WebContentViewController : UIViewController<UIWebViewDelegate,NJKWebViewProgressDelegate,UIScrollViewDelegate>
{
    UIWebView * webview;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    
    float lastOffsetY;
}
@property (nonatomic,strong)UIButton * backBtn;
@property (retain,nonatomic)NSString * urlStr;
@end
