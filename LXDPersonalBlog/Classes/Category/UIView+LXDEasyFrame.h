//
//  UIView+LXDEasyFrame.h
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/1/12.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  坐标尺寸方法扩展
 */
@interface UIView (LXDEasyFrame)

#pragma mark - Getter
/// 控件x轴坐标
- (CGFloat)x;
/// 控件y轴坐标
- (CGFloat)y;
/// 控件宽度
- (CGFloat)width;
/// 控件高度
- (CGFloat)height;

/// 控件中心x坐标
- (CGFloat)centerX;
/// 控件中心y坐标
- (CGFloat)centerY;
/// 控件x轴最大值坐标
- (CGFloat)maxX;
/// 控件y轴最大坐标
- (CGFloat)maxY;

/// 控件坐标
- (CGPoint)origin;
/// 控件尺寸
- (CGSize)size;


#pragma mark - Setter
/// 设置x坐标
- (void)setX: (CGFloat)x;
/// 设置y坐标
- (void)setY: (CGFloat)y;
/// 设置宽度
- (void)setWidth: (CGFloat)width;
/// 设置高度
- (void)setHeight: (CGFloat)height;
/// 设置中心x坐标
- (void)setCenterX: (CGFloat)centerX;
/// 设置中心y坐标
- (void)setCenterY: (CGFloat)centerY;

/// 设置尺寸
- (void)setSize: (CGSize)size;
/// 设置坐标
- (void)setOrigin: (CGPoint)origin;

@end
