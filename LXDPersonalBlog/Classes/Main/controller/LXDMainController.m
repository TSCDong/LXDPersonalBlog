//
//  LXDMainController.m
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/1/12.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "LXDMainController.h"

@interface LXDMainController ()

@end

@implementation LXDMainController


#pragma mark - View life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupItemImages];
    self.tabBar.translucent = NO;
    self.tabBar.tintColor = LXD_MAIN_COLOR;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Setup
/// 设置tabBarItem的图片
- (void)setupItemImages
{
    NSArray<NSString *> * images = @[
                                     [NSString stringWithFormat: @"tab_blog"],
                                     [NSString stringWithFormat: @"tab_category"],
                                     [NSString stringWithFormat: @"tab_me_icon"],
                                     ];
    [self setupItemWithImages: images selectedImageSuffix: [NSString stringWithFormat: @"_hl"] renderingMode: UIImageRenderingModeAlwaysOriginal];
}

/// 设置item的图片和渲染模式
- (void)setupItemWithImages: (NSArray *)images selectedImageSuffix: (NSString *)selectedImageSuffix renderingMode: (UIImageRenderingMode)renderingMode
{
    [self.tabBar.items enumerateObjectsUsingBlock: ^(UITabBarItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        item.image = [UIImage imageNamed: images[idx]];
        item.selectedImage = [[UIImage imageNamed: [images[idx] stringByAppendingString: selectedImageSuffix]] imageWithRenderingMode: renderingMode];
    }];
}


@end
