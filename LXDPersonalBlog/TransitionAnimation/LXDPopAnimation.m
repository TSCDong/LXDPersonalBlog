//
//  MC_PopAnimation.m
//  Matches
//
//  Created by 林欣达 on 15/12/16.
//  Copyright © 2015年 matches.com. All rights reserved.
//

#import "LXDPopAnimation.h"

@implementation LXDPopAnimation

- (CGFloat)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController * fromVC = [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
    UIViewController * toVC = [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
    UIView * containerView = [transitionContext containerView];
    containerView.backgroundColor = [UIColor whiteColor];
    
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
