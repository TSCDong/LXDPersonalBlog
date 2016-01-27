//
//  LXDBaseTransitionAnimation.h
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/1/27.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 控制器跳转类型
typedef NS_ENUM(NSInteger, LXDTransitionType) {
    LXDTransitionTypeJump,              ///<    跳转动画
    LXDTransitionTypeBack               ///<     返回动画
};

/// 通过block返回转场动画需要的值
typedef void(^LXDTransitionUsableValue)(UIViewController * toVC, UIViewController * fromVC, UIView * containerView);

/**
 *  转场动画基类
 */
@interface LXDBaseTransitionAnimation : NSObject<UIViewControllerAnimatedTransitioning>

/// 跳转动画类型
@property (nonatomic, assign) LXDTransitionType transitionType;

/// 构造器
- (instancetype)initWithTransitionType: (LXDTransitionType)transitionType;

/// 子类调用父类这个方法获取跳转中的相关数据
- (void)animateTransition: (id<UIViewControllerContextTransitioning>)transitionContext transitionInfo: (LXDTransitionUsableValue)transitionInfo;

@end
