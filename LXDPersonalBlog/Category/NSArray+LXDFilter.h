//
//  NSArray+LXDFilter.h
//  LXDPersonalBlog
//
//  Created by linxinda on 16/1/16.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (LXDFilter)

/// 筛选数组元素组成新数组，如果selector返回YES，则默认筛选成功。同步方法
- (NSArray *)filterObjectsWithSelector: (SEL)selector;

/// 筛选数组的keyPath对应的属性，返回匹配keyPath成功的元素集合。同步方法
- (NSArray *)filterObjectsWithKeyPath: (NSString *)keyPath compareObject: (id)compareObject;

/// 获取数组元素，防止越界访问
- (id)safeObjectAtIndex: (NSInteger)idx;

@end
