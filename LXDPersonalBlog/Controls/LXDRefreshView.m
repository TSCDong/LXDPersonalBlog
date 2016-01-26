//
//  LXDRefreshView.m
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/1/18.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "LXDRefreshView.h"

/// 监听的key值
#define LXD_OBSERVE_KEY @"contentOffset"
/// 隐藏刷新视图默认时长
#define LXD_HIDE_DURATION 0.25
/// 形变的最小比例
#define LXD_MIN_SCALE 0.3
/// 形变的最大比例
#define LXD_MAX_SCALE 0.75

/// 初始化高度
#define LXD_INIT_HEIGHT 60.
/// 开始刷新最高偏移
#define LXD_REFRESH_HEIGHT 120.


typedef NS_ENUM(NSInteger, LXDRefreshState)
{
    LXDRefreshStateNormal,
    LXDRefreshStateReady,
    LXDRefreshStateRefreshing,
};


static inline CGFloat kAngleToArc(CGFloat angle) {
    return angle * (M_PI / 180.);
}

static inline CGPoint LXDPointOffset(CGPoint point, CGFloat xOffset, CGFloat yOffset) {
    return CGPointMake(point.x + xOffset, point.y + yOffset);
}


@interface LXDRefreshView ()

@property (nonatomic, assign) CGFloat initWidth;
@property (nonatomic, assign) CGFloat insetsTop;
@property (nonatomic, assign) LXDRefreshState state;

@property (nonatomic, strong) UIButton * success;
@property (nonatomic, strong) CAShapeLayer * circleLayer;
@property (nonatomic, strong) UIImageView * refreshImageView;
@property (nonatomic, strong) UIActivityIndicatorView * activityView;

@end

@implementation LXDRefreshView


#pragma mark - Public
+ (instancetype)refreshViewWithScrollView: (UIScrollView *)scrollView
{
    LXDRefreshView * refreshView = [[LXDRefreshView alloc] init];
    refreshView.scrollView = scrollView;
    return refreshView;
}

/// 释放监听
- (void)free
{
    [_scrollView removeObserver: self forKeyPath: LXD_OBSERVE_KEY];
}

/// 结束刷新动画
- (void)endRefreshing
{
    if (_state == LXDRefreshStateRefreshing) {
        _state = LXDRefreshStateNormal;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self animateStop];
            [self animateToRecoverySubviews];
        });
    }
}

/// 开始刷新
- (void)startRefresh
{
    _circleLayer.opacity = 0;
    _refreshImageView.alpha = 0;
    _state = LXDRefreshStateRefreshing;
    [self animateStart];
    
    UIEdgeInsets insets = _scrollView.contentInset;
    insets.top = LXD_INIT_HEIGHT + _insetsTop;
    _scrollView.contentInset = insets;
    
    if (_scrollView.contentOffset.y > _scrollView.contentInset.top) {
        [_scrollView setContentOffset: (CGPoint){ 0, -_scrollView.contentInset.top } animated: YES];
    }
}


#pragma mark - Initializer
- (instancetype)init
{
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame: (CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder: (NSCoder *)aDecoder
{
    if (self = [super initWithCoder: aDecoder]) {
        [self commonInit];
    }
    return self;
}

/// 通用的控件初始化
- (void)commonInit
{
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.userInteractionEnabled = NO;
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    [self addSubview: self.activityView];
}

/// 控件重新布局时刷新
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.refreshImageView.center = CGPointMake(self.centerX, LXD_INIT_HEIGHT / 2);
    _activityView.center = _refreshImageView.center;
}


#pragma mark - Getter
/// 懒加载准备刷新控件
- (UIImageView *)refreshImageView
{
    if (!_refreshImageView) {
        _refreshImageView = [[UIImageView alloc] initWithImage: kImageNamed(@"ready_refresh_icon")];
        _refreshImageView.center = CGPointMake(self.centerX, LXD_INIT_HEIGHT / 2);
    }
    return _refreshImageView;
}

/// 懒加载水滴背景图层
- (CAShapeLayer *)circleLayer
{
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.frame = self.bounds;
        _initWidth = CGRectGetWidth(self.refreshImageView.frame) + 12;
        
        _circleLayer.path = [UIBezierPath bezierPathWithArcCenter: _refreshImageView.center radius: _initWidth / 2 startAngle: kAngleToArc(0) endAngle: kAngleToArc(360) clockwise: YES].CGPath;
        _circleLayer.fillColor = [UIColor lightGrayColor].CGColor;
        _circleLayer.strokeColor = [UIColor grayColor].CGColor;
        _circleLayer.lineWidth = 1 / [UIScreen mainScreen].scale;
        _circleLayer.shadowColor = [UIColor grayColor].CGColor;
        _circleLayer.shadowOpacity = 0.7;
        _circleLayer.shadowOffset = CGSizeMake(0, 2);
    }
    return _circleLayer;
}

