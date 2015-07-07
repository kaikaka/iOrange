//
//  CommonMethods.h
//  iOrange
//
//  Created by XiangKai Yin on 7/6/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonMethods : NSObject

/**
 *  获取城市的plist文件
 *
 *  @return 字典
 */
+ (NSDictionary *)getNewCityDict;

/**
 *  获取省份plist文件
 *
 *  @return 字典
 */
+ (NSDictionary *)getProvinceDict;

/**
 *  英文版城市名称
 *
 *  @return 字典
 */
+ (NSDictionary *)getEnglishCityDict;

/**
 *  获取当前小时
 *
 *  @return int
 */
+ (NSInteger)GetNowHour;

/**
 *  天气
 *
 *  @return 字典
 */
+ (NSDictionary *)getWeaterData;

/**
 *  风向
 *
 *  @return 字典
 */
+ (NSDictionary *)getFxData;

/**
 *  风力
 *
 *  @return 字典
 */
+ (NSDictionary *)getFlData;

@end
