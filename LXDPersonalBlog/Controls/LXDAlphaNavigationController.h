//
//  LXDAlphaNavigationController.h
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/1/12.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 透明导航栏高度发生改变时发出通知
LXD_EXPORT NSString * const LXDNavigationBarHeightDidChangeNotification;
/// 用户点击导航栏时发出通知，可用于实现点击导航栏滚动回顶部
LXD_EXPORT NSString * const LXDClickNavigationBarNotification;

/**
 *  透明导航栏
 */
@interface LXDAlphaNavigationController : UINavigationController

/// 设置导航栏透明度
- (void)setAlpha: (CGFloat)alpha;
/// 设置导航栏背景颜色
- (void)setBackgroundColor: (UIColor *)backgroundColor;
/// 返回导航栏当前最高y轴
- (CGFloat)navigationBarMaxY;

@end
