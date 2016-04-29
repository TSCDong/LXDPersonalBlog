//
//  MC_PopAnimation.m
//  Matches
//
//  Created by 林欣达 on 15/12/16.
//  Copyright © 2015年 matches.com. All rights reserved.
//

#import "LXDNavigationTransitionAnimation.h"

@implementation LXDNavigationTransitionAnimation

- (NSTimeInterval)transitionDuration: (id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.transitionType == LXDTransitionTypeJump ? 0.3 : 0.35;
}

- (void)animateTransition: (id<UIViewControllerContextTransitioning>)transitionContext
{
    [super animateTransition: transitionContext transitionInfo: ^(UIViewController *toVC, UIViewController *fromVC, UIView *containerView) {
        if (self.transitionType == LXDTransitionTypeJump) {
            [self pushAnimationWithToVC: toVC fromVC: fromVC containerView: containerView transitionContext: transitionContext];
        } else {
            [self popAnimationWithToVC: toVC fromVC: fromVC containerView: containerView transitionContext: transitionContext];
        }
    }];
}

/// push动画
- (void)pushAnimationWithToVC: (UIViewController *)toVC
                       fromVC: (UIViewController *)fromVC
                containerView: (UIView *)containerView
            transitionContext: (id<UIViewControllerContextTransitioning>)transitionContext
{
    CGRect finalRect = [transitionContext finalFrameForViewController: toVC];
    toVC.view.frame = CGRectMake(CGRectGetWidth(finalRect), 0, CGRectGetWidth(finalRect), CGRectGetHeight(finalRect));
    [containerView addSubview: toVC.view];
    
    [UIView animateWithDuration: [self transitionDuration: transitionContext] delay: 0 options: UIViewAnimationOptionCurveEaseIn animations: ^{
        toVC.view.frame = finalRect;
        fromVC.view.frame = CGRectMake(-CGRectGetWidth(finalRect), 0, CGRectGetWidth(finalRect), CGRectGetHeight(finalRect));
    } completion: ^(BOOL finished) {
        [transitionContext completeTransition: ![transitionContext transitionWasCancelled]];
    }];
}

/// pop动画
- (void)popAnimationWithToVC: (UIViewController *)toVC
                       fromVC: (UIViewController *)fromVC
                containerView: (UIView *)containerView
            transitionContext: (id<UIViewControllerContextTransitioning>)transitionContext
{
    CGRect finalRect = [transitionContext finalFrameForViewController: toVC];
    toVC.view.frame = finalRect;
    [containerView insertSubview: toVC.view belowSubview: fromVC.view];
    
    [UIView animateWithDuration: [self transitionDuration: transitionContext] delay: 0 options: UIViewAnimationOptionCurveEaseOut animations: ^{
        fromVC.view.frame = CGRectOffset(finalRect, CGRectGetWidth(finalRect), 0);
    } completion: ^(BOOL finished) {
        [transitionContext completeTransition: ![transitionContext transitionWasCancelled]];
    }];
}


@end
