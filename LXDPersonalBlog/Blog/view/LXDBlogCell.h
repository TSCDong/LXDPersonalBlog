//
//  LXDArticleCell.h
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/1/12.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 文章内容简介字体
LXD_EXPORT NSString const * const LXDContentFontName;

@class LXDArticle;
/**
 *  博客单元格
 */
@interface LXDBlogCell : UITableViewCell

/// 当前显示的文章数据模型
@property (nonatomic, readonly, strong) LXDArticle * article;

/// 显示对应的文章内容
- (void)showArticle: (LXDArticle *)article;

/// 文章简介字体
+ (UIFont *)contentFont;


@end
