//
//  ViewController.m
//  TYQRCodeDemo
//
//  Created by 安天洋 on 2017/7/25.
//  Copyright © 2017年 TianYang. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "TYQRCodeGenerateViewController.h"
#import "TYQRCodeScanningViewController.h"

#define SCREENWIDTH [[UIScreen mainScreen] bounds].size.width

@interface ViewController ()

@property (nonatomic, strong) UIButton * generateBtn;
@property (nonatomic, strong) UIButton * scanningBtn;
@property (nonatomic, strong) UITextField * QRCodetextFeild;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"TYQRCode";
    [self.view addSubview:self.generateBtn];
    [self.view addSubview:self.scanningBtn];
    [self.view addSubview:self.QRCodetextFeild];
    self.generateBtn.frame = CGRectMake((SCREENWIDTH - 100)/2, 100, 100, 30);
    self.scanningBtn.frame = CGRectMake((SCREENWIDTH - 100)/2, 200, 100, 30);
    self.QRCodetextFeild.frame = CGRectMake(10, 300, SCREENWIDTH, 40);
    
}


-(UIButton *)generateBtn{
    if (_generateBtn == nil) {
        _generateBtn = [[UIButton alloc] init];
        _generateBtn.backgroundColor = [UIColor lightGrayColor];
        [_generateBtn addTarget:self action:@selector(generateOnClick) forControlEvents:UIControlEventTouchUpInside];
        [_generateBtn setTitle:@"生成二维码" forState:UIControlStateNormal];
    }
    return _generateBtn;
}

-(UIButton *)scanningBtn{
    if (_scanningBtn == nil) {
        _scanningBtn = [[UIButton alloc] init];
        _scanningBtn.backgroundColor = [UIColor greenColor];
        [_scanningBtn addTarget:self action:@selector(scanningOnClick) forControlEvents:UIControlEventTouchUpInside];
        [_scanningBtn setTitle:@"扫描二维码" forState:UIControlStateNormal];
    }
    return _scanningBtn;
}

-(UITextField *)QRCodetextFeild{
    if (_QRCodetextFeild == nil) {
        _QRCodetextFeild = [[UITextField alloc] init];
        _QRCodetextFeild.placeholder = @"请输入想转为二维码的文本";
    }
    return _QRCodetextFeild;
}


-(void)generateOnClick{
    TYQRCodeGenerateViewController *VC = [[TYQRCodeGenerateViewController alloc] init];
    [VC setQRCodeStr:_QRCodetextFeild.text];
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)scanningOnClick{
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        TYQRCodeScanningViewController *vc = [[TYQRCodeScanningViewController alloc] init];
                        [vc returnurl:^(NSString *url) {
                            NSLog(@"%@",url);
                        }];
                        [self.navigationController pushViewController:vc animated:YES];
                    });
                    //                    NSLog(@"当前线程 - - %@", [NSThread currentThread]);
                    //                    NSLog(@"用户第一次同意了访问相机权限");
                } else {
                    // 用户第一次拒绝了访问相机权限
                    //                    NSLog(@"用户第一次拒绝了访问相机权限");
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            TYQRCodeScanningViewController *vc = [[TYQRCodeScanningViewController alloc] init];
            [vc returnurl:^(NSString *url) {
                NSLog(@"%@",url);
            }];
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - 冻品邦-合伙人] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
            
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相册");
        }
    } else {
        // 如果没有相机提示
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
    } 

}


@end