/// 停止刷新之后显示刷新成功
- (UIButton *)success
{
    if (!_success) {
        _success = [[UIButton alloc] initWithFrame: (CGRect){ 0, 0, self.width, LXD_INIT_HEIGHT }];
        [_success setImage: kImageNamed(@"refresh_success") forState: UIControlStateNormal];
        [_success setTitle: @"  刷新成功" forState: UIControlStateNormal];
        [_success setTitleColor: [UIColor colorWithRed: 77/255. green: 77/255. blue: 77/255. alpha: 1] forState: UIControlStateNormal];
        _success.titleLabel.font = [UIFont fontWithName: @"Palatino-Roman" size: 16 * LXD_SCALE_4_7];
        _success.alpha = 0;
        [self addSubview: _success];
    }
    return _success;
}


#pragma mark - Setter
/// 重写setter，监听scrollView滚动
- (void)setScrollView: (UIScrollView *)scrollView
{
    if (_scrollView) {
        [self removeFromSuperview];
        [self free];
    }
    CGRect frame = CGRectMake(0, -(LXD_INIT_HEIGHT - _insetsTop), CGRectGetWidth(scrollView.frame), LXD_INIT_HEIGHT);
    self.frame = frame;
    [scrollView addSubview: self];
    _scrollView = scrollView;
    _insetsTop = scrollView.contentInset.top;
    
    [self.layer addSublayer: self.circleLayer];
    [self addSubview: self.refreshImageView];
    [scrollView addObserver: self forKeyPath: LXD_OBSERVE_KEY options: NSKeyValueObservingOptionNew + NSKeyValueObservingOptionOld context: nil];
}


#pragma mark - Observer
/// 当scrollView发生滚动的时候回调
- (void)observeValueForKeyPath: (NSString *)keyPath ofObject: (id)object change: (NSDictionary<NSString *,id> *)change context: (void *)context
{
    CGFloat offset = _scrollView.contentOffset.y + _insetsTop;
    if (offset > 0) { return; }
    
    offset = ABS(offset);
    if (offset < LXD_INIT_HEIGHT) {
        if (_state == LXDRefreshStateReady) {
            [self startRefresh];
            if ([_delegate respondsToSelector: @selector(refreshViewStartRefresh:)]) {
                [_delegate refreshViewStartRefresh: self];
            }
        }
    }
    
    else {
        self.height = offset;
        self.y = -offset;
        CGFloat scale = (offset - LXD_INIT_HEIGHT) / (LXD_REFRESH_HEIGHT - LXD_INIT_HEIGHT);
        
        _circleLayer.path = [self animateToScaleWater: scale];
        [self animateToShowRefresh: scale offset: offset];
    }
}


#pragma mark - Animate
/// 对控件进行形变展示下拉刷新效果
- (void)animateToShowRefresh: (CGFloat)scale offset: (CGFloat)offset
{
    scale = 1 - MAX(0, MIN(1, scale)) * LXD_MIN_SCALE;
    _refreshImageView.layer.transform = CATransform3DMakeScale(scale, scale, 1);
    if (offset >= LXD_REFRESH_HEIGHT) {
        _state = LXDRefreshStateReady;
        [UIView animateWithDuration: 0.08 animations: ^{
            _refreshImageView.alpha = 0;
            _circleLayer.opacity = 0;
        } completion: ^(BOOL finished) {
            [self animateStart];
        }];
    }
}

