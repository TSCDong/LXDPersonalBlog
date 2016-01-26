//
//  LXDAlphaNavigationController.m
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/1/12.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "LXDAlphaNavigationController.h"

NSString * const LXDNavigationBarHeightDidChangeNotification = @"LXDNavigationBarHeightDidChangeNotification";
NSString * const LXDClickNavigationBarNotification = @"LXDClickNavigationBarNotification";

@interface LXDAlphaNavigationController ()

/// 背景颜色视图
@property (nonatomic, strong) UIView * backgroundView;

@end

@implementation LXDAlphaNavigationController

#pragma mark - Init
/// 使用控制器创建导航控制器
- (instancetype)initWithRootViewController: (UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController: rootViewController]) {
        [self commonInit];
    }
    return self;
}

/// 从IB控件中初始化构造器
- (instancetype)initWithCoder: (NSCoder *)aDecoder
{
    if (self = [super initWithCoder: aDecoder]) {
        [self commonInit];
    }
    return self;
}

/// 封装共同的初始化代码
- (void)commonInit
{
    UIImage * alphaImage = kImageNamed(@"nav_alpha_image");
    [self.navigationBar setBackgroundImage: alphaImage forBarMetrics: UIBarMetricsCompact];
    self.navigationBar.layer.masksToBounds = YES;
    [self.navigationBar addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(clickNavigationBar)]];
    
    [self.view insertSubview: self.backgroundView belowSubview: self.navigationBar];
    [self.navigationBar setTitleTextAttributes: @{
                                                  NSForegroundColorAttributeName: [UIColor whiteColor]
                                                  }];
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}


#pragma mark - Event
/// 点击导航栏回调
- (void)clickNavigationBar
{
    [[NSNotificationCenter defaultCenter] postNotificationName: LXDClickNavigationBarNotification object: self];
}


#pragma mark - Getter
/// 获取当前导航栏最大y轴值
- (CGFloat)navigationBarMaxY
{
    return _backgroundView.maxY;
}

/// 设置导航栏背景颜色
- (void)setBackgroundColor: (UIColor *)backgroundColor
{
    _backgroundView.backgroundColor = backgroundColor;
}


#pragma mark - Setter
/// 设置导航栏透明度
- (void)setAlpha: (CGFloat)alpha
{
    self.backgroundView.alpha = MAX(0, MIN(1, alpha));
}


#pragma mark - Lazy load
/// 懒加载背景视图
- (UIView *)backgroundView
{
    if (!_backgroundView) {
        CGRect navBarFrame = self.navigationBar.frame;
        CGFloat statusHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
        navBarFrame.size.height += statusHeight;
        
        _backgroundView = [[UIView alloc] initWithFrame: navBarFrame];
        _backgroundView.backgroundColor = LXD_MAIN_COLOR;
    }
    return _backgroundView;
}


#pragma mark - View life
/// 视图完成加载
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear: (BOOL)animated
{
    [super viewDidAppear: animated];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(listenStatusHeightDidChange:) name: UIApplicationDidChangeStatusBarFrameNotification object: nil];
}

/// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

/// 移除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}


#pragma mark - Notification
/// 监听状态栏高度变化并改变背景图层的高度
- (void)listenStatusHeightDidChange: (NSNotification *)notification
{
    CGRect statusFrame = [notification.userInfo[UIApplicationStatusBarFrameUserInfoKey] CGRectValue];
    CGFloat height = self.navigationBar.height + statusFrame.size.height;
    self.backgroundView.height = height;
    [[NSNotificationCenter defaultCenter] postNotificationName: LXDNavigationBarHeightDidChangeNotification object: self userInfo: nil];
}


@end
