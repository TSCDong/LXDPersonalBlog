//
//  UIFont+LXDAdjustFont.m
//  LXDPersonalBlog
//
//  Created by linxinda on 16/1/17.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "UIFont+LXDAdjustFont.h"

@implementation UIFont (LXDAdjustFont)

+ (instancetype)adjustFontWithName: (NSString *)fontName size: (CGFloat)fontSize
{
    return [self fontWithName: fontName size: fontSize * LXD_SCALE_4_7];
}

@end
