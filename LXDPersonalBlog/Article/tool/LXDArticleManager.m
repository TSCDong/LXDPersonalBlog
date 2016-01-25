//
//  LXDArticleManager.m
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/1/12.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "LXDArticleManager.h"
#import "LXDArticle.h"
#import "NSArray+LXDFilter.h"

/// 单例对象
static LXDArticleManager * articleManager = nil;

NSString * const LXDFinishedRequestNotification = @"LXDFinishedRequestNotification";

@interface LXDArticleManager ()

@property (strong, nonatomic) NSArray * articles;
@property (copy, nonatomic) NSArray<NSString *> * categories;

@end

@implementation LXDArticleManager


#pragma mark - Initializer
/// 获取管理者单例
+ (instancetype)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        articleManager = [[super allocWithZone: NSDefaultMallocZone()] init];
    });
    return articleManager;
}


#pragma mark - Override
/// 重写copy实现返回单例对象
- (instancetype)copyWithZone: (NSZone *)zone
{
    return [LXDArticleManager sharedManager];
}

/// 重写内存分配返回单例对象
+ (instancetype)allocWithZone: (struct _NSZone *)zone
{
    return [LXDArticleManager sharedManager];
}


#pragma mark - Operate
/// 插入新文章
- (void)updateArticles: (NSArray *)articles
{
    if ( (_isUpdate = (_articles.count != articles.count)) ) {
        _articles = articles;
        NSMutableArray * categories = @[].mutableCopy;
        for (LXDArticle * article in articles) {
            if (![categories containsObject: article.category]) {
                [categories addObject: article.category];
            }
        }
        self.categories = categories;
    }
    if ([_delegate respondsToSelector: @selector(updateArticle:)]) {
        [_delegate updateArticle: self];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName: LXDFinishedRequestNotification object: self];
}

#pragma mark - Getter
/// 懒加载
- (NSArray *)articles
{
    return _articles ?: (_articles = [NSArray array]);
}

/// 获取所有文章
- (NSArray *)allArticles
{
    return _articles;
}

/// 根据类型获取文章。筛选后的文章数组以LXDArticleListKey存储在userInfo中
- (void)articlesWithCategory: (NSString *)category completion: (LXDCommonHandler)completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray * categoryArticles = [_articles filterObjectsWithKeyPath: @"category" compareObject: category];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) { completion(self, LXDStatusSuccess, @{ LXDArticleListKey: categoryArticles }); }
        });
    });
}

/// 获取文章所有分类
- (NSArray<NSString *> *)allCategories
{
    return _categories;
}

/// 重写getter方法
- (BOOL)isUpdate
{
    BOOL isUpdate = _isUpdate;
    if (isUpdate) { _isUpdate = NO; }
    return isUpdate;
}


@end
