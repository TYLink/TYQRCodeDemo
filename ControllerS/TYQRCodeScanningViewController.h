//
//  TYQRCodeScanningViewController.h
//  TYQRCodeDemo
//
//  Created by 安天洋 on 2017/7/26.
//  Copyright © 2017年 TianYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYQRCodeScanningViewController : UIViewController


typedef void (^TYQRCodeBlock)(NSString * url);

@property (nonatomic, copy) TYQRCodeBlock returnQRCodeUrlBlock;

- (void)returnurl:(TYQRCodeBlock)block;

@end
