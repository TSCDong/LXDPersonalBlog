//
//  LXDBlogRequester.h
//  LXDPersonalBlog
//
//  Created by linxinda on 16/1/12.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 获取回调字典中html数据的关键字
FOUNDATION_EXPORT NSString * const LXDRequestHTMLKey;

/**
 *  用来请求博客数据
 */
@interface LXDBlogRequester : NSObject

/// 请求博客地址并返回html数据
+ (void)requestBlog: (NSString *)blogURL completeHandler: (LXDCommonHandler)completeHandler;

@end
