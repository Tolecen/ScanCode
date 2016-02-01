//
//  GenerateCodeViewController.m
//  ScanCode
//
//  Created by TaoXinle on 16/2/1.
//  Copyright © 2016年 TaoXinle. All rights reserved.
//

#import "GenerateCodeViewController.h"
#import "QRCodeGenerator.h"
#import "ProgressHUD.h"
#import "UIActionSheet+block.h"
@interface GenerateCodeViewController ()
{
    UITextView * textV;
    UIImageView * imageV;
    UILabel * desL;
    
    UIButton * generateBtn;
    UIButton * saveBtn;
    
    CGFloat screenHeight;
    CGFloat screenWidth;
}
@end

@implementation GenerateCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:108.f/255 green:151.f/255 blue:185.f/255 alpha:1.f];
    screenHeight = self.view.frame.size.height;
    screenWidth = self.view.frame.size.width;
    
    UILabel * titleLabel= [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-140)/2, 30, 140, 35)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.text=@"Generate Code";
    [self.view addSubview:titleLabel];
    
    desL= [[UILabel alloc] initWithFrame:CGRectMake(0, 90, self.view.frame.size.width, 20)];
    desL.backgroundColor = [UIColor clearColor];
    desL.font = [UIFont systemFontOfSize:14];
    desL.textAlignment = NSTextAlignmentCenter;
    desL.textColor=[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:.6f];
    desL.text=@"Input the string or url below";
    [self.view addSubview:desL];
    
    UIButton * toGenerateVCBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [toGenerateVCBtn setFrame:CGRectMake(self.view.frame.size.width-80, 30, 70, 35)];
    toGenerateVCBtn.backgroundColor = [UIColor clearColor];
    toGenerateVCBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [toGenerateVCBtn setTitle:@"Scan >" forState:UIControlStateNormal];
