//
//  LXDBlogController.m
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/1/12.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "LXDBlogController.h"
#import "LXDArticle.h"
#import "LXDBlogCell.h"
#import "LXDRefreshView.h"
#import "LXDPopAnimation.h"
#import "LXDPushAnimation.h"
#import "LXDArticleManager.h"
#import "NSArray+LXDFilter.h"
#import "LXDArticleOperator.h"
#import "LXDArticleController.h"
#import "LXDAlphaNavigationController.h"
#import <objc/runtime.h>



#pragma mark - LXDBlogController实现
/// ==========================================================
/// blogController实现以及分类
/// ==========================================================
@interface LXDBlogController ()<UIViewControllerTransitioningDelegate, LXDArticleManagerDelegate, LXDRefreshViewDelegate>

@property (nonatomic, strong) NSArray * articleList;                                ///<    文章列表
@property (nonatomic, strong) LXDRefreshView * refreshView;               ///<     刷新视图
@property (strong) LXDArticleManager * articleManager;                       ///<      文章管理对象

@end


@implementation LXDBlogController


#pragma mark View life
- (void)viewDidLoad {
    [super viewDidLoad];
    self.articleManager.delegate = self;
    [LXDArticleOperator requestBlogArticles];
}

- (void)viewWillAppear: (BOOL)animated
{
    [super viewWillAppear: animated];
    self.title = [NSString stringWithFormat: @"博客"];
    if (_articleManager.allArticles.count == 0) {
        MBHUDSHOW
    }
}

- (void)viewDidAppear: (BOOL)animated
{
    [super viewDidAppear: animated];
    self.refreshView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(notificationToScrollToTop) name: LXDClickNavigationBarNotification object: nil];
}

- (void)viewWillDisappear: (BOOL)animated
{
    [super viewWillDisappear: animated];
    MBHUDHIDE
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_refreshView free];
}


#pragma mark Notification
/// 接收点击导航栏的通知并让tableView滚动到顶部
- (void)notificationToScrollToTop
{
    CGPoint topPoint = { -self.tableView.contentInset.left, -self.tableView.contentInset.top };
    [self.tableView setContentOffset: topPoint animated: YES];
}


#pragma mark Getter
/// 懒加载刷新视图
- (LXDRefreshView *)refreshView
{
    return _refreshView ?: ( _refreshView = [LXDRefreshView refreshViewWithScrollView: self.tableView] );
}

/// 懒加载文章管理对象
- (LXDArticleManager *)articleManager
{
    return _articleManager ?: ( _articleManager = [LXDArticleManager sharedManager] );
}


#pragma mark LXDArticleManagerDelegate
/// 文章更新回调
- (void)articleManagerUpdateArticles: (LXDArticleManager *)articleManager
{
    NSLog(@"call back and update acticles");
    [_refreshView endRefreshing];
    if (_articleManager.isUpdate) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBHUDHIDE
            [self.tableView reloadData];
        });
    }
}


#pragma mark LXDRefreshViewDelegate
/// 刷新视图触发刷新回调
- (void)refreshViewStartRefresh:(LXDRefreshView *)refreshView
{
    [LXDArticleOperator requestBlogArticles];
}


@end











#pragma mark - TableView相关协议类别扩展
/// ==========================================================
/// blogController类别实现TableView相关协议
/// ==========================================================

/// 复用单元格id
static NSString * const reuseIdentifier = @"articleCell";

/// 存储单元格高度的数组
static FORCE_INLINE NSMutableArray<NSNumber *> * kCellHeights() {
    static NSMutableArray<NSNumber *> * cellHeights;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        cellHeights = @[].mutableCopy;
    });
    return cellHeights;
}

@implementation LXDBlogController (LXDTableViewProtocol)

#pragma mark <UITableViewDataSource>
static NSMutableString * displayTimes;
- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section {
    [self resetDisplayTimes: displayTimes];
    return self.articleManager.allArticles.count;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath {
    LXDBlogCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseIdentifier];
    LXDArticle * article = [self.articleManager.allArticles objectAtIndex: indexPath.row];
    [cell showArticle: article];
    
    return cell;
}


