//
//  LineBackgroundView.h
//  LineBackgroundView
//
//  Created by XianMingYou on 15/3/4.
//
//  https://github.com/YouXianMing
//  http://www.cnblogs.com/YouXianMing/
//

#import <UIKit/UIKit.h>

@interface LineBackgroundView : UIView

@property (nonatomic, assign) CGFloat lineGap;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor * lineColor;

- (void)buildView;
+ (instancetype)createViewWithFrame: (CGRect)frame lineWidth: (CGFloat)width lineGap: (CGFloat)lineGap lineColor: (UIColor *)color;

@end
