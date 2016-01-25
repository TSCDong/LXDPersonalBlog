//
//  UIColor+WP_NumberToColor.m
//  WisdomPark
//
//  Created by 林欣达 on 15/7/20.
//  Copyright (c) 2015年 cnpayany. All rights reserved.
//

#import "UIColor+LXDNumberToColor.h"

@implementation UIColor (LXDNumberToColor)

/**
 *  用十六进制数字rgb值设置颜色
 */
+ (UIColor *)colorWithRGBNumber: (NSUInteger)rgbNumber
{
    return [self colorWithRGBNumber: rgbNumber alpha: 1.0f];
}

+ (UIColor *)colorWithRGBNumber:(NSUInteger)rgbNumber alpha:(CGFloat)alpha
{
    NSUInteger red = (rgbNumber >> 16) & 0xff;
    NSUInteger green = (rgbNumber >> 8) & 0xff;
    NSUInteger blue = rgbNumber & 0xff;
    
    return [self colorWithRed: red/255.0 green: green/255.0 blue: blue/255.0 alpha: alpha];
}

+ (UIColor *)randomColor
{
    return [self colorWithRed: arc4random() % 256 / 255.0 green: arc4random() % 256 / 255.0 blue: arc4random() % 256 / 255.0 alpha: 1];
}


@end
