//
//  LXDBlogRequester.m
//  LXDPersonalBlog
//
//  Created by linxinda on 16/1/12.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "LXDBlogRequester.h"

NSString * const LXDRequestHTMLKey = @"LXDRequestHTMLKey";

@implementation LXDBlogRequester

/// 请求博客地址并返回html数据
+ (void)requestBlog: (NSString *)blogURL completeHandler: (LXDCommonHandler)completeHandler
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData * htmlData = [NSData dataWithContentsOfURL: [NSURL URLWithString: blogURL]];
        NSString * htmlStr = [[NSString alloc] initWithData: htmlData encoding: NSUTF8StringEncoding];
        if (htmlStr) {
            if (completeHandler) {
                completeHandler(self, LXDStatusSuccess, @{ LXDRequestHTMLKey: htmlStr });
            }
        } else {
            if (completeHandler) {
                completeHandler(self, LXDStatusFailed, nil);
            }
        }
    });
}


@end
