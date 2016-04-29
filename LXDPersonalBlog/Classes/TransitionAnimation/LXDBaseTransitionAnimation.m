//
//  LXDBaseTransitionAnimation.m
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/1/27.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "LXDBaseTransitionAnimation.h"

@implementation LXDBaseTransitionAnimation

- (instancetype)init
{
    return [self initWithTransitionType: LXDTransitionTypeJump];
}

- (instancetype)initWithTransitionType: (LXDTransitionType)transitionType
{
    if (self = [super init]) {
        _transitionType = transitionType;
    }
    return self;
}

- (void)animateTransition: (id<UIViewControllerContextTransitioning>)transitionContext transitionInfo: (LXDTransitionUsableValue)transitionInfo
{
    UIViewController * fromVC = [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
    UIViewController * toVC = [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
    UIView * containerView = [transitionContext containerView];
    if (transitionInfo) { transitionInfo(toVC, fromVC, containerView); }
}


#pragma mark - <UIViewControllerAnimatedTransitioning>
- (NSTimeInterval)transitionDuration: (id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition: (id<UIViewControllerContextTransitioning>)transitionContext
{
    
}


@end
