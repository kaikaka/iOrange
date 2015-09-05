//
//  CheckVersion.m
//  WKBrowser
//
//  Created by David on 14-4-4.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "CheckVersion.h"

#import "AFHTTPRequestOperationManager.h"
#import "CJSONDeserializer.h"
#import "BlockUI.h"


NSString * const API_CheckVersioniTunes = @"http://itunes.apple.com/cn/lookup?id=";
NSString * const kNeverCheckVersion = @"kNeverCheckVersion";

@implementation CheckVersion

/**
 *  检查app的更新
 *
 *  @param appleId 对应iTunes connect 上的Apple ID
 */
+ (void)checkVersionWithAppleID:(NSString *)appleId {

  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager POST:[API_CheckVersioniTunes stringByAppendingString:appleId] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
    NSDictionary *dic = (NSDictionary *)responseObject;
    NSArray *infoArray = [dic objectForKey:@"results"];
    if ([infoArray count]) {
      NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
      NSString *lastVersion = [releaseInfo objectForKey:@"version"];
      NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
      if ([lastVersion compare:version]==NSOrderedDescending) {
        NSString *appLink = [releaseInfo objectForKey:@"trackViewUrl"];
        NSString *descr = [releaseInfo objectForKey:@"description"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"检查有新版本" message:descr delegate:nil cancelButtonTitle:@"不更新" otherButtonTitles:@"立即更新", nil];
        [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
          if (alert.cancelButtonIndex!=buttonIndex) {
            // 下载
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appLink]];
          }
        }];
      }
      else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您已经拥有最新版本，无需更新！" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
        [alert show];
      }
    }
    else {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"AppStore上未找到该App，可能还未提交或还未通过审核！" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles: nil];
      [alert show];
    }
  } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    
  }];
}

+ (void)checkVersionAtLaunchWithAppleID:(NSString *)appleId
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([ud objectForKey:kNeverCheckVersion]) {
        if ([ud boolForKey:kNeverCheckVersion]) {
            return;
        }
    }
    
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager POST:[API_CheckVersioniTunes stringByAppendingString:appleId] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[responseObject dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    NSArray *infoArray = [dic objectForKey:@"results"];
    if ([infoArray count]) {
      NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
      NSString *lastVersion = [releaseInfo objectForKey:@"version"];
      NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
      if ([lastVersion compare:version]==NSOrderedDescending) {
        NSString *appLink = [releaseInfo objectForKey:@"trackViewUrl"];
        NSString *descr = [releaseInfo objectForKey:@"description"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"检查有新版本" message:descr delegate:nil cancelButtonTitle:@"不更新" otherButtonTitles:@"立即更新", nil];
        [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
          if (alert.cancelButtonIndex!=buttonIndex) {
            // 下载
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appLink]];
          }
        }];
      }
      else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您已经拥有最新版本，无需更新！" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
        [alert show];
      }
    }
    else {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"AppStore上未找到该App，可能还未提交或还未通过审核！" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles: nil];
      [alert show];
    }
  } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    
  }];
}

@end
