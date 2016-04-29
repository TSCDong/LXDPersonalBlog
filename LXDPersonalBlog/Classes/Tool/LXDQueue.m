//
//  LXDQueue.m
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/4/29.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "LXDQueue.h"

@implementation LXDQueue

+ (void)executeInMainQueue: (dispatch_block_t)block
{
    NSParameterAssert(block);
    dispatch_async(dispatch_get_main_queue(), block);
}

+ (void)executeInGlobalQueue: (dispatch_block_t)block
{
    NSParameterAssert(block);
    dispatch_async(dispatch_get_global_queue(LXDDefaultPriority, 0), block);
}

+ (void)executeInGlobalQueue: (dispatch_block_t)block queuePriority: (LXDQueuePriority)queuePriority
{
    NSParameterAssert(block);
    dispatch_async(dispatch_get_global_queue(queuePriority, 0), block);
}

+ (void)executeInMainQueue: (dispatch_block_t)block delay: (NSTimeInterval)delay
{
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), block);
}

+ (void)executeInGlobalQueue: (dispatch_block_t)block delay: (NSTimeInterval)delay
{
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_global_queue(LXDDefaultPriority, 0), block);
}

+ (void)executeInGlobalQueue: (dispatch_block_t)block queuePriority: (LXDQueuePriority)queuePriority delay: (NSTimeInterval)delay
{
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_global_queue(queuePriority, 0), block);
}


@end
