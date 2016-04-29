//
//  UIColor+WP_NumberToColor.h
//  WisdomPark
//
//  Created by 林欣达 on 15/7/20.
//  Copyright (c) 2015年 cnpayany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LXDNumberToColor)

/**
 *  用十六进制数字rgb值设置颜色
 */
+ (UIColor *)colorWithRGBNumber: (NSUInteger)rgbNumber;

/**
 *  用十六进制数字rgb值设置透层层颜色
 */
+ (UIColor *)colorWithRGBNumber: (NSUInteger)rgbNumber alpha: (CGFloat)alpha;

/**
 *  随机颜色
 */
+ (UIColor *)randomColor;

@end
