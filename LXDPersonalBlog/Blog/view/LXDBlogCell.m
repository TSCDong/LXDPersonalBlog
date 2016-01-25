//
//  LXDBlogCell.m
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/1/12.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "LXDBlogCell.h"
#import "LXDArticle.h"
#import "UIFont+LXDAdjustFont.h"
#import "UIImage+LXDRoundRectImage.h"

NSString const * const LXDContentFontName = @"Menlo-Regular";

/// 获取用户头像
static inline UIImage * kAuthorImage() {
    static UIImage * authorImage;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        UIImage * image = kImageNamed(@"article_author");
        authorImage = [UIImage imageOfRoundRectWithImage: image size: CGSizeMake(30, 30) radius:15];
    });
    return authorImage.copy;
}

@interface LXDBlogCell ()

/// 垂直分割线高度约束
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *separateConstraint;
/// 水平分割线
@property (strong, nonatomic) UIView * singleLine;
/// 文章标题
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
/// 文章内容
@property (strong, nonatomic) IBOutlet UILabel *content;
/// 文章分类
@property (strong, nonatomic) IBOutlet UILabel *articleCategory;
/// 写作时间
@property (strong, nonatomic) IBOutlet UILabel *writeTime;
/// 作者头像
@property (strong, nonatomic) IBOutlet UIImageView *authorImageView;

@end


@implementation LXDBlogCell

/// 从nib中加载
- (instancetype)initWithCoder: (NSCoder *)aDecoder
{
    if (self = [super initWithCoder: aDecoder]) {
        [self addSubview: self.singleLine];
    }
    return self;
}

/// 控件关联属性完成
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupFont];
    _content.layer.drawsAsynchronously = YES;
    _writeTime.layer.drawsAsynchronously = YES;
    _articleCategory.layer.drawsAsynchronously = YES;
    self.authorImageView.image = kAuthorImage();
    const CGFloat standardHeight = 20;
    self.separateConstraint.constant = standardHeight * LXD_SCALE_4_7;
}

/// 显示对应的文章内容
- (void)showArticle: (LXDArticle *)article
{
    _article = article;
    _titleLabel.text = article.title;
    _content.text = article.content;
    _articleCategory.text = [NSString stringWithFormat: @"Sindri Lin on %@", article.category];
    _writeTime.text = article.dateTime;
    
    _content.width = LXD_SCREEN_WIDTH - 50;
    [_content sizeToFit];
    [_articleCategory sizeToFit];
    [_writeTime sizeToFit];
    
    _content.frame = CGRectIntegral(_content.frame);
    _articleCategory.frame = CGRectIntegral(_articleCategory.frame);
    _writeTime.frame = CGRectIntegral(_writeTime.frame);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat singleLineOffset = ((1 / [UIScreen mainScreen].scale) / 2);
    self.singleLine.y = self.titleLabel.maxY + 10 + singleLineOffset;
}

/// 文章简介内容
+ (UIFont *)contentFont
{
    return [UIFont adjustFontWithName: LXDContentFontName.copy size: 16.5];
}


#pragma mark - Setup
/// 根据屏幕尺寸比例调整字体大小
- (void)setupFont
{
    _content.font = [LXDBlogCell contentFont];
    _titleLabel.font = [UIFont adjustFontWithName: @"LaoSangamMN" size: 25];
    _articleCategory.font = _writeTime.font = [UIFont adjustFontWithName: @"Palatino-Roman" size: 16];
}


#pragma mark - Getter
/// 单线条
- (UIView *)singleLine
{
    if (!_singleLine) {
        _singleLine = [[UIView alloc] initWithFrame: CGRectMake(20, 0, LXD_SCREEN_WIDTH - 40, 1 / [UIScreen mainScreen].scale)];
        _singleLine.backgroundColor = [UIColor colorWithWhite: 0.7 alpha: 1];
    }
    return _singleLine;
}


@end
