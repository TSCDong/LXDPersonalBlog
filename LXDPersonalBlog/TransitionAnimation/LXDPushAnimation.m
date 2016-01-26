//
//  MC_PushAnimation.m
//  Matches
//
//  Created by 林欣达 on 15/12/16.
//  Copyright © 2015年 matches.com. All rights reserved.
//

#import "LXDPushAnimation.h"

@implementation LXDPushAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.35;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController * fromVC = [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
    UIViewController * toVC = [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
    UIView * containerView = [transitionContext containerView];
    containerView.backgroundColor = [UIColor whiteColor];
    
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


@end
