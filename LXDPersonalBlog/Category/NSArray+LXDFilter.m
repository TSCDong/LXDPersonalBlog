//
//  NSArray+LXDFilter.m
//  LXDPersonalBlog
//
//  Created by linxinda on 16/1/16.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "NSArray+LXDFilter.h"

@implementation NSArray (LXDFilter)

/// 筛选数组元素并生成新数组
- (NSArray *)filterObjectsWithSelector: (SEL)selector
{
    NSMutableArray * result = @[].mutableCopy;
    __block BOOL canPass;
    [self enumerateObjectsUsingBlock: ^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self getResultObject: obj method: selector retValue: canPass]) {
            [result addObject: obj];
        }
    }];
    return result;
}

/// 筛选数组的keyPath对应的属性，返回匹配keyPath成功的元素集合
- (NSArray *)filterObjectsWithKeyPath: (NSString *)keyPath compareObject: (id)compareObject
{
    NSMutableArray * result = @[].mutableCopy;
    [self enumerateObjectsUsingBlock: ^(id  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        id obj = [item valueForKeyPath: keyPath];
        if (obj) {
            if ([obj compare: compareObject] == NSOrderedSame) {
                [result addObject: item];
            }
        }
    }];
    
    return result;
}

/// 安全访问数组元素
- (id)safeObjectAtIndex: (NSInteger)idx
{
    if (idx < self.count) {
        return [self objectAtIndex: idx];
    } else {
        return nil;
    }
}

/// 使用NSInvocation调用方法并获取返回值
- (BOOL)getResultObject: (id)obj method: (SEL)aSelector retValue: (BOOL)retValue
{
    NSMethodSignature * sign = [[obj class] instanceMethodSignatureForSelector: aSelector];
    if (sign) {
        NSInvocation * invocation = [NSInvocation invocationWithMethodSignature: sign];
        [invocation setTarget: obj];
        [invocation setSelector: aSelector];
        
        [invocation retainArguments];
        [invocation invoke];
        [invocation getReturnValue: &retValue];
        return retValue;
    }
    return NO;
}

@end
