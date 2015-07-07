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

#define sevenDaysWeatherInfoUrl(cityCode) [NSString stringWithFormat:@"http://mobile.weather.com.cn/data/forecast/%@.html", cityCode]
#define CITYWEATHERURL(Identifier) [NSString stringWithFormat:@"http://mobile.weather.com.cn/data/forecast/%@.html", Identifier]
#define CITYNOWWEATHERURL(Identifier)  [NSString stringWithFormat:@"http://www.weather.com.cn/data/sk/%@.html", Identifier]
#define CITYPMVALUE(Identifier) [NSString stringWithFormat:@"http://mobile.weather.com.cn/data/air/%@.html",Identifier]
#endif
