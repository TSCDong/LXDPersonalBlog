//
//  LXDGroupController.m
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/1/20.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "LXDGroupController.h"
#import "LXDArticle.h"
#import "LXDGroupCell.h"
#import "LXDRefreshView.h"
#import "LXDPopAnimation.h"
#import "LXDPushAnimation.h"
#import "LXDArticleManager.h"
#import "LXDArticleOperator.h"
#import "LXDGroupArticleCell.h"
#import "LXDArticleController.h"
#import "UIColor+LXDNumberToColor.h"
#import "LXDAlphaNavigationController.h"

static NSString * const kCategoryCellIdentifier = @"categoryCell";      ///<    类别单元格复用id
static NSString * const kArticleCellIdentifier = @"articleCell";            ///<    筛选文章复用id
static const CGFloat kArticleCellHeight = 85.;

@interface LXDGroupController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIViewControllerTransitioningDelegate, LXDRefreshViewDelegate>

/// 点击cell后保存坐标位置
@property (assign, nonatomic) CGPoint originCenter;
/// 保存上一次筛选的分类
@property (copy, nonatomic) NSString * lastCategory;
/// 筛选后的文章列表
@property (strong, nonatomic) NSArray * filterArticles;

/// 文章列表视图
@property (strong, nonatomic) IBOutlet UITableView *tableView;
/// 文章分类视图
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

/// 单击手势
@property (nonatomic, strong) UITapGestureRecognizer * tap;
/// 文章管理对象
@property (nonatomic, strong) LXDArticleManager * manager;
/// 下拉刷新视图
@property (nonatomic, strong) LXDRefreshView * refresh;
/// 选中的类型
@property (nonatomic, strong) UIView * categoryView;
/// 主色调
@property (nonatomic, strong) UIColor * mainColor;

@end

@implementation LXDGroupController


#pragma mark - View life
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat: @"分类"];
}

- (void)viewWillAppear: (BOOL)animated
{
    [super viewWillAppear: animated];
    if (self.manager.allArticles == nil) {
        MBHUDSHOW
    }
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(articleFinishRequest) name: LXDFinishedRequestNotification object: nil];
}

- (void)viewDidAppear: (BOOL)animated
{
    [super viewDidAppear: animated];
    [self setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [_refresh free];
}


#pragma mark - Notification
/// 文章完成请求
- (void)articleFinishRequest
{
    NSLog(@"notification call back");
    dispatch_async(dispatch_get_main_queue(), ^{
        MBHUDHIDE
        [self.collectionView reloadData];
        [_refresh endRefreshing];
    });
}


#pragma mark - Setup
/// 配置tableView
- (void)setupTableView
{
    CGFloat bottomHeight = 0.;
    UITabBarController * rootController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootController isKindOfClass: [UITabBarController class]]) {
        bottomHeight = CGRectGetHeight(rootController.tabBar.frame);
    }
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, bottomHeight, 0);
    self.refresh.delegate = self;
}


#pragma mark - Getter
/// 懒加载单击手势
- (UITapGestureRecognizer *)tap
{
    return _tap ?: (_tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(recoverySubviews)]);
}

- (LXDRefreshView *)refresh
{
    if (!_refresh) {
        _refresh = [LXDRefreshView refreshViewWithScrollView: self.tableView];
    }
    return _refresh;
}

/// 懒加载主色调
- (UIColor *)mainColor
{
    if (_mainColor) { return _mainColor; }
    
    NSArray * colors = @[
                         [UIColor colorWithRGBNumber: 0xEB6655],
                         [UIColor colorWithRGBNumber: 0xF8B841],
                         [UIColor colorWithRGBNumber: 0x179FD1],
                         ];
    _mainColor = colors[arc4random() % arc4random() % arc4random() % colors.count];
    return _mainColor;
}

/// 懒加载管理对象
- (LXDArticleManager *)manager
{
    return _manager ?: (_manager = [LXDArticleManager sharedManager]);
}

