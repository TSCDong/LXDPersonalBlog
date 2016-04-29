//
//  LXDGroupLayout.m
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/1/20.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "LXDGroupLayout.h"

#define LXD_MIN_HEIGHT 20.

@interface LXDGroupLayout ()

@property (nonatomic, strong) NSMutableDictionary * layoutAttributes;

@end

@implementation LXDGroupLayout

/// 懒加载布局属性存储对象
- (NSMutableDictionary *)layoutAttributes
{
    return _layoutAttributes ?: (_layoutAttributes = @{}.mutableCopy);
}

/// 准备布局时初始化数据
- (void)prepareLayout
{
    NSInteger itemCount = [self.collectionView numberOfItemsInSection: 0];
    for (NSInteger idx = 0; idx < itemCount; idx++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem: idx inSection: 0];
        UICollectionViewLayoutAttributes * attribute = [self layoutAttributesForItemAtIndexPath: indexPath];
        [self.layoutAttributes setValue: attribute forKey: NSStringFromCGRect(attribute.frame)];
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray * layoutAttributes = @[].mutableCopy;
    
    for (NSString * rectStr in self.layoutAttributes) {
        CGRect frame = CGRectFromString(rectStr);
        if (CGRectIntersectsRect(rect, frame)) {
            [layoutAttributes addObject: _layoutAttributes[rectStr]];
        }
    }
    
    return layoutAttributes;
}

/// 根据下标返回item的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath: (NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath: indexPath];
    NSInteger line = indexPath.item % 3;
    NSInteger row = indexPath.item / 3;
    
    CGSize size = CGSizeMake(LXD_SCREEN_WIDTH / 3, LXD_SCREEN_WIDTH / 3);
    attribute.frame = CGRectMake(line * size.width, LXD_MIN_HEIGHT + row * size.height, size.width, size.height);
    
    return attribute;
}

/// 是否需要重新渲染
- (BOOL)shouldInvalidateLayoutForBoundsChange: (CGRect)newBounds
{
    return !CGRectEqualToRect(newBounds, self.collectionView.bounds);
}

/// 返回collectionView的滚动范围
- (CGSize)collectionViewContentSize
{
    NSInteger itemCount = [self.collectionView numberOfItemsInSection: 0];
    return CGSizeMake(self.collectionView.frame.size.width, ((itemCount + 2) / 3) * (LXD_SCREEN_WIDTH / 3));
}


@end
