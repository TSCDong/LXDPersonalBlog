//
//  LXDSnapView.m
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/1/20.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "LXDSnapView.h"

@implementation LXDSnapView

- (instancetype)initWithFrame: (CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (CGRect)touchRect
{
    if (CGRectIsNull(_touchRect)) {
        return self.bounds;
    }
    return _touchRect;
}

- (BOOL)pointInside: (CGPoint)point withEvent: (UIEvent *)event
{
    CGFloat radius = _touchRect.size.width / 2;
    CGPoint center = { CGRectGetMidX(_touchRect), CGRectGetMidY(_touchRect) };
    CGFloat distance = sqrt((point.x - center.x) * (point.x - center.x) + (point.y - center.y) * (point.y - center.y));
    return distance <= radius;
}


@end
