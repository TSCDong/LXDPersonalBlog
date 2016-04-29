//
//  UILabel+YQBDesignedInitializer.m
//  YuanQuBao
//
//  Created by 林欣达 on 16/3/1.
//  Copyright © 2016年 CNPay. All rights reserved.
//

#import "UILabel+LXDDesignedInitializer.h"

@implementation UILabel (LXDDesignedInitializer)

+ (instancetype)labelWithFrame: (CGRect)frame text: (NSString *)text
{
    return [self labelWithFrame: frame text: text textColor: [UIColor blackColor] fontSize: 17 alignment: NSTextAlignmentLeft boldFont: NO];
}

+ (instancetype)labelWithFrame: (CGRect)frame alignment: (NSTextAlignment)alignment
{
    return [self labelWithFrame: frame text: nil textColor: [UIColor blackColor] fontSize: 17 alignment: alignment boldFont: NO];
}

/// 使用系统默认17号字体并左对齐
+ (instancetype)labelWithFrame: (CGRect)frame text: (NSString *)text textColor: (UIColor *)textColor
{
    return [self labelWithFrame: frame text: text textColor: textColor fontSize: 17 alignment: NSTextAlignmentLeft boldFont: NO];
}

/// 使用系统默认字体并左对齐
+ (instancetype)labelWithFrame: (CGRect)frame text: (NSString *)text textColor: (UIColor *)textColor fontSize: (CGFloat)fontSize
{
    return [self labelWithFrame: frame text: text textColor: textColor fontSize: fontSize alignment: NSTextAlignmentLeft boldFont: NO];
}

/// 使用系统默认字体并设置文本对齐
+ (instancetype)labelWithFrame: (CGRect)frame text: (NSString *)text textColor: (UIColor *)textColor fontSize: (CGFloat)fontSize alignment: (NSTextAlignment)alignment
{
    return [self labelWithFrame: frame text: text textColor: textColor fontSize: fontSize alignment: alignment boldFont: NO];
}

/// 使用系统默认黑体并设置文本对齐
+ (instancetype)labelWithFrame: (CGRect)frame text: (NSString *)text textColor: (UIColor *)textColor fontSize: (CGFloat)fontSize alignment: (NSTextAlignment)alignment boldFont: (BOOL)boldFont
{
    UILabel * label = [[self alloc] initWithFrame: frame];
    label.text = text;
    label.textColor = textColor;
    label.textAlignment = alignment;
    label.font = boldFont ? [UIFont boldSystemFontOfSize: fontSize] : [UIFont systemFontOfSize: fontSize];
    return label;
}

@end
