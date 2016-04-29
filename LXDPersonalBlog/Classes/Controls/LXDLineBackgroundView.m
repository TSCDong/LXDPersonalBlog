//
//  LXDLineBackgroundView.m
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/4/29.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "LXDLineBackgroundView.h"
#import "UIColor+LXDNumberToColor.h"
#import "UILabel+LXDDesignedInitializer.h"


@interface LXDLineBackgroundView ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * containerView;

@end


@implementation LXDLineBackgroundView

- (instancetype)initWithFrame: (CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        self.clipsToBounds = YES;
        self.containerView = [[UIView alloc] init];
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel = [UILabel labelWithFrame: self.bounds alignment: NSTextAlignmentCenter];
        [self addSubview: self.containerView];
        [self addSubview: self.titleLabel];
        
        UIView * singleLine = [[UIView alloc] initWithFrame: CGRectMake(0, self.height - 1, self.width, 1)];
        singleLine.backgroundColor = [UIColor colorWithWhite: 0.5 alpha: 0.6];
        [self addSubview: singleLine];
    }
    return self;
}

- (void)setAttributeText: (NSAttributedString *)attributeText
{
    NSMutableAttributedString * mAttributed = [[NSMutableAttributedString alloc] initWithAttributedString: attributeText];
    NSInteger colorIndex = attributeText.length / 3;
    [mAttributed addAttributes: @{ NSForegroundColorAttributeName: [UIColor colorWithRGBNumber: 0xF03E39 alpha: 0.9] } range: NSMakeRange(colorIndex, 1)];
//    self.titleLabel.text = attributeText.string;
    self.titleLabel.attributedText = mAttributed;
}

- (void)buildView
{
    if (self.lineGap < 0 && self.lineWidth < 0) { return; }
    CGFloat width = self.width;
    CGFloat height = self.height;
    CGFloat lineHeight = width + height;
    
    self.containerView.frame = CGRectMake(0, 0, lineHeight, lineHeight);
    self.containerView.center = CGPointMake(width / 2, height / 2);
    NSInteger lineCount = lineHeight / (_lineGap + _lineWidth);
    for (NSInteger idx = 0; idx < lineCount; idx++) {
        UIView * line = [[UIView alloc] initWithFrame: CGRectMake(idx * (_lineWidth + _lineGap), 0, _lineWidth, lineHeight)];
        line.backgroundColor = _lineColor ?: [UIColor blackColor];
        [self.containerView addSubview: line];
    }
    self.containerView.transform = CGAffineTransformMakeRotation(M_PI / 180 * 45);
}

+ (instancetype)createViewWithFrame: (CGRect)frame lineWidth: (CGFloat)width lineGap: (CGFloat)lineGap lineColor: (UIColor *)color
{
    LXDLineBackgroundView * bgView = [[LXDLineBackgroundView alloc] initWithFrame: frame];
    bgView.lineColor = color;
    bgView.lineWidth = width;
    bgView.lineGap = lineGap;
    [bgView buildView];
    return bgView;
}


@end