/// 获取cell的相对控制器坐标系的截图view
- (UIView *)relativeSnapViewWithCell: (LXDGroupCell *)cell
{
    UIView * snapView = [cell snapCurrentState];
    CGPoint center = cell.center;
    center.x -= (self.collectionView.contentOffset.x - self.collectionView.x);
    center.y -= (self.collectionView.contentOffset.y - self.collectionView.y);
    snapView.center = center;
    _originCenter = center;
    return snapView;
}


#pragma mark - Setter
/// 获取筛选文章后刷新数据源并显示
- (void)setFilterArticles: (NSArray *)filterArticles
{
    self.tableView.alpha = 1;
    _filterArticles = filterArticles;
    [self.tableView reloadData];
}


#pragma mark - Animate
/// 还原动画
- (void)recoverySubviews
{
    [UIView animateWithDuration: 0.15 animations: ^{
        self.tableView.alpha = 0;
    } completion: ^(BOOL finished) {
        self.tableView.contentOffset = CGPointZero;
    }];
    
    [UIView animateWithDuration: 0.3 delay: 0 usingSpringWithDamping: 0.6 initialSpringVelocity: 0 options: UIViewAnimationOptionCurveEaseInOut animations: ^{
        _categoryView.center = _originCenter;
    } completion: ^(BOOL finished) {
        
        [UIView animateWithDuration: 0.25 animations: ^{
            self.collectionView.alpha = 1;
        } completion: ^(BOOL finished) {
            [_categoryView removeFromSuperview];
        }];
    }];
}

/// 开始显示分类列表的动画
- (void)showCategoryArticlesWithAnimation: (UIView *)snapView category: (NSString *)category
{
    CGPoint endCenter = CGPointMake(self.collectionView.maxX - snapView.width / 2, self.collectionView.maxY - snapView.height);
    
    [UIView animateWithDuration: 0.3 delay: 0 usingSpringWithDamping: 0.6 initialSpringVelocity: 0 options: UIViewAnimationOptionCurveEaseOut animations: ^{
        snapView.center = endCenter;
    } completion: ^(BOOL finished) {
        [snapView addGestureRecognizer: self.tap];
        if ([category isEqualToString: _lastCategory]) {
            self.tableView.alpha = 1;
        } else {
            [self.manager articlesWithCategory: category completion: ^(id object, NSInteger status, NSDictionary *userInfo) {
                self.filterArticles = userInfo[LXDArticleListKey];
            }];
        }
    }];
}


#pragma mark - <UICollectionViewDelegate>
/// 单元格开始渲染时出现弹跳动画
- (void)collectionView: (UICollectionView *)collectionView willDisplayCell: (UICollectionViewCell *)cell forItemAtIndexPath: (NSIndexPath *)indexPath
{
    CGPoint center = cell.center;
    CGPoint startCenter = center;
    startCenter.y += LXD_SCREEN_HEIGHT;
    cell.center = startCenter;
    
    [UIView animateWithDuration: 0.5 delay: 0.35 * indexPath.item usingSpringWithDamping: 0.6 initialSpringVelocity: 0 options: UIViewAnimationOptionCurveLinear animations: ^{
        cell.center = center;
    } completion: nil];
}

/// 点击分类显示动画
- (void)collectionView: (UICollectionView *)collectionView didSelectItemAtIndexPath: (NSIndexPath *)indexPath
{
    LXDGroupCell * cell = (LXDGroupCell *)[collectionView cellForItemAtIndexPath: indexPath];
    [self.categoryView removeFromSuperview];
    self.categoryView = [self relativeSnapViewWithCell: cell];
    [self.view addSubview: self.categoryView];
    
    [UIView animateWithDuration: 0.2 animations: ^{
        collectionView.alpha = 0;
    } completion: ^(BOOL finished) {
        [self showCategoryArticlesWithAnimation: _categoryView category: self.manager.allCategories[indexPath.item]];
    }];
}


