//
// QR Code Generator - generates UIImage from NSString
//
// Copyright (C) 2012 http://moqod.com Andrew Kopanev <andrew@moqod.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), to deal 
// in the Software without restriction, including without limitation the rights 
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
// of the Software, and to permit persons to whom the Software is furnished to do so, 
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all 
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
// PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
// FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
// DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <qrencode.h>
#import <ZBarSDK.h>

@interface QRCodeGenerator : NSObject

+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size;

@end



//---------------  二维码生成   ----------------------


/*
 创建一个二维码图片
 UIImage* image = [QRCodeGenerator qrImageForString:@"http:www.baidu.com" imageSize:320];
 */

@interface UIImage (QRCreate)

/// 创建二维码图片
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size;

@end

//---------------  二维码扫描   ----------------------

@class ZBarReaderView,ZBarSymbolSet;
/// 二维码识别例子
@interface UIViewController (QRReader)

/// 创建一个 二维码识别的view
- (UIView *)createQRReaderView:(CGRect )frame;
/// 创建一个 二维码识别的view
- (UIView *)createQRReaderView:(CGRect )frame delegate:(id)delegate;

/// 二维码识别的回调方法
- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image;

@end


