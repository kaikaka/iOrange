//
//  NSString+URL.m
//  JiShi
//
//  Created by David on 13-12-5.
//  Copyright (c) 2013年 KOTO Inc. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)

/**
 *  对所有特殊字符进行编码
 *  legalURLCharactersToBeEscaped = CFSTR(":/?%&#")
 *
 *  @return return value description
 */
- (NSString *)urlEncode
{
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                     (__bridge CFStringRef)(self),
                                                                     NULL,
                                                                     CFSTR(":/?%&#"),
                                                                     kCFStringEncodingUTF8));
}

/**
 *  只对中文进行编码
 *  charactersToLeaveUnescaped = CFSTR(":/=?%#")
 *
 *  @return value description
 */
- (NSString *)urlEncodeNormal {
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                     (__bridge CFStringRef)(self),
                                                                     CFSTR(":/=?%#"),
                                                                     NULL,
                                                                     kCFStringEncodingUTF8));
}

/**
 *  针对链接地址是搜索类型，且搜索内容为网址的链接 一定要使用此函数进行编码
 *
 *  @return return value description
 */
- (NSString *)urlEncodeQueryContainLink
{
    NSURL *url = [NSURL URLWithString:self];
    NSArray *arrUrl = [url.absoluteString componentsSeparatedByString:@"?"];
    if (arrUrl.count<2) {
        return [self urlEncodeNormal];
    }
    NSString *qureyLink = [url.query urlEncode];
    NSString *urlLink = [arrUrl[0] stringByAppendingFormat:@"?%@", qureyLink.length>0?qureyLink:@""];
    return urlLink;
    
    
}

/**
 *  url解码操作
 *
 *  @return return value description
 */
- (NSString *)urlDecode
{
    return CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                     (__bridge CFStringRef)(self),
                                                                                     CFSTR(""),
                                                                                     kCFStringEncodingUTF8));
}

@end
