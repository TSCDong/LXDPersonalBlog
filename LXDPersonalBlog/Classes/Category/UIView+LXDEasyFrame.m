//
//  UIView+LXDEasyFrame.m
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/1/12.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "UIView+LXDEasyFrame.h"

@implementation UIView (LXDEasyFrame)

/// 控件x轴坐标
- (CGFloat)x { return self.frame.origin.x; }

/// 控件y轴坐标
- (CGFloat)y { return self.frame.origin.y; }

/// 控件宽度
- (CGFloat)width { return self.frame.size.width; }

/// 控件高度
- (CGFloat)height { return self.frame.size.height; }

/// 控件中心x坐标
- (CGFloat)centerX { return self.center.x; }

/// 控件中心y坐标
- (CGFloat)centerY { return self.center.y; }

/// 控件x轴最大值坐标
- (CGFloat)maxX { return CGRectGetMaxX(self.frame); }

/// 控件y轴最大坐标
- (CGFloat)maxY { return CGRectGetMaxY(self.frame); }

/// 控件坐标
- (CGPoint)origin { return self.frame.origin; }

/// 控件尺寸
- (CGSize)size { return self.frame.size; }


#pragma mark - Setter
/// 设置x坐标
- (void)setX: (CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

/// 设置y坐标
- (void)setY: (CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

/// 设置宽度
- (void)setWidth: (CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

/// 设置高度
- (void)setHeight: (CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

/// 设置中心x坐标
- (void)setCenterX: (CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}

/// 设置中心y坐标
- (void)setCenterY: (CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

/// 设置尺寸
- (void)setSize: (CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

/// 设置坐标
- (void)setOrigin: (CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

@end
