//
//  LXDArticleController.m
//  LXDPersonalBlog
//
//  Created by linxinda on 16/1/17.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "LXDArticleController.h"
#import "LXDArticle.h"
#import "MBProgressHUD.h"
#import "LXDRoundButton.h"
#import "LXDAlphaNavigationController.h"

/// 博客页面需要遮住的高度
#define MASK_HEIGHT 44
/// 分享按钮计算额外的tag
#define LXD_SHARE_BASE_TAG (1 << 7)
/// 菜单旋转动画关键key
#define LXD_ROTATION_ANIMATION_KEY @"rotationAnimation"

/// 菜单按钮当前状态
typedef NS_ENUM(NSInteger, LXDMenuState)
{
    LXDMenuStateClose = -1,
    LXDMenuStateOpen = 1,
};

/// 第三方分享类型
typedef NS_ENUM(NSInteger, LXDShareType)
{
    LXDShareTypeSina = LXD_SHARE_BASE_TAG + 1,
    LXDShareTypeFriend = LXD_SHARE_BASE_TAG + 2,
    LXDShareTypeWechat = LXD_SHARE_BASE_TAG + 3,
    LXDShareTypeCollect = LXD_SHARE_BASE_TAG + 4,
};

@interface LXDArticleController ()<UIWebViewDelegate, UIScrollViewDelegate>

@property (assign, nonatomic) CGFloat barMaxY;
@property (assign, atomic) LXDMenuState menuState;

@property (strong, nonatomic) UIView * maskView;
@property (strong, nonatomic) UILabel * titleLabel;

@property (strong, nonatomic) LXDRoundButton * menu;
@property (strong, nonatomic) LXDRoundButton * collect;
@property (strong, nonatomic) LXDRoundButton * sinaShare;
@property (strong, nonatomic) LXDRoundButton * friendShare;
@property (strong, nonatomic) LXDRoundButton * collectShare;
@property (strong, nonatomic) LXDRoundButton * wechatShare;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation LXDArticleController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInit];
    [self setupNavigationBar];
}

- (void)viewWillAppear: (BOOL)animated
{
    [super viewWillAppear: animated];
    [self setupNavigationBarHeight];
}

- (void)viewDidAppear: (BOOL)animated
{
    [super viewDidAppear: animated];
    [_webView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: [NSString stringWithFormat: @"%@%@", LXDBlogAddress, _article.href]]]];
    _webView.scrollView.delegate = self;
    [_webView.scrollView addSubview: self.maskView];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(listenStatusHeightDidChange:) name: LXDNavigationBarHeightDidChangeNotification object: nil];
}

- (void)viewWillDisappear: (BOOL)animated
{
    MBHUDHIDE
    [super viewWillDisappear: animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    _webView.delegate = nil;
    [_webView loadHTMLString:@"" baseURL:nil];
    [_webView stopLoading];
    [_webView removeFromSuperview];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}


#pragma mark - Setup
/// 配置自身成员参数
- (void)setupInit
{
    self.title = _article.title;
    self.menuState = LXDMenuStateClose;
}

/// 配置导航栏相关数据高度（状态栏可能高度会有变化）
- (void)setupNavigationBarHeight
{
    LXDAlphaNavigationController * alphaController = (LXDAlphaNavigationController *)self.navigationController;
    CGFloat height = alphaController.navigationBarMaxY;
    
    _barMaxY = height;
    _topConstraint.constant = -height;
    _webView.scrollView.contentInset = UIEdgeInsetsMake(height - MASK_HEIGHT, 0, 0, 0);
}

/// 配置导航栏返回按钮
- (void)setupNavigationBar
{
    LXDAlphaNavigationController * alphaController = (LXDAlphaNavigationController *)self.navigationController;
    [alphaController setAlpha: 0];
    [alphaController setBackgroundColor: LXD_MAIN_COLOR];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage: kImageNamed(@"nav_icon_back") style: UIBarButtonItemStylePlain target: self action: @selector(dismissedViewController)];
}


