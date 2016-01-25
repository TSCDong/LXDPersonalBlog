//
//  LXDAlphaNavigationController.h
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/1/12.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 透明导航栏高度发生改变时发出通知
extern NSString * LXDNavigationBarHeightDidChangeNotification;

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
