//
//  UILabel+YQBDesignedInitializer.h
//  YuanQuBao
//
//  Created by 林欣达 on 16/3/1.
//  Copyright © 2016年 CNPay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LXDDesignedInitializer)

/// 使用默认黑色字体17号字
+ (instancetype)labelWithFrame: (CGRect)frame text: (NSString *)text;
/// 设置文本对齐方向
+ (instancetype)labelWithFrame: (CGRect)frame alignment: (NSTextAlignment)alignment;
/// 使用系统默认17号字体并左对齐
+ (instancetype)labelWithFrame: (CGRect)frame text: (NSString *)text textColor: (UIColor *)textColor;
/// 使用系统默认字体并左对齐
+ (instancetype)labelWithFrame: (CGRect)frame text: (NSString *)text textColor: (UIColor *)textColor fontSize: (CGFloat)fontSize;
/// 使用系统默认字体并设置文本对齐
+ (instancetype)labelWithFrame: (CGRect)frame text: (NSString *)text textColor: (UIColor *)textColor fontSize: (CGFloat)fontSize alignment: (NSTextAlignment)alignment;
/// 使用系统默认黑体并设置文本对齐
+ (instancetype)labelWithFrame: (CGRect)frame text: (NSString *)text textColor: (UIColor *)textColor fontSize: (CGFloat)fontSize alignment: (NSTextAlignment)alignment boldFont: (BOOL)boldFont;

@end
