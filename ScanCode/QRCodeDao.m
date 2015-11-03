//
//  DecodeQRDao.m
//  ShopManager-iOS
//
//  Created by liwei on 15/6/3.
//  Copyright (c) 2015年 liwei. All rights reserved.
//

#import "QRCodeDao.h"


//static NSString * const KERCodeURL = @"http://172.20.22.50:8080/lsms/io/Terminal/decode.do?";// @"http://192.168.10.8:8080/RSATool/servlet/RSAServlet?";

@implementation QRCodeDao

// string 二维码中的加密字符串；result:0 成功，1 查询失败，2，网络连接失败
+ (void)qrCode:(NSString *)string block:(void(^)(NSString *salesAgentNo, NSString *licenceSerial, int result))block
{
    
        
}


@end
