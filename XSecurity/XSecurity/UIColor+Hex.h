//
//  UIColor+Hex.h
//
//  Created by wangyuehong on 15/9/6.
//  Copyright (c) 2015年 Oradt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ora_Hex)

#define KColorF7F7F7

//根据16进制颜色值和alpha值生成UIColor
+ (UIColor *)ora_colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;

//根据16进制颜色值和alpha为1生成UIColor
+ (UIColor *)ora_colorWithHex:(UInt32)hex;
+ (UIColor *)ora_darkColorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;
//根据16进制颜色字符串生成UIColor
// hexString 支持格式为 OxAARRGGBB / 0xRRGGBB / #AARRGGBB / #RRGGBB / AARRGGBB / RRGGBB
+ (UIColor *)ora_colorWithHexString:(NSString *)hexString;
+ (UIColor *)ora_colorWithHexString:(NSString *)hexString andAlpha:(CGFloat)alpha;

//返回当前对象的16进制颜色值
- (UInt32)ora_hexValue;

@end
