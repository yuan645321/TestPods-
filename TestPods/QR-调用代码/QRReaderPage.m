//
//  QRReaderPage.m
//  app
//
//  Created by bill on 14-3-14.
//  Copyright (c) 2014年 _Gear. All rights reserved.
//

#define f_Rect_h f_scale(240)
#define f_scan_time 1.5f

#import "QRReaderPage.h"
#import <AVFoundation/AVFoundation.h>
#import "BrowserPage.h"

#import "MainPage.h"

@interface BkView : UIView
@property (nonatomic, assign) CGRect rectForClearing;
@property (nonatomic, strong) UIColor *overallColor;
@end

@interface QRReaderPage ()<ZBarReaderViewDelegate>

/// qr扫描控件
@property (nonatomic, strong) ZBarReaderView* readView;
/// 扫描动画定时器
@property (nonatomic, strong) NSTimer* timer;
/// 扫描动画 线条
@property (nonatomic, strong) UIImageView* line;
/// 扫描动画 背景框
@property (nonatomic, strong) UIImageView* rectView;

@end

@implementation QRReaderPage

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createTitleView:@"扫描二维码"];
    [self._titleView left:nil btnImg:s_Title_Btn_Back];
}

#pragma mark - -------- 设置 ----------

/// 设置闪光灯
- (void)turnLight
{
    AVCaptureDevice *device = self.readView.device;
    
    if ([device hasTorch] && [device isTorchAvailable]) {
        if (device.torchMode == AVCaptureTorchModeOn) {
            [self turnOffLed];
        }else if(device.torchMode == AVCaptureTorchModeOff){
            [self turnOnLed];
        }else {
            if (device.torchLevel == 0.0 ) {
                [self turnOnLed];
            }else {
                [self turnOffLed];
            }
            
        }
    }
}

/// 关闭闪光灯
- (void)turnOffLed
{
    AVCaptureDevice *device = self.readView.device;
    //AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode: AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
}

/// 打开闪光灯
- (void)turnOnLed
{
    AVCaptureDevice *device = self.readView.device;
    //AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode: AVCaptureTorchModeOn];
        [device unlockForConfiguration];
    }
    
}

/// 开始扫描
-(void) startScan
{
    // 定时器，设定时间过1.5秒，
    _timer = [NSTimer scheduledTimerWithTimeInterval:f_scan_time target:self selector:@selector(scanAnimation) userInfo:nil repeats:YES];
    [self.readView start];
    [self turnOffLed];
}

/// 停止扫描
-(void) stopScan
{
    [self.readView stop];
    [_timer invalidate];
}


#pragma mark - -------- 页面 ----------

- (void)createCamera
{
    ZBarImageScanner *scanner = [ZBarImageScanner new];
    [scanner setSymbology:ZBAR_PARTIAL config:0 to:0];
    
    self.readView = [[ZBarReaderView alloc] initWithImageScanner:scanner];
    self.readView.readerDelegate = self;
    self.readView.scanCrop = CGRectMake(0.1, 0.2, 0.8, 0.8);  // 扫描的感应框
    //    [self.readView.scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    self.readView.frame = CGRectMake(0, f_StatusBar_h, f_Device_w, f_Screen_h);
    [self addSubview:self.readView];
    
    //        // 背景
    BkView *backView = [[BkView alloc] initWithFrame:CGRectMake(0, f_Page_y, f_Device_w, f_Page_h)];
    [self addSubview:backView];
    
    // 二维码背景 图片
//    UIImageView* tImgView = [UIImageView newImgViewByImg:[UIImage getImage:@"pic_ewm_smk.png"]];
//    tImgView.size = CGSizeMake(f_Device_w, f_Device_w/(tImgView.width/tImgView.height));
//    tImgView.bottom = backView.height;
//    [backView addSubview:tImgView];
//
//    float scanY = 0;
//    if (tImgView.height > 500) {
//        scanY = tImgView.height*0.159f;
//    }else{
//        tImgView.imageEx = [UIImage getImage:@"pic_ewm_zz_960.png"];
//        scanY = tImgView.height*0.099f;
//    }
    
    // 背景框
    _rectSub = 12;
    _rectView = [UIImageView newImgViewByImg:[UIImage getImage:@"pic_ewm_smk.png"]];
    _rectView.center = CGPointMake(backView.width/2, backView.height/2+10);
    _rectView.clipsToBounds = YES;
    [backView addSubview:_rectView];

    backView.overallColor = [UIColor hexColor:@"000000" alpha:0.4];
    backView.rectForClearing = _rectView.frame;
//    backView.rectForClearing = CGRectMake(_rectView.left, _rectView.top+3, _rectView.width, _rectView.height+6);

    
    // ------------------ 手动画阴影
//    CGRect myRect =_rectView.frame;
    
//    int radius = myRect.size.width/2.0;
    
//    UIBezierPath *path = [UIBezierPathbezierPathWithRoundedRect:CGRectMake(0,0, backView.bounds.size.width, backView.bounds.size.height)cornerRadius:0];
//    
//    UIBezierPath *circlePath = [UIBezierPathbezierPathWithRoundedRect:CGRectMake(100,100,2.0*radius,2.0*radius)cornerRadius:radius];
//    
//    [path appendPath:circlePath];
//    
//    [path setUsesEvenOddFillRule:YES];
    
//    CGPathRef path = CGPathCreateWithRect(myRect, );
    

    

//    UIColor* bColor = [UIColor hexColor:@"000000" alpha:0.4];
//    CGRect frame = CGRectMake(0, 0, f_Device_w, _rectView.top+5);
//    [backView addSubview:[UIView newView:frame bgColor:bColor ]];
//    
//    frame = CGRectMake(0, _rectView.top, _rectView.left+5, _rectView.height);
//    [backView addSubview:[UIView newView:frame bgColor:bColor ]];
//    
//    frame = CGRectMake(_rectView.right-5, _rectView.top, _rectView.left, _rectView.height);
//    [backView addSubview:[UIView newView:frame bgColor:bColor ]];
//    
//    frame = CGRectMake(0, _rectView.bottom-5, f_Device_w, backView.height-_rectView.height);
//    [backView addSubview:[UIView newView:frame bgColor:bColor ]];
    
    _line = [UIImageView newImgViewByImg:[UIImage getImage:@"pic_ewm_sm.png"]];
    _line.frame = CGRectMake(_rectSub, 0, _rectView.width-2*_rectSub, _line.height);
    [_rectView addSubview:_line];
    
}

