//
//  LXDArticleCompiler.m
//  LXDPersonalBlog
//
//  Created by linxinda on 16/1/12.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "LXDArticleCompiler.h"
#import "LXDArticle.h"
#import "NSString+LXDVaild.h"
#import "NSArray+LXDFilter.h"

/// 定义关键字属性
NSString * const LXDArticleListKey = @"LXDArticleListKey";

@implementation LXDArticleCompiler

/// 解析html数据
+ (void)analyseWithHTMLStr: (NSString *)html completeHandler: (LXDCommonHandler)completeHandler
{
    NSString * separateString = [NSString stringWithFormat: @"post-header"];
    html = [self filterMainContentInHTML: html];
    NSArray * components = [html componentsSeparatedByString: separateString];
    NSArray * filterArray = [components filterObjectsWithSelector: @selector(validContainChinese)];
    if (!filterArray) {
        if (completeHandler) { completeHandler(self, LXDStatusFailed, nil); }
    }
    
    NSMutableArray * articles = @[].mutableCopy;
    [filterArray enumerateObjectsUsingBlock: ^(NSString *  _Nonnull html, NSUInteger idx, BOOL * _Nonnull stop) {
        LXDArticle * article = [[LXDArticle alloc] initWithHTML: html];
        [articles addObject: article];
    }];
    if (completeHandler) {
        completeHandler(self, LXDStatusSuccess, @{ LXDArticleListKey: articles });
    }
}

/// 获取html数据中的主要内容数据
+ (NSString *)filterMainContentInHTML: (NSString *)html
{
    NSRange range = [html rangeOfString: [NSString stringWithFormat: @"<main"]];
    if (range.location == NSNotFound) { return html; }
    
    NSString * result = [html substringFromIndex: range.location];
    range = [result rangeOfString: [NSString stringWithFormat: @"main>"]];
    if (range.location == NSNotFound) { return result; }
    result = [result substringToIndex: range.location];
    
    return result;
}


@end
