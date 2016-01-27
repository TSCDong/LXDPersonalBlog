//
//  LXDArticle.m
//  LXDPersonalBlog
//
//  Created by linxinda on 16/1/12.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "LXDArticle.h"
#import <objc/runtime.h>


typedef id (*LXDIMP)(id, SEL, ...);             ///<    有返回值的代码实现
typedef void(*LXDVoidIMP)(id, SEL, ...);    ///<    无返回值的代码实现
typedef void(^LXDEnumeratePropertiesHandler)(objc_property_t property, const char * propertyName);                           ///<    遍历变量属性操作


/// 用runtime遍历对象属性
static FORCE_INLINE void lxd_enumerateProperties(id object, LXDEnumeratePropertiesHandler enumerateHandler) {
    unsigned int propertyCount;
    objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
    for (int index = 0; index < propertyCount; index++) {
        objc_property_t property = properties[index];
        if (enumerateHandler) { enumerateHandler(property, property_getName(property)); }
    }
    free(properties);
}

/// 使用runtime直接调用getter实现
static FORCE_INLINE id lxd_returnValueForProperty(id object, const char * propertyName) {
    SEL getterSel = NSSelectorFromString([NSString stringWithUTF8String: propertyName]);
    Method getter = class_getInstanceMethod([object class], getterSel);
    LXDIMP imp = (LXDIMP)method_getImplementation(getter);
    return imp(object, getterSel);
}

/// 使用runtime直接调用setter实现
static FORCE_INLINE void lxd_setValueForProperty(id object, const char * propertyName, id value) {
    NSMutableString * name = [NSMutableString stringWithUTF8String: propertyName];
    [name replaceCharactersInRange: NSMakeRange(0, 1) withString: [NSString stringWithFormat: @"%c", toupper([name characterAtIndex: 0])]];
    SEL setterSel = NSSelectorFromString([NSString stringWithFormat: @"set%@:", name]);
    Method setter = class_getInstanceMethod([object class], setterSel);
    if (setter) {
        NSLog(@"%@", NSStringFromSelector(setterSel));
        LXDVoidIMP imp = (LXDVoidIMP)method_getImplementation(setter);
        imp(object, setterSel, value);
    }
}


@implementation LXDArticle


#pragma mark - initializer
- (instancetype)init
{
    return [self initWithHTML: nil];
}

/// 全能构造器
- (instancetype)initWithHTML: (NSString *)html
{
    if (self = [super init]) {
        if (html) {
            self.href = [self hrefFromHTML: html];
            self.title = [self titleFromHTML: html];
            self.content = [self contentFromHTML: html];
            self.dateTime = [self dateTimeFromHTML: html];
            self.category = [self categoryFromHref: self.href];
        } else {
            self.href = self.title = self.content = self.dateTime = self.category = LXD_EMPTY_STRING;
        }
    }
    return self;
}

#pragma mark - <NSCopying>
- (instancetype)copyWithZone: (NSZone *)zone
{
    typeof(*&self) copySelf = [[[self class] allocWithZone: zone] init];
    lxd_enumerateProperties(self,  ^(objc_property_t property, const char *propertyName) {
        id value = lxd_returnValueForProperty(self, propertyName);
        lxd_setValueForProperty(copySelf, propertyName, value);
    });
    return copySelf;
}


#pragma mark - Transform
/// 数据模型转字典
- (NSDictionary *)modelToDictionary
{
    NSMutableDictionary * modelDict = @{}.mutableCopy;
    lxd_enumerateProperties(self,  ^(objc_property_t property, const char *propertyName) {
        id value = lxd_returnValueForProperty(self, propertyName);
        [modelDict setValue: value forKey: [NSString stringWithUTF8String: propertyName]];
    });
    return modelDict;
}


#pragma mark - Analyse
/// 获取html中的文章链接
- (NSString *)hrefFromHTML: (NSString *)html
{
    NSString * prefix = [NSString stringWithFormat: @"href=\""];
    NSString * suffix = [NSString stringWithFormat: @"\">"];
    return [self subStringFromOther: html prefixSubString: prefix suffixSubString: suffix];
}

/// 获取html中的文章标题
- (NSString *)titleFromHTML: (NSString *)html
{
    return [self subStringFromOther: html
                    prefixSubString: [NSString stringWithFormat: @"html\">"]
                    suffixSubString: [NSString stringWithFormat: @"</a>"]];
}

/// 获取html中的简介内容
- (NSString *)contentFromHTML: (NSString *)html
{
    NSMutableString * content = [NSMutableString stringWithFormat: @"%@",
                                 [self subStringFromOther: html
                                          prefixSubString: [NSString stringWithFormat: @"<p>"]
                                          suffixSubString: [NSString stringWithFormat: @"</p>"]]
                                 ];
    NSRange range = [content rangeOfString: @"<"];
    while (range.location != NSNotFound) {
        NSRange nextRange = [content rangeOfString: @">"];
        [content deleteCharactersInRange: NSMakeRange(range.location, nextRange.location - range.location + 1)];
        range = [content rangeOfString: @"<"];
    }
    
    return content;
}

/// 获取html中的发布时间
- (NSString *)dateTimeFromHTML: (NSString *)html
{
    return [self subStringFromOther: html
                    prefixSubString: [NSString stringWithFormat: @"datetime=\""]
                    suffixSubString: [NSString stringWithFormat: @"\""]];
}

/// 从文章链接中获取文章分类
- (NSString *)categoryFromHref: (NSString *)href
{
    return [self subStringFromOther: href
                    prefixSubString: [NSString stringWithFormat: @"/"]
                    suffixSubString: [NSString stringWithFormat: @"/"]];
}

/// 从一个字符串中切割出部分字符串，传入切割的两个分割字符串
- (NSString *)subStringFromOther: (NSString *)originString prefixSubString: (NSString *)prefix suffixSubString: (NSString *)suffix
{
    NSRange range = [originString rangeOfString: prefix];
    if (range.location == NSNotFound) { return LXD_EMPTY_STRING; }
    
    NSString * temp = [originString substringFromIndex: range.location + range.length];
    range = [temp rangeOfString: suffix];
    if (range.location == NSNotFound) { return LXD_EMPTY_STRING; }
    
    return [temp substringToIndex: range.location];
}


@end
