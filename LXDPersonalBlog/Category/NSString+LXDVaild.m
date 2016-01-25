//
//  NSString+LXDVaild.m
//  LXDPersonalBlog
//
//  Created by linxinda on 16/1/16.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "NSString+LXDVaild.h"

@implementation NSString (LXDVaild)

- (BOOL)validContainChinese
{
    NSString * expression = [NSString stringWithFormat: @"^.*[\\u4e00-\\u9fa5].*$"];
    return [self vaildWithExpression: expression];
}

- (BOOL)vaildWithExpression: (NSString *)exp
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", exp];
    return [predicate evaluateWithObject: self];
}


@end
