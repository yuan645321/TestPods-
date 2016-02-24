//
//  ViewController.m
//  TestPods
//
//  Created by LiuTao on 15/12/29.
//  Copyright © 2015年 LiuTao. All rights reserved.
//

#import "ViewController.h"
#import "QRCodeUtil.h"
@interface ViewController ()<ZBarReaderViewDelegate>


@property (strong, nonatomic) ZBarReaderView* readerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
//    ---------- 创建二维码代码
    UIImageView* tImgView = nil;
    tImgView = [[UIImageView alloc] init];
    tImgView.frame = CGRectMake(0, 0, 320, 320);
    
    UIImage* image = [QRCodeGenerator qrImageForString:@"http://www.baidu.com" imageSize:320];

    tImgView.image  = image;
    [self.view addSubview:tImgView];

    
//    ------------------ 读取二维码
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.readerView) {
        self.readerView = (ZBarReaderView*)[self createQRReaderView:CGRectMake(0, 0, 320, 320) delegate:self];
        [self.view addSubview:self.readerView];
    }
    [self.readerView start];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.readerView stop];
}


/// 二维码识别的回调方法
- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        @try {
            
            ZBarSymbol  *symbol = nil;
            NSString    *result = nil;
            for (symbol in symbols){
                if ([symbol.data canBeConvertedToEncoding:NSShiftJISStringEncoding]) {
                    result = [NSString stringWithCString:[symbol.data cStringUsingEncoding:NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
                } else {
                    result = symbol.data;
                }
            }

            NSLog(@" --- 扫描结果：%@",result);
            //            TODO:  处理二维码的数据：symbols   和图片：  image
            //            [self doReadImg:symbols image:image];
        }
        @catch (NSException *exception) {
            NSLog(@" ==> %@",exception);
        }
        @finally {
            
        }
    });
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
