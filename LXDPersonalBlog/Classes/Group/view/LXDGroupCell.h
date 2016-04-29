//
//  LXDGroupCell.h
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/1/20.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  文章类别单元格
 */
@interface LXDGroupCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;

/// 截取当前状态
- (UIView *)snapCurrentState;

@end
