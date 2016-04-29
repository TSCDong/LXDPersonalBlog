//
//  LXDFamousController.m
//  LXDPersonalBlog
//
//  Created by linxinda on 16/1/25.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "LXDFamousController.h"
#import "LXDQueue.h"
#import "LXDLineBackgroundView.h"
#import "LXDAlphaNavigationController.h"

@interface LXDFamousController ()

@end

@implementation LXDFamousController

static NSString * const reuseIdentifier = @"Cell";


#pragma mark - View life
- (void)viewDidLoad {
    [super viewDidLoad];
    [LXDQueue executeInMainQueue: ^{
        if ([self.navigationController isKindOfClass: NSClassFromString(@"LXDAlphaNavigationController")]) {
            LXDLineBackgroundView * lineView = [LXDLineBackgroundView createViewWithFrame: CGRectMake(0, 0, LXD_SCREEN_WIDTH, 64) lineWidth: 4 lineGap: 4 lineColor: [[UIColor blackColor] colorWithAlphaComponent:0.015]];
            [lineView setAttributeText: [[NSAttributedString alloc] initWithString: @"名人堂" attributes: @{ NSFontAttributeName: [UIFont systemFontOfSize: 22], NSForegroundColorAttributeName: [UIColor colorWithWhite: 0.3 alpha: 1] }]];
            LXDAlphaNavigationController * alphaNav = (LXDAlphaNavigationController *)self.navigationController;
            [alphaNav customBackgroundView: lineView];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
