//
//  LXDGroupArticleCell.m
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/1/20.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "LXDGroupArticleCell.h"
#import "LXDArticle.h"
#import "UIFont+LXDAdjustFont.h"

@interface LXDGroupArticleCell ()

@property (strong, nonatomic) IBOutlet UILabel *articleTitle;
@property (strong, nonatomic) IBOutlet UILabel *writeTime;

@end

@implementation LXDGroupArticleCell

/// 从nib加载成功适配字体大小
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.articleTitle.font = [UIFont adjustFontWithName: @"Optima-Bold" size: 19];
    self.writeTime.font = [UIFont adjustFontWithName: @"Palatino-Roman" size: 16];
}

/// 显示文章标题时间
- (void)showArticle: (LXDArticle *)article
{
    self.articleTitle.text = article.title;
    self.writeTime.text = article.dateTime;
}

- (void)cellWillDisplay
{
    _articleTitle.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView animateWithDuration: 0.8 delay: 0 usingSpringWithDamping: 0.25 initialSpringVelocity: 0 options: UIViewAnimationOptionCurveEaseInOut animations: ^{
        _articleTitle.transform = CGAffineTransformIdentity;
    } completion: nil];
}


@end