//    toGenerateVCBtn.layer.cornerRadius = 5;
//    toGenerateVCBtn.layer.borderWidth = 1;
//    toGenerateVCBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    toGenerateVCBtn.layer.masksToBounds = YES;
    [self.view addSubview:toGenerateVCBtn];
    [toGenerateVCBtn addTarget:self action:@selector(toScanVC) forControlEvents:UIControlEventTouchUpInside];
    
    
    textV = [[UITextView alloc] initWithFrame:CGRectMake(30, 124,self.view.frame.size.width-60 , 200)];
    textV.backgroundColor = [UIColor colorWithRed:136/255.f green:178/255.f blue:211/255.f alpha:1];
    textV.scrollEnabled = YES;
    textV.font = [UIFont systemFontOfSize:16];
    textV.textColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    [self.view addSubview:textV];
    textV.layer.cornerRadius = 5;
    textV.layer.borderColor = [[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1] CGColor];
    textV.layer.borderWidth = 1;
    textV.layer.masksToBounds = YES;
    
    textV.inputAccessoryView =({
        UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
        toolbar.tintColor = [UIColor blackColor];
        UIBarButtonItem*rb = [[UIBarButtonItem alloc]initWithTitle:@"Generate" style:UIBarButtonItemStyleDone target:self action:@selector(generateCode)];
        UIBarButtonItem*cb = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelInput)];
        rb.tintColor = [UIColor blackColor];
        toolbar.items = @[cb,rb];
        toolbar;
    });
    
    imageV = [[UIImageView alloc] initWithFrame:CGRectMake(40, 124, screenWidth-80, screenWidth-80)];
    imageV.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [self.view addSubview:imageV];
    imageV.hidden = YES;
    
    imageV.userInteractionEnabled = YES;
    UILongPressGestureRecognizer * longP = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [imageV addGestureRecognizer:longP];
    
    generateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [generateBtn setFrame:CGRectMake((self.view.frame.size.width-140)/2, textV.frame.size.height+textV.frame.origin.y+35, 140, 35)];
    generateBtn.backgroundColor = [UIColor clearColor];
    generateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [generateBtn setTitle:@"Generate" forState:UIControlStateNormal];
    generateBtn.layer.cornerRadius = 5;
    generateBtn.layer.borderWidth = 1;
    generateBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    generateBtn.layer.masksToBounds = YES;
    [self.view addSubview:generateBtn];
    [generateBtn addTarget:self action:@selector(generateCode) forControlEvents:UIControlEventTouchUpInside];
    
    saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setFrame:CGRectMake((self.view.frame.size.width-140)/2, imageV.frame.size.height+imageV.frame.origin.y+35, 140, 35)];
    saveBtn.backgroundColor = [UIColor clearColor];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [saveBtn setTitle:@"Save Image" forState:UIControlStateNormal];
    saveBtn.layer.cornerRadius = 5;
    saveBtn.layer.borderWidth = 1;
    saveBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    saveBtn.layer.masksToBounds = YES;
    [self.view addSubview:saveBtn];
    [saveBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.hidden = YES;
    
    UILabel * bottomL= [[UILabel alloc] initWithFrame:CGRectMake(20, screenHeight-50, screenWidth-40, 20)];
    bottomL.backgroundColor = [UIColor clearColor];
    bottomL.font = [UIFont systemFontOfSize:12];
    bottomL.textAlignment = NSTextAlignmentCenter;
    bottomL.textColor=[UIColor whiteColor];
    bottomL.text=@"Made by Tolecen";
    [self.view addSubview:bottomL];
    // Do any additional setup after loading the view.
}
-(void)handleLongPress:(UILongPressGestureRecognizer *)press
{
    
    if (press.state == UIGestureRecognizerStateEnded) {
        
        return;
        
    } else if (press.state == UIGestureRecognizerStateBegan) {
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Save Image", nil];
        [sheet showInView:self.view action:^(NSInteger index) {
            if (index==0) {
                [self saveImage];
            }
        }];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [textV resignFirstResponder];
}
-(void)cancelInput
{
    [textV resignFirstResponder];
}
-(void)saveImage
{
    if (imageV.image) {
        UIImageWriteToSavedPhotosAlbum(imageV.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"error!" message:@"can't save photo" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        [ProgressHUD showSuccess:@"Save Success"];
    }
}
-(void)generateCode
{
    if ([generateBtn.currentTitle isEqualToString:@"Generate"]) {
        if (!textV.text||textV.text.length<1) {
            [ProgressHUD showError:@"Please Input"];
            return;
        }
        [textV resignFirstResponder];
        [ProgressHUD show:@"Generating..."];
        UIImage * img = [QRCodeGenerator qrImageForString:textV.text imageSize:imageV.frame.size.width Topimg:nil];
        if (img) {
            [imageV setImage:img];
            imageV.hidden = NO;
            textV.hidden = YES;
            saveBtn.hidden = NO;
            generateBtn.frame = CGRectMake((self.view.frame.size.width-140)/2, saveBtn.frame.size.height+saveBtn.frame.origin.y+20, 140, 35);
            [generateBtn setTitle:@"Generate again" forState:UIControlStateNormal];
            desL.text = @"Long Press to Save image";
            [ProgressHUD dismiss];
        }
        else
        {
            [ProgressHUD showError:@"Generate Error"];
        }

    }
    else
        [self showTextV];
}
-(void)showTextV
{
    imageV.hidden = YES;
    textV.hidden = NO;
    saveBtn.hidden = YES;
    generateBtn.frame = CGRectMake((self.view.frame.size.width-140)/2, textV.frame.size.height+textV.frame.origin.y+20, 140, 35);
    [generateBtn setTitle:@"Generate" forState:UIControlStateNormal];
    desL.text = @"Input the string or url below";
    textV.text = @"";
    [textV becomeFirstResponder];
}
-(void)toScanVC
{
    [self dismissViewControllerAnimated:NO completion:^{
        self.didDismissed();
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
