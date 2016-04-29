//
//  LXDArticleController.h
//  LXDPersonalBlog
//
//  Created by linxinda on 16/1/17.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXDArticle;
/**
 *  博客文章显示控制器
 */
@interface LXDArticleController : UIViewController

/// 文章数据
@property (nonatomic, strong) LXDArticle * article;
/// 构造器
- (instancetype)initWithArticle: (LXDArticle *)article;

@end
