//
//  LXDLineBackgroundView.h
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/4/29.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 *  @brief 斜线的背景图层
 */
@interface LXDLineBackgroundView : UIView

@property (nonatomic, assign) CGFloat lineGap;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor * lineColor;

- (void)buildView;
- (void)setAttributeText: (NSAttributedString *)attributeText;
+ (instancetype)createViewWithFrame: (CGRect)frame lineWidth: (CGFloat)width lineGap: (CGFloat)lineGap lineColor: (UIColor *)color;

@end
