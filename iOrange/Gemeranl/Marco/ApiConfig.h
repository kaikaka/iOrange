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

#define kScaleContain 1.2f

#define sevenDaysWeatherInfoUrl(cityCode) [NSString stringWithFormat:@"http://mobile.weather.com.cn/data/forecast/%@.html", cityCode]
#define CITYWEATHERURL(Identifier) [NSString stringWithFormat:@"http://mobile.weather.com.cn/data/forecast/%@.html", Identifier]
#define CITYNOWWEATHERURL(Identifier) [NSString stringWithFormat:@"http://weather.51wnl.com/weatherinfo/GetMoreWeather?cityCode=%@&weatherType=1", Identifier]
#define CITYPMVALUE(Identifier) [NSString stringWithFormat:@"http://weather.123.duba.net/static/weather_info/%@.html",Identifier]

#endif