#pragma mark - <UICollectionViewDataSource>
/// 返回分类单元格个数
- (NSInteger)collectionView: (UICollectionView *)collectionView numberOfItemsInSection: (NSInteger)section
{
    return self.manager.allCategories.count;
}

/// 显示分类单元格
- (UICollectionViewCell *)collectionView: (UICollectionView *)collectionView cellForItemAtIndexPath: (NSIndexPath *)indexPath
{
    LXDGroupCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier: kCategoryCellIdentifier forIndexPath: indexPath];
    cell.categoryLabel.backgroundColor = self.mainColor;
    cell.categoryLabel.text = self.manager.allCategories[indexPath.row];
    
    return cell;
}


#pragma mark - <UITableViewDelegate>
static NSMutableString * displayTime;
/// 文章显示动画效果
- (void)tableView: (UITableView *)tableView willDisplayCell: (UITableViewCell *)cell forRowAtIndexPath: (NSIndexPath *)indexPath
{
    if ([displayTime characterAtIndex: indexPath.row] != '0') { return; }
    CGFloat duration = 0.2;
    NSInteger topIndex = floor(tableView.contentOffset.y / kArticleCellHeight);
    CGFloat delay = (indexPath.row - topIndex) * duration;
    for (NSInteger idx = topIndex; idx < indexPath.row; idx++) {
        if ([displayTime characterAtIndex: idx] != '0') {
            delay -= duration;
        }
    }
    
    CGFloat centerX = cell.centerX;
    cell.centerX = -LXD_SCREEN_WIDTH;
    [UIView animateWithDuration: duration delay: delay usingSpringWithDamping: .6 initialSpringVelocity: .5 options: UIViewAnimationOptionCurveEaseInOut animations: ^{
        cell.centerX = centerX;
    } completion: ^(BOOL finished) {
        [displayTime replaceCharactersInRange: NSMakeRange(indexPath.row, 1) withString: @"1"];
    }];
}

/// 返回单元格高度
- (CGFloat)tableView: (UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return kArticleCellHeight;
}

/// 点击文章跳转到文章webView
- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    LXDArticle * article = [self.filterArticles objectAtIndex: indexPath.row];
    
    /// 创建博客文章展示控制器并传入文章地址
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName: [NSString stringWithFormat: @"Main"] bundle: nil];
    LXDArticleController * articleController = [storyboard instantiateViewControllerWithIdentifier: [NSString stringWithFormat: @"articleController"]];
    articleController.article = article;
    
    /// 创建透明导航栏并跳转
    LXDAlphaNavigationController * alphaController = [[LXDAlphaNavigationController alloc] initWithRootViewController: articleController];
    alphaController.transitioningDelegate = self;
    [self.navigationController presentViewController: alphaController animated: YES completion: nil];
}


#pragma mark - <UITableViewDataSource>
/// 返回类别文章数量
- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section
{
    displayTime = @"".mutableCopy;
    for (int idx = 0; idx < self.filterArticles.count; idx++) {
        [displayTime appendFormat: @"0"];
    }
    return self.filterArticles.count;
}

/// 返回文章单元格
- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    LXDGroupArticleCell * cell = [tableView dequeueReusableCellWithIdentifier: kArticleCellIdentifier];
    [cell showArticle: self.filterArticles[indexPath.row]];
    return cell;
}


#pragma mark - <UIViewControllerTransitioningDelegate>
/// push转场动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController: (UIViewController *)presented presentingController: (UIViewController *)presenting sourceController: (UIViewController *)source
{
    return [LXDPushAnimation new];
}

/// pop转场动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController: (UIViewController *)dismissed
{
    return [LXDPopAnimation new];
}


#pragma mark - LXDRefreshViewDelegate
/// 刷新视图触发刷新回调
- (void)refreshViewStartRefresh:(LXDRefreshView *)refreshView
{
    [LXDArticleOperator requestBlogArticles];
}


@end