- (void)scanAnimation
{
    self.line.top = 0;
    
    //    __block UIView* bLine = _line;
    __block QRReaderPage* bSelf = self;
    [UIView animateWithDuration:f_scan_time delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        bSelf.line.bottom = bSelf.rectView.height-_rectSub;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.readView) {
        [self createCamera];
    }
    [self startScan];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self stopScan];
}

#pragma mark - -------- ZBarReaderViewDelegate ----------

- (void)doReadImg:(id <NSFastEnumeration>)symbols image:(UIImage *)image
{
    ZBarSymbol  *symbol = nil;
    NSString    *result = nil;
    for (symbol in symbols){
        if ([symbol.data canBeConvertedToEncoding:NSShiftJISStringEncoding]) {
            result = [NSString stringWithCString:[symbol.data cStringUsingEncoding:NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        } else {
            result = symbol.data;
        }
    }
    
    [self doQueryResult:result];
}


/// 处理扫描结果
-(void) doQueryResult:(id)item
{
    [self stopScan];
    
//    if ([item isKindOfClass:[NSString class]] && item) {
//        // url  http://ts-gfs.gearsoft.com.cn/index.php/data/datainfo/?type=1&dataid=1
//        
//        // http://shop.gofaceshow.com/index.php/data/datainfo
//        NSURL* reqUrl = [NSURL URLWithString:[item deleteSpace]];
//        if (!reqUrl) {
//            [TLoadingView showAlert:@"未识别的二维码"];
//            [self startScan];
//            return;
//        }
//
//#ifdef DEBUG
//        if ([reqUrl.path isContain:@"/index.php/data/datainfo"]) {
////            if ([reqUrl.path isContain:[s_host appendStr:@"/index.php/data/datainfo"]]) {
//#else
//        if ([reqUrl.path isContain:@"/index.php/data/datainfo"]) {
////                    if ([reqUrl.path isContain:[s_host appendStr:@"/index.php/data/datainfo"]]) {
//#endif
//            
//            id querys = [reqUrl.query subToArrBy:@"&"];
//            
//            NSString* typeStr;
//            for (NSString* subQuery in querys) {
//                if ([subQuery isContain:@"type"]) {
//                    typeStr = [[subQuery subToArrBy:@"="] objectAtIndexEx:1];
//                    break;
//                }
//            }
//            NSString* dataStr;
//            for (NSString* subQuery in querys) {
//                if ([subQuery isContain:@"dataid"]) {
//                    dataStr = [[subQuery subToArrBy:@"="] objectAtIndexEx:1];
//                    break;
//                }
//            }
//            if (!typeStr || !dataStr) {
////                [self showAlert:@"无效的美美券" done:@"确定" cancel:nil click:^(NSInteger index) {
////                    [self startScan];
////                }];
//                return;
//            }
//            
//            // 商家
//            if ([typeStr intValue] == 0) {
//                CompInfoPage* tPage = [CompInfoPage compWithShopId:dataStr];
//                [self.navigationController popViewControllerAnimated:NO];
//                [k_Main pushController:tPage];
//                return;
//            }
//            // 优惠
//            if ([typeStr intValue] == 1) {
//                __block QRReaderPage* bSelf = self;
//                BaseParam* param = [SvrInfoParam paramByyouhuiid:[item _dataid]
//                                                 lastcommentflag:nil
//                                                    tjyouhuiflag:nil
//                                                         userlat:self.myLat
//                                                         userlng:self.myLng];
//                [self doRequest:param resp:^(SvrInfoModel* item) {
//                    SvrInfoPage *tPage = [[SvrInfoPage alloc] init];
//                    tPage.svrInfo = item._youhuiinfo;
//                    [bSelf.navigationController popViewControllerAnimated:NO];
//                    [k_Main pushController:tPage];
//                    return ;
//                }];
//
//            }else{
//                BrowserPage* tPage = [BrowserPage newBrowser:item title:@"扫描结果"];
//                [self.navigationController popViewControllerAnimated:NO];
//                [k_Main pushController:tPage];
//                return;
//            }
//        }else{
//            BrowserPage* tPage = [BrowserPage newBrowser:item title:@"扫描结果"];
//            [self.navigationController popViewControllerAnimated:NO];
//            [k_Main pushController:tPage];
//            return;
//        }
//    }
//    
////    [self showAlert:@"无效的美美券" done:@"确定" cancel:nil click:^(NSInteger index) {
////        [self startScan];
////    }];
//    
//}

//    [self popController];
    if ([item isKindOfClass:[NSString class]] && item) {
        if ([item hasPrefix:@"http://"]) {
            BrowserPage* tPage = [BrowserPage newBrowser:item title:@"详情"];
            [self pushController:tPage];
        }else{
            _bself
            [bSelf.navigationController popViewControllerAnimated:NO];
            if (bSelf.callBack) {
                bSelf.callBack(item);
            }
//            __block QRReaderPage* bSelf = self;
//            BaseParam* param = [OrderInfoParam paramByorderid:nil];
////            BaseParam* param = [OrderInfoParam paramBysvrcodeid:[item description] orderid:nil];
//            [self doRequest:param resp:^(OrderInfoModel* item) {
//                if (item.isSuccess) {
//                    [bSelf.navigationController popViewControllerAnimated:NO];
//                    if (bSelf.callBack) {
//                        bSelf.callBack(item);
//                    }
//                }else{
//                    [TLoadingView showAlert:@"无效的服务工单"];
//                    [self startScan];
//                }
//            }];
        }
    }
//
//    DLog(" 扫描的二维码信息: %@", result);
//    NSDictionary* qrInfo = [result JSON2Value];
//    if (![qrInfo isKindOfClass:[NSDictionary class]]) {
//        return;
//    }

//    if (![[NSString stringById:[qrInfo objectForKey:@"shopid"]] isEqualToString:[TConstants fsshopid]]) {
//        return;
//    }
//
//    NSString* cmd = [qrInfo objectForKey:@"cmd"];
//    NSString* dateId = [NSString stringById:[qrInfo objectForKey:@"dataid"]];



// 礼品兑换
//    if ([cmd isEqualToString:@"get_presentorderinfo"]) {
//
//        __block BasePage* bSelf = self;
//        __block BasePage* bSupre = self._superPage;
//        BaseParam* param = [GiftOrderInfoParam paramBypresentorderid:dateId];
//        [self doRequest:param resp:^(GiftOrderInfoModel* item) {
//            if (item.isSuccess) {
////                [LoadingView showAlert:k_Str_Fmt(@"到店领取礼品")];
//                    [LoadingView showAlert:s_msg_3_0_0];
//                [bSelf dismissViewControllerAnimated:NO completion:^{
//
//                }];
//                MGiftCDetailPage* tPage = [[MGiftCDetailPage alloc] init];
//                tPage.giftOrderInfo = item._presentorderinfo;
//                tPage._superPage = self;
//                tPage._pageType = [item._presentorderinfo._changeway intValue];
//
//                if ([item._presentorderinfo._status intValue]==1) {
//                    [bSupre presentController:tPage];
//                }else{
//                    [bSupre pushPage:tPage];
//                }
//            }
//        }];
//
//
////        [bSelf dismissController];
//    }
//    else if ([cmd isEqualToString:@"presentorderinfo"]) {
//
//    }


//    QRResultPage *tPage = [[QRResultPage alloc] init];
//    [tPage setResult:symbols image:image];
//    [self pushController:tPage];
}


- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        @try {
            [self doReadImg:symbols image:image];
        }
        @catch (NSException *exception) {
            DLog(" ==> %@",exception);
        }
        @finally {
            
        }
    });
}

@end

@implementation BkView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder // support init from nib
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef ct = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ct, self.overallColor.CGColor);
    CGContextFillRect(ct, self.bounds);
    CGContextClearRect(ct, self.rectForClearing);
}
@end