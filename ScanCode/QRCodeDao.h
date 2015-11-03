//
//  DecodeQRDao.h
//  ShopManager-iOS
//
//  Created by liwei on 15/6/3.
//  Copyright (c) 2015年 liwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRCodeDao : NSObject

+ (void)qrCode:(NSString *)string block:(void(^)(NSString *salesAgentNo, NSString *licenceSerial, int result))block;

@end
