//
//  LXDArticleOperator.m
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/1/18.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "LXDArticleOperator.h"
#import "LXDBlogRequester.h"
#import "LXDArticleCompiler.h"
#import "LXDArticleManager.h"

@implementation LXDArticleOperator

/// 请求并解析博客文章
+ (void)requestBlogArticles
{
    [LXDBlogRequester requestBlog: LXDBlogAddress.copy completeHandler: ^(id object, NSInteger status, NSDictionary *userInfo) {
        if (status == LXDStatusSuccess) {
            [self analyseHTML: userInfo[LXDRequestHTMLKey]];
        }
    }];
}

/// 将html转换成文章数据模型
+ (void)analyseHTML: (NSString *)html
{
    [LXDArticleCompiler analyseWithHTMLStr: html completeHandler: ^(id object, NSInteger status, NSDictionary *userInfo) {
        if (status == LXDStatusSuccess) {
            NSArray * articles = userInfo[LXDArticleListKey];
            [[LXDArticleManager sharedManager] updateArticles: articles];
        }
    }];
}

@end
