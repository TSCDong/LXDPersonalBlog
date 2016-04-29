//
//  LXDArticleManager.h
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/1/12.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 文章请求完成后发出通知
FOUNDATION_EXPORT NSString * const LXDFinishedRequestNotification;

@class LXDArticleManager;
@protocol LXDArticleManagerDelegate <NSObject>

@optional
/// 当博客文章更新时回调
- (void)articleManagerUpdateArticles: (LXDArticleManager *)articleManager;

@end

/**
 *  博客文章管理单例
 */
@interface LXDArticleManager : NSObject<NSCopying>

/// 文章更新后回调
@property (nonatomic, assign) id<LXDArticleManagerDelegate> delegate;
/// 是否需要刷新
@property (nonatomic, assign) BOOL isUpdate;

/// 获取文章管理对象单例
+ (instancetype)sharedManager;
/// 获取所有文章
- (NSArray *)allArticles;
/// 文章所有分类
- (NSArray<NSString *> *)allCategories;

/// 插入新文章
- (void)updateArticles: (NSArray *)articles;
/// 根据类型获取文章。筛选后的文章数组以LXDArticleListKey存储在userInfo中
- (void)articlesWithCategory: (NSString *)category completion: (LXDCommonHandler)completion;

@end
