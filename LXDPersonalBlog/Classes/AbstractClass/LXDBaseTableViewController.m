//
//  LXDBaseTableViewController.m
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/4/29.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "LXDBaseTableViewController.h"
#import "LXDQueue.h"
#import "LXDLineBackgroundView.h"
#import "LXDAlphaNavigationController.h"

@interface LXDBaseTableViewController ()

@end

@implementation LXDBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setTitle: (NSString *)title
{
    [LXDQueue executeInMainQueue: ^{
        if ([self.navigationController isKindOfClass: NSClassFromString(@"LXDAlphaNavigationController")]) {
            LXDLineBackgroundView * lineView = [LXDLineBackgroundView createViewWithFrame: CGRectMake(0, 0, LXD_SCREEN_WIDTH, 64) lineWidth: 4 lineGap: 4 lineColor: [[UIColor blackColor] colorWithAlphaComponent:0.015]];
            [lineView setAttributeText: [[NSAttributedString alloc] initWithString: title attributes: @{ NSFontAttributeName: [UIFont systemFontOfSize: 22], NSForegroundColorAttributeName: [UIColor colorWithWhite: 0.3 alpha: 1] }]];
            LXDAlphaNavigationController * alphaNav = (LXDAlphaNavigationController *)self.navigationController;
            [alphaNav customBackgroundView: lineView];
        }
    }];
}


@end
