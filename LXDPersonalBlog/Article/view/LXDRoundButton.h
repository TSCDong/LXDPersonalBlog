//
//  LXDRoundButton.h
//  LXDPersonalBlog
//
//  Created by linxinda on 16/1/23.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  圆形按钮。限制点击范围
 */
@interface LXDRoundButton : UIButton

+ (instancetype)roundButtonWithFrame: (CGRect)frame image: (NSString *)image target: (id)target action: (SEL)action tag: (NSInteger)tag alpha: (CGFloat)alpha;

- (instancetype)initWithFrame: (CGRect)frame
                        image: (NSString *)image
                       target: (id)target
                       action: (SEL)action;

/// 让按钮进行偏移动画
- (void)animateWithOffset: (CGPoint)offset duration: (CGFloat)duration alpha: (CGFloat)alpha;

@end
