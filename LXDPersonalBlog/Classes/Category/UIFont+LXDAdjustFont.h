//
//  UIFont+LXDAdjustFont.h
//  LXDPersonalBlog
//
//  Created by linxinda on 16/1/17.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (LXDAdjustFont)

/// 根据屏幕大小比例等比例缩放字体尺寸
+ (instancetype)adjustFontWithName: (NSString *)fontName size: (CGFloat)fontSize;

@end
