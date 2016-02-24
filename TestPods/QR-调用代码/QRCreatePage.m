//
//  QRCreatePage.m
//  app
//
//  Created by bill on 14-3-18.
//  Copyright (c) 2014年 _Gear. All rights reserved.
//

#import "QRCreatePage.h"
#import "QRCodeGenerator.h"

@interface QRCreatePage ()

@property (nonatomic, strong) UIImageView* qrImgView;

@end

@implementation QRCreatePage

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self createMainView];
    
    [self createTitleView:@"分享"];
    [self._titleView left:nil btnImg:s_Title_Btn_Back];
}

#pragma mark - -------- 响应 ----------


#pragma mark - -------- 请求 ----------

-(UIImage*) encodeQr
{
    NSString* json;
    if ([_qrInfo isKindOfClass:[NSString class]]) {
        json = _qrInfo;
    }else if ([_qrInfo isKindOfClass:[NSArray class]]){
        json = [_qrInfo JSONStr];
    }else if ([_qrInfo isKindOfClass:[NSDictionary class]]){
        json = [_qrInfo JSONStr];
    }

    
    UIImage* image = [QRCodeGenerator qrImageForString:@"http://www.baidu.com" imageSize:320];
    return image;
}

#pragma mark - -------- 页面 ----------

-(void) createMainView
{
    _qrImgView = [UIImageView newImgView:CGRectMake(30, f_Title_h+20, f_Device_w-60, f_Device_w-60)];
    [self addSubview:_qrImgView];
    _qrImgView.image = [self encodeQr];
    
}

@end
