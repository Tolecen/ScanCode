//
//  ActionViewController.m
//  GenerateCode
//
//  Created by Tolecen on 2017/7/1.
//  Copyright © 2017年 TaoXinle. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <SafariServices/SafariServices.h>
#import "QRCodeGenerator.h"

#import "UIActionSheet+block.h"

#import "ZBarSDK.h"

#import "TTImageHelper.h"


@interface ActionViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITextView * textV;
    UIImageView * imageV;
    UILabel * desL;
    
    UIButton * generateBtn;
    UIButton * saveBtn;
    
    UIButton * addIconBtn;
    
    UIButton * openLinkBtn;
    UIButton * copyBtn;
    
    CGFloat screenHeight;
    CGFloat screenWidth;
}

@property(strong,nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UILabel *progressLabel;

@end

@implementation ActionViewController

-(void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:108.f/255 green:151.f/255 blue:185.f/255 alpha:1.f];
    screenHeight = self.view.frame.size.height;
    screenWidth = self.view.frame.size.width;
    
    UILabel * titleLabel= [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-140)/2, 20, 140, 44)];
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
    
    //    UIButton * toGenerateVCBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [toGenerateVCBtn setFrame:CGRectMake(self.view.frame.size.width-80, 30, 70, 35)];
    //    toGenerateVCBtn.backgroundColor = [UIColor clearColor];
    //    toGenerateVCBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    //    [toGenerateVCBtn setTitle:@"Scan >" forState:UIControlStateNormal];
    //    //    toGenerateVCBtn.layer.cornerRadius = 5;
    //    //    toGenerateVCBtn.layer.borderWidth = 1;
    //    //    toGenerateVCBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    //    toGenerateVCBtn.layer.masksToBounds = YES;
    //    [self.view addSubview:toGenerateVCBtn];
    //    [toGenerateVCBtn addTarget:self action:@selector(toScanVC) forControlEvents:UIControlEventTouchUpInside];
    
    
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
        UIBarButtonItem*rb = [[UIBarButtonItem alloc]initWithTitle:@"Generate" style:UIBarButtonItemStyleDone target:self action:@selector(generateCode:)];
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
    [generateBtn addTarget:self action:@selector(generateCode:) forControlEvents:UIControlEventTouchUpInside];
    generateBtn.tag = 1;
    
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
    [saveBtn addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.hidden = YES;
    saveBtn.tag = 1;
    
    UILabel * bottomL= [[UILabel alloc] initWithFrame:CGRectMake(20, screenHeight-50, screenWidth-40, 20)];
    bottomL.backgroundColor = [UIColor clearColor];
    bottomL.font = [UIFont systemFontOfSize:12];
    bottomL.textAlignment = NSTextAlignmentCenter;
    bottomL.textColor=[UIColor whiteColor];
    bottomL.text=@"Made by Tolecen";
    [self.view addSubview:bottomL];
    bottomL.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel)];
    [bottomL addGestureRecognizer:tap];
    
    
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-140)/2, 74, 140, 35)];
    self.progressLabel.backgroundColor = [UIColor blackColor];
    self.progressLabel.alpha = 0.8;
    self.progressLabel.textColor = [UIColor whiteColor];
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:self.progressLabel];
    self.progressLabel.layer.cornerRadius = 5;
    self.progressLabel.layer.masksToBounds = YES;
    self.progressLabel.hidden = YES;
    self.progressLabel.adjustsFontSizeToFitWidth = YES;
    
    
    addIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addIconBtn setFrame:CGRectMake(0, 0, 40, 40)];
    
    //    addIconBtn.backgroundColor = [UIColor lightGrayColor];
    //    addIconBtn.titleLabel.font = [UIFont boldSystemFontOfSize:25];
    //    [addIconBtn setTitle:@"+" forState:UIControlStateNormal];
    //    addIconBtn.layer.cornerRadius = 3;
    //
    //    addIconBtn.layer.masksToBounds = YES;
    [imageV addSubview:addIconBtn];
    addIconBtn.center = CGPointMake(imageV.frame.size.width/2, imageV.frame.size.width/2);
    //    [addIconBtn addTarget:self action:@selector(addIconBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    addIconBtn.userInteractionEnabled = NO;
    addIconBtn.hidden = YES;
    
    // Get the item[s] we're handling from the extension context.
    
    // For example, look for an image and place it into an image view.
    // Replace this with something appropriate for the type[s] your extension supports.
    BOOL textFound = NO;
    BOOL imageFound = NO;
    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        for (NSItemProvider *itemProvider in item.attachments) {
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePlainText]) {
                // This is an image. We'll load it, then place it in our image view.
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypePlainText options:nil completionHandler:^(NSString *str, NSError *error) {
                    if(str) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"the String:%@",str);
                            textV.text = str;
                        }];
                    }
                }];
                
                textFound = YES;
                break;
            }
            
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeImage]) {
                // This is an image. We'll load it, then place it in our image view.
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeImage options:nil completionHandler:^(UIImage *img, NSError *error) {
                    if(img) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                            NSLog(@"the String:%@",str);
                            [self recImage:img];
                            
                        }];
                    }
                }];
                
                imageFound = YES;
                break;
            }
        }
        
        if (imageFound || textFound) {
            // We only handle one image, so stop looking for more.
            break;
        }
    }
    
    
    if (textFound) {
        titleLabel.text=@"Generate Code";
        textV.editable = YES;
        desL.text=@"Input the string or url below";
        generateBtn.hidden = NO;
        
        
    }
    if (imageFound) {
        titleLabel.text=@"Result";
        textV.editable = NO;
        desL.text=@"";
        
//        generateBtn.hidden = YES;
        
        textV.layer.cornerRadius = 0;
        textV.layer.borderColor = [[UIColor clearColor] CGColor];
        textV.layer.borderWidth = 0;
        textV.layer.masksToBounds = NO;
        textV.userInteractionEnabled = NO;
        
    }
}

