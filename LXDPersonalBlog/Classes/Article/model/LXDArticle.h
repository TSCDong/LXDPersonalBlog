//
//  LXDArticle.h
//  LXDPersonalBlog
//
//  Created by linxinda on 16/1/12.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  博客文章数据模型
 */
@interface LXDArticle : NSObject<NSCopying>

@property (nonatomic, copy) NSString * category;        ///<    文章分类
@property (nonatomic, copy) NSString * href;              ///<     文章链接
@property (nonatomic, copy) NSString * title;              ///<     文章标题
@property (nonatomic, copy) NSString * content;         ///<     文章简介
@property (nonatomic, copy) NSString * dateTime;      ///<      发布时间

/// 通过html字符串创建数据对象
- (instancetype)initWithHTML: (NSString *)html;

/// 数据模型转字典
- (NSDictionary *)modelToDictionary;

@end
