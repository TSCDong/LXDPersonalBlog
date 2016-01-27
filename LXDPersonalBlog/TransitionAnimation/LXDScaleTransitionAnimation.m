//
//  LXDScaleTransitionAnimation.m
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/1/27.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "LXDScaleTransitionAnimation.h"

@implementation LXDScaleTransitionAnimation
{
    id<UIViewControllerContextTransitioning> _transitionContext;
    CALayer * _maskLayer;
}

- (NSTimeInterval)transitionDuration: (id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.transitionType == LXDTransitionTypeJump ? 0.3 : 0.35;
}

- (void)animateTransition: (id<UIViewControllerContextTransitioning>)transitionContext
{
    [super animateTransition: transitionContext transitionInfo: ^(UIViewController *toVC, UIViewController *fromVC, UIView *containerView) {
        _transitionContext = transitionContext;
        if (self.transitionType == LXDTransitionTypeJump) {
            [self jumpAnimationWithToVC: toVC fromVC: fromVC containerView: containerView transitionContext: transitionContext];
        } else {
            [self backAnimationWithToVC: toVC fromVC: fromVC containerView: containerView transitionContext: transitionContext];
        }
    }];
}

/// 跳入动画
- (void)jumpAnimationWithToVC: (UIViewController *)toVC
                      fromVC: (UIViewController *)fromVC
               containerView: (UIView *)containerView
           transitionContext: (id<UIViewControllerContextTransitioning>)transitionContext
{
    CGRect finalRect = [transitionContext finalFrameForViewController: toVC];
    UIBezierPath * startPath = [self maskPathOnTargetController: fromVC finalRect: finalRect];
    _maskLayer = [self maskLayerWithTargetController: toVC startPath: startPath.CGPath];
    UIBezierPath * endPath = [UIBezierPath bezierPathWithRect: finalRect];
    
    [containerView addSubview: toVC.view];
    [self maskAnimationWithStartPath: (id)startPath.CGPath endPath: (id)endPath.CGPath animatedLayer: _maskLayer duration: [self transitionDuration: transitionContext] keyPath: [NSString stringWithFormat: @"path"]];
}

/// 返回动画
- (void)backAnimationWithToVC: (UIViewController *)toVC
                      fromVC: (UIViewController *)fromVC
               containerView: (UIView *)containerView
           transitionContext: (id<UIViewControllerContextTransitioning>)transitionContext
{
    CGRect finalRect = [transitionContext finalFrameForViewController: toVC];
    UIBezierPath * startPath = [UIBezierPath bezierPathWithRect: finalRect];
    _maskLayer = [self maskLayerWithTargetController: fromVC startPath: startPath.CGPath];
    UIBezierPath * endPath = [self maskPathOnTargetController: fromVC finalRect: finalRect];
    
    [containerView insertSubview: toVC.view belowSubview: fromVC.view];
    [self maskAnimationWithStartPath: (id)startPath.CGPath endPath: (id)endPath.CGPath animatedLayer: _maskLayer duration: [self transitionDuration: transitionContext] keyPath: [NSString stringWithFormat: @"path"]];
}


#pragma mark - Getter
/// 获取蒙版路径动画对象
- (void)maskAnimationWithStartPath: (id)startPath endPath: (id)endPath animatedLayer: (CALayer *)animatedLayer duration: (CFTimeInterval)duration keyPath: (NSString *)keyPath
{
    CABasicAnimation * maskAnimation = [CABasicAnimation animationWithKeyPath: keyPath];
    maskAnimation.fromValue = startPath;
    maskAnimation.toValue = endPath;
    maskAnimation.duration = duration;
    maskAnimation.delegate = self;
    maskAnimation.removedOnCompletion = NO;
    maskAnimation.fillMode = kCAFillModeForwards;
    [animatedLayer addAnimation: maskAnimation forKey: keyPath];
}

/// 获取转场动画中的蒙版路径
- (UIBezierPath *)maskPathOnTargetController: (UIViewController *)targetController finalRect: (CGRect)finalRect
{
    if ([targetController respondsToSelector: @selector(prefixControllerMaskPath)]) {
        return [((id<LXDScaleTransitionAnimationDelegate>)targetController) prefixControllerMaskPath];
    }
    else {
        return [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMidX(finalRect), CGRectGetMidY(finalRect), 1, 1)];
    }
}

/// 获取转场动画中的蒙版图层
- (CAShapeLayer *)maskLayerWithTargetController: (UIViewController *)targetController startPath: (CGPathRef)startPath
{
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    targetController.view.layer.mask = maskLayer;
    maskLayer.path = startPath;
    return maskLayer;
}


#pragma mark - CAAnimationDelegate
/// 转场动画结束回调
- (void)animationDidStop: (CAAnimation *)anim finished: (BOOL)flag
{
    [super animateTransition: _transitionContext transitionInfo: ^(UIViewController *toVC, UIViewController *fromVC, UIView *containerView) {
        toVC.view.layer.mask = nil;
        fromVC.view.layer.mask = nil;
        _maskLayer = nil;
        [_transitionContext completeTransition: ![_transitionContext transitionWasCancelled]];
    }];
}


@end
