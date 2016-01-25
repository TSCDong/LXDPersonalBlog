//
//  LXDRefreshView.h
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/1/18.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXDRefreshView;
@protocol LXDRefreshViewDelegate <NSObject>

@optional
- (void)refreshViewStartRefresh: (LXDRefreshView *)refreshView;

@end

/**
 *  仿qq下拉刷新控件
 */
@interface LXDRefreshView : UIView

/// 监听的滚动视图
@property (nonatomic, weak) UIScrollView * scrollView;
/// 代理人
@property (nonatomic, weak) id<LXDRefreshViewDelegate> delegate;

/// 使用滚动视图创建下拉刷新控件
+ (instancetype)refreshViewWithScrollView: (UIScrollView *)scrollView;
/// 释放监听
- (void)free;
/// 停止刷新
- (void)endRefreshing;

@end
