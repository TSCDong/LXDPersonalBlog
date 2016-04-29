//
//  LXDGroupCell.m
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/1/20.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "LXDGroupCell.h"
#import "LXDSnapView.h"

@implementation LXDGroupCell

/// 从nib中加载成功的时候设置边缘遮盖
- (void)awakeFromNib
{
    _categoryLabel.layer.masksToBounds = YES;
}

/// 视图重新布局的时候设置圆角
- (void)layoutSubviews
{
    [super layoutSubviews];
    _categoryLabel.layer.cornerRadius = self.width / 3;
}

/// 截取当前状态视图
- (UIView *)snapCurrentState
{
    LXDSnapView * snapView = [[LXDSnapView alloc] initWithFrame: self.bounds];
    snapView.backgroundColor = [UIColor clearColor];
    
    UILabel * label = [[UILabel alloc] initWithFrame: _categoryLabel.frame];
    label.textAlignment = _categoryLabel.textAlignment;
    label.textColor = _categoryLabel.textColor;
    label.text = _categoryLabel.text;
    label.font = _categoryLabel.font;
    
    label.layer.cornerRadius = _categoryLabel.layer.cornerRadius;
    label.backgroundColor = _categoryLabel.backgroundColor;
    label.clipsToBounds = YES;
    snapView.touchRect = label.frame;
    
    [snapView addSubview: label];
    return snapView;
}


@end