/// 制作水滴形变动画
- (CGPathRef)animateToScaleWater: (CGFloat)scale
{
    scale = MAX(0, MIN(1, scale));
    CGFloat bigCircleScale = 1 - scale * LXD_MIN_SCALE;
    CGFloat smallCircleScale = 1 - scale * LXD_MAX_SCALE;
    CGFloat bigWidth = _initWidth * bigCircleScale;
    
    CGFloat smallWidth = _initWidth * smallCircleScale;
    CGFloat topOffset = (LXD_INIT_HEIGHT - _refreshImageView.height) / 2;
    CGFloat smallCenterY = self.height - topOffset - smallWidth / 2;
    
    /// 两个圆的左右点
    CGPoint A = LXDPointOffset(_refreshImageView.center, -bigWidth / 2, 0);
    CGPoint B = LXDPointOffset(_refreshImageView.center, bigWidth / 2, 0);
    CGPoint C = { _refreshImageView.centerX - smallWidth / 2, smallCenterY };
    CGPoint D = { _refreshImageView.centerX + smallWidth / 2, smallCenterY };
    
    /// 贝塞尔控制点。 A-E-C、B-F-D
    CGPoint E = { (C.x - A.x) + A.x, 0.4 * (C.y - A.y) + A.y };
    CGPoint F = { D.x, 0.4 * (D.y - B.y) + B.y };
    CGPoint G = { _refreshImageView.centerX, _refreshImageView.centerY - bigWidth / 2 };
    CGPoint H = { _refreshImageView.centerX, smallCenterY + smallWidth / 2 };
    
    CGPoint AG1 = { A.x, (A.y + G.y) / 2 };
    CGPoint AG2 = { (A.x + G.x) / 2, G.y };
    CGPoint GB1 = { (B.x + G.x) / 2, G.y };
    CGPoint GB2 = { B.x, (B.y + G.y) / 2 };
 
    CGPoint DH1 = { D.x, (D.y + H.y) / 2 };
    CGPoint DH2 = { (H.x + D.x) / 2, H.y };
    CGPoint HC1 = { (H.x + C.x) / 2, H.y };
    CGPoint HC2 = { C.x, (C.y + H.y) / 2 };
    
    UIBezierPath * path;
    
    if (smallWidth < _initWidth * 0.95) {
        path = [UIBezierPath bezierPath];
        [path moveToPoint: A];
        [path addCurveToPoint: G controlPoint1: AG1 controlPoint2: AG2];
        [path addCurveToPoint: B controlPoint1: GB1 controlPoint2: GB2];
        [path addQuadCurveToPoint: D controlPoint: F];
        [path addCurveToPoint: H controlPoint1: DH1 controlPoint2: DH2];
        [path addCurveToPoint: C controlPoint1: HC1 controlPoint2: HC2];
        [path addQuadCurveToPoint: A controlPoint: E];
    } else {
        path = [UIBezierPath bezierPathWithArcCenter: _refreshImageView.center radius: bigWidth / 2 startAngle: kAngleToArc(0) endAngle: kAngleToArc(360) clockwise: YES];
    }
    return path.CGPath;
}

/// 动画结束复原子控件
- (void)animateToRecoverySubviews
{
    UIEdgeInsets insets = _scrollView.contentInset;
    insets.top = _insetsTop;
    
    [UIView animateWithDuration: LXD_HIDE_DURATION * 0.5 animations: ^{
        self.success.alpha = 1;
    } completion: ^(BOOL finished) {
        
        /// 隐藏刷新成功信息并且显示刷新水滴
        [UIView animateWithDuration: LXD_HIDE_DURATION delay: LXD_HIDE_DURATION options: UIViewAnimationOptionCurveEaseIn animations: ^{
            _scrollView.contentInset = insets;
        } completion: ^(BOOL finished) {
            _refreshImageView.alpha = 1;
            _circleLayer.opacity = 1;
            _success.alpha = 0;
        }];
    }];
}

/// 开始转圈刷新
- (void)animateStart
{
    if (!_activityView.isAnimating) {
        [_activityView startAnimating];
    }
}

/// 停止转圈刷新
- (void)animateStop
{
    if (_activityView.isAnimating) {
        [_activityView stopAnimating];
    }
}


@end
