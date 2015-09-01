//
//  CheckVersion.h
//  WKBrowser
//
//  Created by David on 14-4-4.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const API_CheckVersioniTunes;

@interface CheckVersion : NSObject

/**
 *  检查app的更行
 *
 *  @param appleId 对应iTunes connect 上的Apple ID
 */
+ (void)checkVersionWithAppleID:(NSString *)appleId;

+ (void)checkVersionAtLaunchWithAppleID:(NSString *)appleId;

@end
