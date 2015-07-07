//
//  CommonMethods.m
//  iOrange
//
//  Created by XiangKai Yin on 7/6/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import "CommonMethods.h"

@implementation CommonMethods

+ (NSDictionary *)getNewCityDict {
  NSString *path = [[NSBundle mainBundle] pathForResource:@"NewCityList"
                                                   ofType:@"plist"];
  NSDictionary *dict = [[NSDictionary alloc]
                        initWithContentsOfFile:path];
  return dict;
}

+ (NSDictionary *)getProvinceDict {
  NSString *path = [[NSBundle mainBundle] pathForResource:@"ProvinceList"
                                                   ofType:@"plist"];
  NSDictionary *dict = [[NSDictionary alloc]
                        initWithContentsOfFile:path];
  return dict;
}

+ (NSDictionary *)getEnglishCityDict {
  NSString *path  = [[NSBundle mainBundle] pathForResource:@"PYCityList" ofType:@"plist"];
  NSDictionary *dict = [[NSDictionary alloc]
                        initWithContentsOfFile:path];
  return dict;
}

+ (NSInteger)GetNowHour {
  //获取当前时间
  NSDate *now = [NSDate date];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
  NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
  NSInteger hour = [dateComponent hour];
  
  return hour;
}

+ (NSDictionary *)getWeaterData {
  NSDictionary *dict = @{@"00":@"晴",
                         @"01":@"多云",
                         @"02":@"阴",
                         @"03":@"阵雨",
                         @"04":@"雷阵雨",
                         @"05":@"雷阵雨伴有冰雹",
                         @"06":@"雨夹雪",
                         @"07":@"小雨",
                         @"08":@"中雨",
                         @"09":@"大雨",
                         @"10":@"暴雨",
                         @"11":@"大暴雨",
                         @"12":@"特大暴雨",
                         @"13":@"阵雪",
                         @"14":@"小雪",
                         @"15":@"中雪",
                         @"16":@"大雪",
                         @"17":@"暴雪",
                         @"18":@"雾",
                         @"19":@"冻雨",
                         @"20":@"沙尘暴",
                         @"21":@"小到中雨",
                         @"22":@"中到大雨",
                         @"23":@"大到暴雨",
                         @"24":@"暴雨到大暴雨",
                         @"25":@"大暴雨到特大暴雨",
                         @"26":@"小到中雪",
                         @"27":@"中到大雪",
                         @"28":@"大到暴雪",
                         @"29":@"浮尘",
                         @"30":@"扬沙",
                         @"31":@"强沙尘暴",
                         @"53":@"霾",
                         @"99":@""};
  return dict;
}

+ (NSDictionary *)getFxData {
  NSDictionary *dict =  @{@"0":@"无持续风向",
                          @"1":@"东北风",
                          @"2":@"东风",
                          @"3":@"东南风",
                          @"4":@"南风",
                          @"5":@"西南风",
                          @"6":@"西风",
                          @"7":@"西北风",
                          @"8":@"北风",
                          @"9":@"旋转风"};
  return dict;
}

+ (NSDictionary *)getFlData {
  NSDictionary *dict = @{@"0":@"微风",
                         @"1":@"3-4级",
                         @"2":@"4-5级",
                         @"3":@"5-6级",
                         @"4":@"6-7级",
                         @"5":@"7-8级",
                         @"6":@"8-9级",
                         @"7":@"9-10级",
                         @"8":@"10-11级",
                         @"9":@"11-12级"};
  return dict;
}

@end