#pragma mark <UITableViewDelegate>
/// 单元格动画效果
- (void)tableView: (UITableView *)tableView willDisplayCell: (UITableViewCell *)cell forRowAtIndexPath: (NSIndexPath *)indexPath
{
    CGRect frame = cell.frame;
    NSTimeInterval duration = [self timeIntervalForDisplayCell: cell atIndexPath: indexPath];
    if (duration == 0.) { return; }
    
    NSTimeInterval delay = [self delayForDisplayCell: cell atIndexPath: indexPath];
    [UIView animateWithDuration: duration delay: delay options: UIViewAnimationOptionCurveEaseOut animations: ^{
        cell.frame = frame;
    } completion: nil];
}

/// 预估单元格高度，减少计算量
- (CGFloat)tableView: (UITableView *)tableView estimatedHeightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return 360.;
}

/// 动态计算单元格高度
- (CGFloat)tableView: (UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    NSMutableArray<NSNumber *> * cellHeights = kCellHeights();
    if (indexPath.row < cellHeights.count) { return cellHeights[indexPath.row].doubleValue; }
    
    /// 计算高度并存储
    LXDArticle * article = self.articleManager.allArticles[indexPath.row];
    CGFloat contentHeight = [LXDBlogCell heightWithContent: article.content];
    contentHeight = [self scaleContentHeight: contentHeight];
    
    [cellHeights addObject: @(contentHeight)];
    return contentHeight;
}

/// 点击文章列表跳转文章详细内容
- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    LXDArticle * article = [self.articleManager.allArticles objectAtIndex: indexPath.row];
    
    /// 创建博客文章展示控制器并传入文章地址
    LXDArticleController * articleController = [[LXDArticleController alloc] initWithArticle: article];
    LXDAlphaNavigationController * alphaController = [[LXDAlphaNavigationController alloc] initWithRootViewController: articleController];
    alphaController.transitioningDelegate = self;
    [self.navigationController presentViewController: alphaController animated: YES completion: nil];
}


#pragma mark Tool
static CGFloat duration = 0.4;
/// 获取cell出现时的动画时长
- (NSTimeInterval)timeIntervalForDisplayCell: (UITableViewCell *)cell atIndexPath: (NSIndexPath *)indexPath
{
    if ([displayTimes characterAtIndex: indexPath.row] != '0') { return 0; }
    else if (indexPath.row >= 2) { return 0; }
    
    CGRect startFrame = CGRectOffset(cell.frame, 0, LXD_SCREEN_HEIGHT);
    cell.frame = startFrame;
    [displayTimes replaceCharactersInRange: NSMakeRange(indexPath.row, 1) withString: @"1"];
    return duration;
}

/// 获取cell动画的延时时间
- (NSTimeInterval)delayForDisplayCell: (UITableViewCell *)cell atIndexPath: (NSIndexPath *)indexPath
{
    return duration * indexPath.row;
}

/// 获取不同屏幕下单元格的尺寸大小比例
- (CGFloat)contentScale
{
    if (LXD_SCALE_4_7 < 1) {
        return 0.95;
    } else if (LXD_SCALE_4_7 > 1) {
        return 1.05; }
    return 1;
}

/// 重置动画实现记录
- (void)resetDisplayTimes: (NSMutableString *)records
{
    records = @"".mutableCopy;
    for (int idx = 0; idx < self.articleManager.allArticles.count; idx++) {
        [records appendFormat: @"0"];
    }
}

/// 根据屏幕尺寸调整单元格高度计算并且向上取整
- (CGFloat)scaleContentHeight: (CGFloat)contentHeight
{
    return ceil(contentHeight * self.contentScale);
}


@end







#pragma mark - 转场动画实现类别扩展
/// ==========================================================
/// blogController转场动画实现
/// ==========================================================
@implementation LXDBlogController (LXDTransitioningProtocol)


#pragma mark <UIViewControllerTransitioningDelegate>
/// 返回present的转场动画对象
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController: (UIViewController *)presented presentingController: (UIViewController *)presenting sourceController: (UIViewController *)source
{
    return [LXDPushAnimation new];
}

/// 返回dismiss的转场动画对象
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController: (UIViewController *)dismissed
{
    return [LXDPopAnimation new];
}


@end


