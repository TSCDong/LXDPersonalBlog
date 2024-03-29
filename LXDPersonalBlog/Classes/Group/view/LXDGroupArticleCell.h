//
//  LXDGroupArticleCell.h
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/1/20.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXDArticle;

/**
 *  筛选后的文章单元格
 */
@interface LXDGroupArticleCell : UITableViewCell

- (void)showArticle: (LXDArticle *)article;

/*!
 *  @brief 在cell将要显示的时候调用显示动画
 */
- (void)cellWillDisplay;

@end
