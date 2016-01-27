//
//  LXDBlogController.h
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/1/12.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXDArticleManager;
/**
 *  博客列表控制器
 */
@interface LXDBlogController : UITableViewController

@property (nonatomic, readonly) LXDArticleManager * articleManager;

@end
