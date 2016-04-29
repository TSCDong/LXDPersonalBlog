//
//  LXDRoundButton.m
//  LXDPersonalBlog
//
//  Created by linxinda on 16/1/23.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "LXDRoundButton.h"

@implementation LXDRoundButton

+ (instancetype)roundButtonWithFrame: (CGRect)frame image: (NSString *)image target: (id)target action: (SEL)action tag: (NSInteger)tag alpha: (CGFloat)alpha
{
    LXDRoundButton * roundButton = [[LXDRoundButton alloc] initWithFrame: frame image: image target: target action: action];
    roundButton.alpha = alpha;
    roundButton.tag = tag;
    return roundButton;
}

- (instancetype)initWithFrame: (CGRect)frame
                        image: (NSString *)image
                       target: (id)target
                       action: (SEL)action
{
    if (self = [super initWithFrame: frame]) {
        if (image) {
            [self setImage: kImageNamed(image) forState: UIControlStateNormal];
        }
        if (action && target) {
            [self addTarget: target action: action forControlEvents: UIControlEventTouchUpInside];
        }
    }
    return self;
}

- (BOOL)pointInside: (CGPoint)point withEvent: (UIEvent *)event
{
    CGFloat radius = self.width / 2;
    return sqrt((point.x - radius) * (point.x - radius) + (point.y - radius) * (point.y - radius)) <= radius;
}

- (void)animateWithOffset: (CGPoint)offset duration: (CGFloat)duration alpha: (CGFloat)alpha
{
    [UIView animateWithDuration: duration delay: 0 options: UIViewAnimationOptionCurveEaseIn animations: ^{
        self.alpha = alpha;
        CGPoint center = self.center;
        center.x += offset.x;
        center.y += offset.y;
        self.center = center;
    } completion: nil];
}


@end
