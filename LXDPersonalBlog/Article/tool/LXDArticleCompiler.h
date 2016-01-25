//
//  LXDArticleCompiler.h
//  LXDPersonalBlog
//
//  Created by linxinda on 16/1/12.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *文章解析器
 */
@interface LXDArticleCompiler : NSObject

/// 解析html数据。解析后的文章数组以LXDArticleListKey存在userInfo中
+ (void)analyseWithHTMLStr: (NSString *)html completeHandler: (LXDCommonHandler)completeHandler;

@end
