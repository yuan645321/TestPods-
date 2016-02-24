//
//  QRCreatePage.h
//  app
//
//  Created by bill on 14-3-18.
//  Copyright (c) 2014年 _Gear. All rights reserved.
//

#import "BasePage.h"

@interface QRCreatePage : BasePage

/// 数据  字符串:直接生成二维码   字典:转成json保存 数组:转成json 保存
@property (nonatomic, strong) id qrInfo;

@end