#pragma mark - Web view delegate
/// webView传入新链接时回调
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    MBHUDSHOW
    webView.userInteractionEnabled = NO;
    return YES;
}

/// 完成网页加载时清空部分数据避免内存耗费过大
- (void)webViewDidFinishLoad: (UIWebView *)webView
{
    webView.userInteractionEnabled = YES;
    MBHUDHIDE
    [self.view insertSubview: self.menu aboveSubview: webView];
    NSLog(@"finish load article href");
    [[NSUserDefaults standardUserDefaults] setInteger: 0 forKey: @"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool: NO forKey: @"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool: NO forKey: @"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 网页加载失败
- (void)webView: (UIWebView *)webView didFailLoadWithError: (NSError *)error
{
    webView.userInteractionEnabled = YES;
    MBHUDHIDE
    NSLog(@"无法打开博客链接：%@", error);
}


#pragma mark - Scroll view delegate
/// 用户滚动视图时
- (void)scrollViewDidScroll: (UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y - _webView.scrollView.contentInset.top;
    CGFloat alpha = offset / _barMaxY / 1.5;
    LXDAlphaNavigationController * alphaController = (LXDAlphaNavigationController *)self.navigationController;
    alphaController.alpha = alpha;
}


#pragma mark - Event
/// 返回上一级控制器
- (void)dismissedViewController
{
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
}

const CGFloat rotateDuration = 0.3;
/// 显示其他功能菜单栏
- (void)openMenuList: (LXDRoundButton *)menu
{
    self.menuState == LXDMenuStateClose ? [self showMenu] : [self hideMenu];
}

/// 点击分享到其他app
- (void)shareArticle: (LXDRoundButton *)share
{
    [self hideMenu];
}


#pragma mark - Animation
/// 显示分享菜单
- (void)showMenu
{
    [_menu.layer addAnimation: [self animationWithKeyPath: [NSString stringWithFormat: LXD_ROTATE_KEY]
                                                 toValue: @(M_PI * 2 * self.menuState)
                                                duration: rotateDuration
                                      timingFunctionName: kCAMediaTimingFunctionEaseOut]
                      forKey: LXD_ROTATION_ANIMATION_KEY];
    [self animateMenu: [NSString stringWithFormat: @"article_close"] shareAlpha: 1];
    self.menuState = LXDMenuStateOpen;
}

/// 隐藏分享菜单
- (void)hideMenu
{
    [_menu.layer addAnimation: [self animationWithKeyPath: [NSString stringWithFormat: LXD_ROTATE_KEY]
                                                  toValue: @(M_PI * 2 * self.menuState)
                                                 duration: rotateDuration
                                       timingFunctionName: kCAMediaTimingFunctionEaseOut]
                       forKey: LXD_ROTATION_ANIMATION_KEY];
    [self animateMenu: [NSString stringWithFormat: @"article_menu"] shareAlpha: 0];
    self.menuState = LXDMenuStateClose;
}

/// 抽离菜单动画
- (void)animateMenu: (NSString *)imageName shareAlpha: (CGFloat)shareAlpha
{
    [UIView transitionWithView: _menu duration: rotateDuration options: UIViewAnimationOptionTransitionNone animations: ^{
        [_menu setImage: kImageNamed(imageName) forState: UIControlStateNormal];
    } completion: nil];
    [self animateMenuWithAlpha: shareAlpha];
}

/// 显示分享菜单
- (void)animateMenuWithAlpha: (CGFloat)alpha
{
    const CGFloat spacing = 8;
    const CGFloat wechatOffset = ceil((_menu.height + spacing) * _menuState);
    const CGFloat friendOffset = ceil((_menu.height + spacing) * 2 * _menuState);
    const CGFloat sinaOffset = ceil((_menu.height + spacing) * 3 * _menuState);
    const CGFloat collectOffset = ceil((_menu.height + spacing) * 4 * _menuState);
    
    [self.collectShare animateWithOffset: (CGPoint){ 0, collectOffset } duration: rotateDuration alpha: alpha];
    [self.wechatShare animateWithOffset: (CGPoint){ 0, wechatOffset } duration: rotateDuration alpha: alpha];
    [self.friendShare animateWithOffset: (CGPoint){ 0, friendOffset } duration: rotateDuration alpha: alpha];
    [self.sinaShare animateWithOffset: (CGPoint){ 0, sinaOffset } duration: rotateDuration alpha: alpha];
}


#pragma mark - Notification
/// 状态栏高度变化时回调
- (void)listenStatusHeightDidChange: (NSNotification *)notification
{
    LXDAlphaNavigationController * alphaController = (LXDAlphaNavigationController *)self.navigationController;
    CGFloat height = alphaController.navigationBarMaxY;
    _topConstraint.constant = height;
    _webView.scrollView.contentInset = UIEdgeInsetsMake(height - MASK_HEIGHT, 0, 0, 0);
    _barMaxY = height;
}


#pragma mark - Getter
/// 创建旋转动画
- (CABasicAnimation *)animationWithKeyPath: (NSString *)keyPath toValue: (NSValue *)toValue duration: (CGFloat)duration timingFunctionName: (NSString *)timingFunctionName
{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath: keyPath];
    
    animation.toValue = toValue;
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: timingFunctionName];
    
    return animation;
}

