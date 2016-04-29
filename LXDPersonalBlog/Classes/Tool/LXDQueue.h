//
//  LXDQueue.h
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/4/29.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  @brief 线程优先等级
 */
typedef NS_ENUM(NSInteger, LXDQueuePriority) {
    /// 最低优先级
    LXDLowPriority = DISPATCH_QUEUE_PRIORITY_LOW,
    /// 最高优先级
    LXDHighPriority = DISPATCH_QUEUE_PRIORITY_HIGH,
    /// 默认优先级
    LXDDefaultPriority = DISPATCH_QUEUE_PRIORITY_DEFAULT,
    /// 后台优先级
    LXDBackgroundPriority = DISPATCH_QUEUE_PRIORITY_BACKGROUND
};

/*!
 *  @brief 封装GCD
 */
@interface LXDQueue : NSObject

@property (nonatomic, readonly, strong) dispatch_queue_t dispatchQueue;

#pragma mark - 便利方法
+ (void)executeInMainQueue: (dispatch_block_t)block;
+ (void)executeInGlobalQueue: (dispatch_block_t)block;
+ (void)executeInGlobalQueue: (dispatch_block_t)block queuePriority: (LXDQueuePriority)queuePriority;

+ (void)executeInMainQueue: (dispatch_block_t)block delay: (NSTimeInterval)delay;
+ (void)executeInGlobalQueue: (dispatch_block_t)block delay: (NSTimeInterval)delay;
+ (void)executeInGlobalQueue: (dispatch_block_t)block queuePriority: (LXDQueuePriority)queuePriority delay: (NSTimeInterval)delay;

@end
