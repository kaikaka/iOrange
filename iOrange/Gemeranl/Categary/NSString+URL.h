//
//  NSString+URL.h
//  JiShi
//
//  Created by David on 13-12-5.
//  Copyright (c) 2013年 KOTO Inc. All rights reserved.
/**
 *
 *  普通链接编码：CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)(origin), CFSTR(":/=?%#"), NULL, kCFStringEncodingUTF8));
 *  完全编码：CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)(origin), NULL, CFSTR(":/?%&#"), kCFStringEncodingUTF8));
 *  搜索链接编码：先进行一次【普通链接编码】，然后对 url.query 进行完全编码
 *
 */

#import <Foundation/Foundation.h>

@interface NSString (URL)

/**
 *  对所有特殊字符进行编码
 *  legalURLCharactersToBeEscaped = CFSTR(":/?%&#")
 *
 *  @return return value description
 */
- (NSString *)urlEncode;

/**
 *  只对中文进行编码
 *  charactersToLeaveUnescaped = CFSTR(":/=?%#")
 *
 *  @return value description
 */
- (NSString *)urlEncodeNormal;

/**
 *  针对链接地址是搜索类型，且搜索内容为网址的链接 一定要使用此函数进行编码
 *
 *  @return return value description
 */
- (NSString *)urlEncodeQueryContainLink;

/**
 *  url解码操作
 *
 *  @return return value description
 */
- (NSString *)urlDecode;

@end
