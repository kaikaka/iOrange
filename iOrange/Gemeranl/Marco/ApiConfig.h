//
//  ApiConfig.h
//  iOrange
//
//  Created by XiangKai Yin on 5/20/15.
//  Copyright (c) 2015 yinxiangkai. All rights reserved.
//

#ifndef iOrange_ApiConfig_h
#define iOrange_ApiConfig_h

typedef enum : NSUInteger {
  MainHomeButtonTypeBack = 10,
  MainHomeButtonTypeForward,
  MainHomeButtonTypeSetting,
  MainHomeButtonTypeMore,
  MainHomeButtonTypeHome
} MainHomeButtonType;

typedef enum : NSUInteger {
  HomeSettingTypeAddBookMark = 10,
  HomeSettingTypeBookMark,
  HomeSettingTypeNoPictureMode,
  HomeSettingTypeFullMode,
  HomeSettingTypeReload,
  HomeSettingTypeUpdate,
  HomeSettingTypeFeedback,
  HomeSettingTypeShare,
  HomeSettingTypePrivacy,
  HomeSettingTypeSetup
} HomeSettingType;

#define kScaleContain 1.2f

#define kAppId @"996950205"

#define kBaiduAppId @"2013104"
#define kBaiduPublisherId @"ac77abad"

#define kViewControllerNotionHismark @"kNotionHismark"
#define kViewControllerNotionSite @"kNotionSite"
#define kViewControllerNotionPrivacy @"kViewControllerNotionPrivacy"
#define kViewControllerNotionUpadtePaly @"kViewControllerNotionUpadtePaly"

#define kSettingControllerNoPicture @"kSettingControllerNoPicture"

#define kBrowserControllerFont @"kBrowserControllerFont"
#define kBrowserControllerAtPageButton @"kBrowserControllerAtPageButton"

#define kuMengTongJikey @"5663c5b967e58e8eac0022db"

#define sevenDaysWeatherInfoUrl(cityCode) [NSString stringWithFormat:@"http://mobile.weather.com.cn/data/forecast/%@.html", cityCode]
#define CITYWEATHERURL(Identifier) [NSString stringWithFormat:@"http://mobile.weather.com.cn/data/forecast/%@.html", Identifier]
#define CITYNOWWEATHERURL(Identifier) [NSString stringWithFormat:@"http://weather.51wnl.com/weatherinfo/GetMoreWeather?cityCode=%@&weatherType=1", Identifier]
#define CITYPMVALUE(Identifier) [NSString stringWithFormat:@"http://weather.123.duba.net/static/weather_info/%@.html",Identifier]

#endif
