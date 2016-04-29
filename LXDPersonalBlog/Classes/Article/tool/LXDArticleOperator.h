//
//  LXDArticleOperator.h
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/1/18.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  博客文章操作对象
 */
@interface LXDArticleOperator : NSObject

/// 请求并解析博客文章
+ (void)requestBlogArticles;

@end
