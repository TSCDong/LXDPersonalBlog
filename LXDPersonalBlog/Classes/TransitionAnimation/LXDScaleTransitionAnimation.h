//
//  LXDScaleTransitionAnimation.h
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/1/27.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "LXDBaseTransitionAnimation.h"

@protocol LXDScaleTransitionAnimationDelegate <NSObject>

@optional
/// 获取跳转关系上一级控制器的蒙版路径
- (UIBezierPath *)prefixControllerMaskPath;

@end

/**
 *  形变蒙版转场动画
 */
@interface LXDScaleTransitionAnimation : LXDBaseTransitionAnimation

@end