-(void)recImage:(UIImage *)image
{
    UIImage * img = image;
    ZBarImageScanner * sc = [[ZBarImageScanner alloc] init];
    if ([sc scanImage:[[ZBarImage alloc] initWithCGImage:img.CGImage]]) {
        ZBarSymbol * symbol;
        for(symbol in sc.results)
            break;
//        stringValue = symbol.data;
        NSLog(@"result:%@",symbol.data);
        [self showResultWithStr:symbol.data];
        
    }
    else
    {
        [self showResultWithStr:nil];
    }
}

-(void)showResultWithStr:(NSString *)str
{
    textV.text = str;
    if ([str hasPrefix:@"http://"]||[str hasPrefix:@"https://"]) {
        saveBtn.hidden = NO;
        [saveBtn setTitle:@"Open Link" forState:UIControlStateNormal];
        saveBtn.tag = 3;
        
    }
    else
    {
        saveBtn.hidden = YES;
    }
    [generateBtn setTitle:@"Copy Text" forState:UIControlStateNormal];
    generateBtn.tag = 3;
    if (screenHeight<500) {
        saveBtn.frame = CGRectMake(self.view.frame.size.width-40-115, textV.frame.size.height+textV.frame.origin.y+20, 115, 35);
        generateBtn.frame = CGRectMake(saveBtn.frame.origin.x, saveBtn.frame.origin.y+35+10, 115, 35);
        
    }
    else{
        saveBtn.frame = CGRectMake((self.view.frame.size.width-140)/2, textV.frame.size.height+textV.frame.origin.y+20, 140, 35);
        generateBtn.frame = CGRectMake((self.view.frame.size.width-140)/2, saveBtn.frame.size.height+saveBtn.frame.origin.y+20, 140, 35);
    }
}

-(void)showProgressLabelWithText:(NSString *)text
{
    self.progressLabel.text = text;
    self.progressLabel.hidden = NO;
    [self performSelector:@selector(hidePL) withObject:nil afterDelay:2.2];
}

-(void)hidePL
{
    self.progressLabel.hidden = YES;
}

