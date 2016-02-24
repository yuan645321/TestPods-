//
//  QRReaderPage.h
//  app
//
//  Created by bill on 14-3-14.
//  Copyright (c) 2014年 _Gear. All rights reserved.
//

#import "BasePage.h"
#import "QRResultPage.h"

@interface QRReaderPage : BasePage
{
    float _rectSub;
}
/// 扫描结束回调
@property (nonatomic, strong) TBlock callBack;

@end