/// 遮盖网页上面的返回菜单
- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.width, MASK_HEIGHT)];
        _maskView.backgroundColor = _webView.backgroundColor;
    }
    return _maskView;
}

/// 控制器标题
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
    }
    return _titleLabel;
}

/// 懒加载菜单按钮
- (LXDRoundButton *)menu
{
    if (!_menu) {
        _menu = [[LXDRoundButton alloc] initWithFrame: CGRectMake(self.view.maxX - 80, self.view.maxY - 80, 40, 40) image: [NSString stringWithFormat: @"article_menu"] target: self action: @selector(openMenuList:)];
        _menu.layer.shadowColor = [UIColor colorWithWhite: 0.3 alpha: 0.8].CGColor;
        _menu.layer.shadowOffset = CGSizeZero;
        _menu.layer.shadowOpacity = 1;
    }
    return _menu;
}

/// 收藏按钮
- (LXDRoundButton *)collectShare
{
    if (_collectShare) { return _collectShare; }
    
    _collectShare = [LXDRoundButton roundButtonWithFrame: self.menu.frame image: [NSString stringWithFormat: @"share_collect"] target: self action: @selector(shareArticle:) tag: LXDShareTypeSina alpha: 0];
    [self.view insertSubview: _collectShare belowSubview: self.sinaShare];
    return _collectShare;
}

/// 新浪微博分享按钮
- (LXDRoundButton *)sinaShare
{
    if (_sinaShare) { return _sinaShare; }
    
    _sinaShare = [LXDRoundButton roundButtonWithFrame: self.menu.frame image: [NSString stringWithFormat: @"share_sina"] target: self action: @selector(shareArticle:) tag: LXDShareTypeSina alpha: 0];
    [self.view insertSubview: _sinaShare belowSubview: self.friendShare];
    return _sinaShare;
}

/// 朋友圈分享按钮
- (LXDRoundButton *)friendShare
{
    if (_friendShare) { return _friendShare; }
    
    _friendShare = [LXDRoundButton roundButtonWithFrame: self.menu.frame image: [NSString stringWithFormat: @"share_friend"] target: self action: @selector(shareArticle:) tag: LXDShareTypeFriend alpha: 0];
    [self.view insertSubview: _friendShare belowSubview: self.wechatShare];
    return _friendShare;
}

/// 微信分享按钮
- (LXDRoundButton *)wechatShare
{
    if (_wechatShare) { return _wechatShare; }
    
    _wechatShare = [LXDRoundButton roundButtonWithFrame: self.menu.frame image: [NSString stringWithFormat: @"share_wechat"] target: self action: @selector(shareArticle:) tag: LXDShareTypeSina alpha: 0];
    [self.view insertSubview: _wechatShare belowSubview: self.menu];
    return _wechatShare;
}


@end