-(void)tapLabel
{
    NSString * stringValue = @"http://xinle.co";
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
        NSLog(@"111");
        SFSafariViewController * sv = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:stringValue]];
        sv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:sv animated:YES completion:^{
            
        }];
    }
    else{
        
    }
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)press
{
    
    if (press.state == UIGestureRecognizerStateEnded) {
        
        return;
        
    } else if (press.state == UIGestureRecognizerStateBegan) {
        //        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Save Image", nil];
        //        [sheet showInView:self.view action:^(NSInteger index) {
        //            if (index==0) {
        //                [self saveImage];
        //            }
        //        }];
        
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil                                                                             message: nil                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
        if (!addIconBtn.currentImage) {
            [alertController addAction: [UIAlertAction actionWithTitle: @"Add icon" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypePhotoLibrary)]) {
                    
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    picker.allowsEditing = YES;
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    //model 一个 View
                    [self presentViewController:picker animated:YES completion:^{
                        
                        
                    }];
                }
                else {
                    NSAssert(NO, @" ");
                }
            }]];
        }
        else
        {
            [alertController addAction: [UIAlertAction actionWithTitle: @"Change icon" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypePhotoLibrary)]) {
                    
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    picker.allowsEditing = YES;
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    //model 一个 View
                    [self presentViewController:picker animated:YES completion:^{
                        
                        
                    }];
                }
                else {
                    NSAssert(NO, @" ");
                }
            }]];
            
            [alertController addAction: [UIAlertAction actionWithTitle: @"Delete icon" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [addIconBtn setImage:nil forState:UIControlStateNormal];
            }]];
        }
        
        [alertController addAction: [UIAlertAction actionWithTitle: @"Cancel" style: UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController: alertController animated: YES completion: nil];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    NSAssert(image, @" ");
    if (image) {
        UIImage * img = [TTImageHelper compressImageDownToPhoneScreenSize:image targetSizeX:45 targetSizeY:45];
        addIconBtn.hidden = NO;
        [addIconBtn setImage:img forState:UIControlStateNormal];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
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
-(void)saveImage:(UIButton *)btn
{
    if (btn.tag==1 || !btn) {
        if (imageV.image && !addIconBtn.currentImage) {
            UIImageWriteToSavedPhotosAlbum(imageV.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
        else if (imageV.image && addIconBtn.currentImage){
            UIImage * img = [QRCodeGenerator qrImageForString:textV.text imageSize:imageV.frame.size.width Topimg:addIconBtn.currentImage];
            UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    else if(btn.tag==3){
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
//            NSLog(@"111");
            SFSafariViewController * sv = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:textV.text]];
            sv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
           
            [self presentViewController:sv animated:YES completion:^{
                
            }];
        }
    }
    
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error != NULL) {
        
    } else {
//        [ProgressHUD showSuccess:@"Save Success"];
        [self showProgressLabelWithText:@"Save Success"];
    }
}
-(void)generateCode:(UIButton *)btn
{
    if (btn.tag==3) {
        UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
        
        pasteboard.string=textV.text;
        
        [self showProgressLabelWithText:@"Copy Success"];

    }
    else if (btn.tag==2){
         [self showTextV];
    }
    else {
        if (!textV.text||textV.text.length<1) {
//            [ProgressHUD showError:@"Please Input"];
            return;
        }
        [textV resignFirstResponder];
//        [ProgressHUD show:@"Generating..."];
        UIImage * img = [QRCodeGenerator qrImageForString:textV.text imageSize:imageV.frame.size.width Topimg:nil];
        if (img) {
            [imageV setImage:img];
            imageV.hidden = NO;
            textV.hidden = YES;
            saveBtn.hidden = NO;
            if (screenHeight<500) {
                saveBtn.frame = CGRectMake(self.view.frame.size.width-40-115, imageV.frame.size.height+imageV.frame.origin.y+20, 115, 35);
                generateBtn.frame = CGRectMake(imageV.frame.origin.x, saveBtn.frame.origin.y, 115, 35);
                
            }
            else{
                generateBtn.frame = CGRectMake((self.view.frame.size.width-140)/2, saveBtn.frame.size.height+saveBtn.frame.origin.y+20, 140, 35);
            }
            [generateBtn setTitle:@"Generate again" forState:UIControlStateNormal];
            generateBtn.tag = 2;
            desL.text = @"Long press to add or change icon";
//            [ProgressHUD dismiss];
        }
        else
        {
//            [ProgressHUD showError:@"Generate Error"];
        }
        
    }
    
       
}
-(void)showTextV
{
    addIconBtn.hidden = YES;
    imageV.hidden = YES;
    textV.hidden = NO;
    saveBtn.hidden = YES;
    generateBtn.frame = CGRectMake((self.view.frame.size.width-140)/2, textV.frame.size.height+textV.frame.origin.y+20, 140, 35);
    [generateBtn setTitle:@"Generate" forState:UIControlStateNormal];
    desL.text = @"Input the string or url below";
    textV.text = @"";
    [textV becomeFirstResponder];
}

- (IBAction)done {
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    [self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems completionHandler:nil];
}

@end
