//
//  ViewWeather.m
//  iOrange
//
//  Created by XiangKai Yin on 7/5/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import "ViewWeather.h"
#import "CommonMethods.h"
#import "ApiConfig.h"
#import "UIImageViewEx.h"
#import "CalendarDateUtil.h"
#import "AFNetworking.h"

@implementation ViewWeather

#pragma mark - public methods

- (void)setUp {
  [self getLocal];
}

#pragma mark - private methods

/**
 *  获取当前的地址信息
 */
- (void)getLocal {
  if (!TARGET_IPHONE_SIMULATOR && [CLLocationManager locationServicesEnabled]) {
    if (!self.myLocationManager) {
      self.myLocationManager = [[CLLocationManager alloc] init];
      self.myLocationManager.delegate = self;
      self.myLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
      self.myLocationManager.distanceFilter  = kCLDistanceFilterNone;
      if ([self.myLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.myLocationManager requestWhenInUseAuthorization];
      }
    }
    [self.myLocationManager startUpdatingLocation];
  } else {
  }
}

/**
 *  根据地理位置获取请求的天气信息
 *
 *  @param placeArray [地理位置]
 */
- (void)requestWeatherDataWithPlace:(NSArray *)placeArray {
  if (self.myLocationManager) {
    [self.myLocationManager stopUpdatingLocation];
    self.myLocationManager = nil;
  }
  NSString *placeAdministrativeArea = [placeArray objectAtIndex:0];
  NSString *placeLocality = [placeArray objectAtIndex:1];
  
  //用来判断是否是直辖市
  NSRange range = [placeAdministrativeArea rangeOfString:@"省"];
  //不是
  NSString *proCode = nil;
  if (range.length == 1) {
    proCode = [placeLocality substringToIndex:[placeLocality length]-1];
  } else {
    if ([CurrentLauguage isEqualToString:@"en"]) {
      if ([placeLocality isEqualToString:@""]) {
        proCode = [placeAdministrativeArea substringToIndex:[placeAdministrativeArea length]];
      } else {
        proCode = placeLocality;
      }
    } else {
      //是
      proCode = [placeAdministrativeArea substringToIndex:[placeAdministrativeArea length]-1];
    }
  }
  //改变城市文本
  [self.buttonCityName setTitle:proCode forState:0];
  NSString *cityCode = [self getCityCodeForSearchString:proCode];
  //获取天气信息
  [self getWeatherWithCity:cityCode];
  [self getWeatherNow:cityCode];
  [self getPMValueNowCityCode:cityCode];
  if (_weatherInfoEnd) {
    _weatherInfoEnd();
  }
  [_buttonLocation setBackgroundImage:[UIImage imageNamed:@"home_weather_location@2x.png"] forState:0];
}

/**
 *  根据城市名称取城市代号
 *
 *  @param SerachString City Name
 *
 *  @return City Code
 */
- (NSString *)getCityCodeForSearchString:(NSString *)SerachString {
  NSDictionary *cityDict = nil;
  if ([CurrentLauguage isEqualToString:@"en"]) {
    cityDict = [CommonMethods getEnglishCityDict];
  }
  else
    cityDict = [CommonMethods getNewCityDict];
  //当键值对相反(根据value取key)，又不想循环(可以这样写)
  NSArray *array = [cityDict allKeys];
  NSArray *arr = [cityDict allValues];
  //获取当前值在数组所在的索引
  NSInteger index = [arr indexOfObject:SerachString];
  NSAssert(index <=[arr count], @"index not in array ");
  //获取需要的code
  NSString *codeString = [array objectAtIndex:index];
  return codeString;
}

/**
 *  获取七天天气信息
 *
 *  @param cityIdentifier 城市代码
 */
- (void)getWeatherWithCity:(NSString *)cityIdentifier {
  NSURLCache *urlCache = [NSURLCache sharedURLCache];
  [urlCache setMemoryCapacity:1*1024*1024];
  NSURL *url = [NSURL URLWithString:CITYWEATHERURL(cityIdentifier)];//CITYWEATHERURL(cityIdentifier)];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
  [request setCachePolicy:NSURLRequestReloadRevalidatingCacheData];
  [request setURL:url];
  [request setHTTPMethod:@"GET"];
  [request setValue:@"application/json, text/javascript, */*; q=0.01" forHTTPHeaderField:@"Accept"];
  [request setValue:@"gzip" forHTTPHeaderField:@"Accepts-Encoding"];;
  [request setValue:@"zh-CN,zh;q=0.8" forHTTPHeaderField:@"Accept-Language"];
  [request setValue:@"http://mobile.weather.com.cn/" forHTTPHeaderField:@"Referer"];
  [request setTimeoutInterval:20];
  //缓存
  NSCachedURLResponse *responseU = [urlCache cachedResponseForRequest:request];
  if (responseU != nil) {
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
  }
  [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

    if ([data length] > 0 && connectionError == nil) {
      NSDictionary *jsonString = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
      self.weatherDictionary = [NSMutableDictionary dictionaryWithDictionary:jsonString];
      [self reloadWeatherData];
      
    } else if ([data length] == 0 && connectionError ==nil) { // 没有数据
      
    } else if (connectionError != nil) {
      NSDictionary *jsonString = [NSJSONSerialization JSONObjectWithData:[responseU data] options:NSJSONReadingMutableLeaves error:nil];
      self.weatherDictionary = [NSMutableDictionary dictionaryWithDictionary:jsonString];
      [self reloadWeatherData];
    } else {
    }
  }];
}

/**
 *  显示实时天气
 *
 *  @param cityIdentifier 城市代码
 */
- (void)getWeatherNow:(NSString *)cityIdentifier {

  NSURLCache *urlCache = [NSURLCache sharedURLCache];
  [urlCache setMemoryCapacity:1*1024*1024];
  NSURL *url = [NSURL URLWithString:CITYNOWWEATHERURL(cityIdentifier)];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
  [request setCachePolicy:NSURLRequestReloadRevalidatingCacheData];
  [request setURL:url];
  [request setHTTPMethod:@"GET"];
  [request setValue:@"application/json, text/html, */*; q=0.01" forHTTPHeaderField:@"Accept"];
  [request setValue:@"gzip" forHTTPHeaderField:@"Accepts-Encoding"];;
  [request setValue:@"zh-CN,zh;q=0.8" forHTTPHeaderField:@"Accept-Language"];
  [request setValue:@"http://mobile.weather.com.cn/" forHTTPHeaderField:@"Referer"];
  [request setTimeoutInterval:20];
  //缓存
  NSCachedURLResponse *responseU = [urlCache cachedResponseForRequest:request];
  if (responseU != nil) {
    [request setCachePolicy:NSURLRequestReloadRevalidatingCacheData];
  }
  [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    if ([data length] > 0 && connectionError == nil) {
      NSDictionary *jsonString = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
      [self showTodayData:jsonString];
    }
    else if ([data length] == 0 && connectionError ==nil) { // 没有数据
    }
    else if (connectionError != nil) {
      NSDictionary *jsonString = [NSJSONSerialization JSONObjectWithData:[responseU data] options:NSJSONReadingMutableLeaves error:nil];
      [self showTodayData:jsonString];
    }
    else {
    }
  }];
}

/**
 *  获取PM值
 *
 *  @param cityIdentifier 城市代码
 */
- (void)getPMValueNowCityCode:(NSString *)cityCode{
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  AFHTTPRequestSerializer * requestSerializer = [AFHTTPRequestSerializer serializer];
  AFHTTPResponseSerializer * responseSerializer = [AFHTTPResponseSerializer serializer];
  
  responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
  manager.responseSerializer = responseSerializer;
  manager.requestSerializer = requestSerializer;
  [manager GET:CITYPMVALUE(cityCode) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSString *stringWeather = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSArray *arrayWeather =[stringWeather componentsSeparatedByString:@"("];
    if (arrayWeather.lastObject) {
      NSString *stringW = [arrayWeather lastObject];
       NSArray *arrayTianqi =[stringW componentsSeparatedByString:@")"];
      if ([arrayTianqi firstObject]) {
        NSString *stringC = [arrayTianqi firstObject];
        NSString *stringE = [stringC stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[stringE dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *weatherinfo = [dict objectForKey:@"weatherinfo"];
        [self showAqiImage:[[weatherinfo objectForKey:@"pm"] integerValue]];
        [self showPMValueWithJsonDict:[weatherinfo objectForKey:@"pm"]];
      }
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    DLog(@"requestDogs error:--- %@", error);
  }];

}

/**
 *  显示当前天气
 *
 *  @param jsonString 天气字典
 */
- (void)showTodayData:(NSDictionary *)jsonString {
  NSDictionary *dictString = [jsonString objectForKey:@"weatherinfo"];
  NSString *nowTempSrting = [dictString objectForKey:@"temp"];
  NSString *wsString = [dictString objectForKey:@"WD"];//风力
  NSString *wdString = [dictString objectForKey:@"WS"];//风向
  NSString *wse ;
  if (wdString.length>2) {
    wse = [wdString substringToIndex:2];
  } else {
    wse = [wdString substringToIndex:1];
  }
  [self moveWindWithWSE:wse];
  [self.labelWindLevel setText:[NSString stringWithFormat:@"%@%@",wsString,wdString]];
  if (nowTempSrting.length>1) {
    _nowTempToString = nowTempSrting;
    NSString *firstString = [nowTempSrting substringToIndex:1];
    NSString *secondString = [nowTempSrting substringFromIndex:1];
    [_imageTemperatureFirst setImage:[UIImage imageNamed:[self getNumberImagePath:firstString]]];
    [_imageTemperatureSecond setImage:[UIImage imageNamed:[self getNumberImagePath:secondString]]];
    
  } else {
    [_imageTemperatureFirst setImage:[UIImage imageNamed:[self getNumberImagePath:@"0"]]];
    [_imageTemperatureSecond setImage:[UIImage imageNamed:[self getNumberImagePath:nowTempSrting]]];
  }
}

/**
 *  获取pm2.5值
 *
 *  @param jsonDict json数据
 */
- (void)showPMValueWithJsonDict:(NSString *)pmValue {
  
  NSInteger pm2 = [pmValue integerValue];
  if (pm2 >= 0 && pm2 < 50) {
    pmValue = @"空气优";
    [self showAqiImage:1];
  } else if(pm2 >= 50 && pm2 <100) {
    pmValue = @"空气良";
    [self showAqiImage:2];
  } else if(pm2 >= 100 && pm2 <150) {
    pmValue = @"轻度污染";
    [self showAqiImage:3];
  } else if(pm2 >= 150 && pm2 <200) {
    pmValue = @"中度污染";
    [self showAqiImage:4];
  } else if(pm2 >= 200 && pm2 <300) {
    pmValue = @"重度污染";
    [self showAqiImage:5];
  } else if(pm2 >= 300) {
    pmValue = @"严重污染";
    [self showAqiImage:6];
  }
  [_labelAirLevel setText:[NSString stringWithFormat:@"%ld %@",pm2,pmValue]];
}

/**
 *  获取空气质量数据
 *
 *  @param aqi 空气质量参数
 */
- (void)showAqiImage:(NSInteger)aqi {
  NSString *imageName ;
  switch (aqi) {
    case 1:
      imageName = @"pm25Exp_good@2x";
      break;
    case 2:
      imageName = @"pm25Exp_nice@2x";
      break;
    case 3:
      imageName = @"pm25Exp_mild@2x";
      break;
    case 4:
      imageName = @"pm25Exp_moderate@2x";
      break;
    case 5:
      imageName = @"pm25Exp_serious@2x";
      break;
    case 6:
      imageName = @"pm25Exp_severe@2x";
      break;
      
    default:
      break;
  }
  [_imgvPMExp setImage:[UIImage imageNamed:imageName]];
}

/**
 *  刷新天气数据
 */
- (void)reloadWeatherData {

  NSArray *fArray = [[self.weatherDictionary objectForKey:@"f"] objectForKey:@"f1"];
  if ([fArray count]==0) {
    return;
  }
  
  for (int i= 0; i<7; i++) {
    NSDictionary *dict = [fArray objectAtIndex:i];
    NSString *fa = [dict objectForKey:@"fa"];
    NSString *fb = [dict objectForKey:@"fb"];
    NSString *fc = ([[dict objectForKey:@"fc"] length]>0) ?[dict objectForKey:@"fc"]:_nowTempToString;
    NSString *fd = [dict objectForKey:@"fd"];
    if (i == 0) {
      //超过下午四点 显示下午天气
      if ([CommonMethods GetNowHour]<=16) {
        [_imageBigWeather setImage:[UIImage imageNamed:[self getImageName:fa withPrefix:@"big_"]]];
        [_labelWeather setText: [self getWeatherContent:fa]];
      } else {
        [_imageBigWeather setImage:[UIImage imageNamed:[self getImageName:fb withPrefix:@"big_"]]];
        [_labelWeather setText: [self getWeatherContent:fb]];
      }
      NSString *tempString = [NSString stringWithFormat:@"%@°/%@°",fd,fc];//最高/最低
      [_labelTemperature setText:tempString];
    } else if (i == 1) {
      if ([CommonMethods GetNowHour]<=16) {
        [_imgvWeatherOne setImage:[UIImage imageNamed:[self getImageName:fa withPrefix:@"small_"]]];
      } else {
        [_imgvWeatherOne setImage:[UIImage imageNamed:[self getImageName:fb withPrefix:@"small_"]]];
      }
      NSString *tempString = [NSString stringWithFormat:@"%@°/%@°",fd,fc];//最高/最低
      [_labelTemperatureOne setText:tempString];
      [_labelTimeOne setText:@"明天"];
    } else if (i == 2) {
      if ([CommonMethods GetNowHour]<=16) {
        [_imgvWeatherTwo setImage:[UIImage imageNamed:[self getImageName:fa withPrefix:@"small_"]]];
      } else {
        [_imgvWeatherTwo setImage:[UIImage imageNamed:[self getImageName:fb withPrefix:@"small_"]]];
      }
      NSString *tempString = [NSString stringWithFormat:@"%@°/%@°",fd,fc];//最高/最低
      [_labelTemperatureTwo setText:tempString];
      [_labelTimeTwo setText:[self getWeekWithInt:([CalendarDateUtil getCurrentWeek]+2)%7]];
    } else if (i == 3) {
      if ([CommonMethods GetNowHour]<=16) {
        [_imgvWeatherThree setImage:[UIImage imageNamed:[self getImageName:fa withPrefix:@"small_"]]];
      } else {
        [_imgvWeatherThree setImage:[UIImage imageNamed:[self getImageName:fb withPrefix:@"small_"]]];
      }
      NSString *tempString = [NSString stringWithFormat:@"%@°/%@°",fd,fc];//最高/最低
      [_labelTemperatureThree setText:tempString];
      [_labelTimeThree setText:[self getWeekWithInt:([CalendarDateUtil getCurrentWeek]+3)%7]];
    } else if (i == 4) {
      if ([CommonMethods GetNowHour]<=16) {
        [_imgvWeatherFour setImage:[UIImage imageNamed:[self getImageName:fa withPrefix:@"small_"]]];
      } else {
        [_imgvWeatherFour setImage:[UIImage imageNamed:[self getImageName:fb withPrefix:@"small_"]]];
      }
      NSString *tempString = [NSString stringWithFormat:@"%@°/%@°",fd,fc];//最高/最低
      [_labelTemperatureFour setText:tempString];
      [_labelTimeFour setText:[self getWeekWithInt:([CalendarDateUtil getCurrentWeek]+4)%7]];
    } else if (i == 5) {
      if ([CommonMethods GetNowHour]<=16) {
        [_imgvWeatherFive setImage:[UIImage imageNamed:[self getImageName:fa withPrefix:@"small_"]]];
      } else {
        [_imgvWeatherFive setImage:[UIImage imageNamed:[self getImageName:fb withPrefix:@"small_"]]];
      }
      NSString *tempString = [NSString stringWithFormat:@"%@°/%@°",fd,fc];//最高/最低
      [_labelTemperatureFive setText:tempString];
      [_labelTimeFive setText:[self getWeekWithInt:([CalendarDateUtil getCurrentWeek]+5)%7]];
    }
  }
}

/**
 *  获取星期
 *
 *  @param weekI 星期代码
 *
 *  @return 星期
 */
- (NSString *)getWeekWithInt:(NSInteger)weekI {
  NSString *weekS = @"";
  switch (weekI) {
    case 1:
    {
      weekS = @"周日";
    }
      break;
    case 2:
    {
      weekS = @"周一";
    }
      break;
    case 3:
    {
      weekS = @"周二";
    }
      break;
    case 4:
    {
      weekS = @"周三";
    }
      break;
    case 5:
    {
      weekS = @"周四";
    }
      break;
    case 6:
    {
      weekS = @"周五";
    }
      break;
    case 0:
    {
      weekS = @"周六";
    }
      break;
    default:
      break;
  }
  return weekS;
}

/**
 *  获得天气图片
 *
 *  @param fWeather 天气代码
 *
 *  @return 图片名称
 */
- (NSString *)getWeatherImagePath:(NSString *)fWeather {
  NSInteger m = [fWeather integerValue];
  
  NSString *path = [NSString stringWithFormat:@"tianqi-s-d%ld",(long)m];
  return path;
}

/**
 *  获得天气状况
 *
 *  @param fw 天气索引
 *
 *  @return 天气内容
 */
- (NSString *)getWeatherContent:(NSString *)fw {
  NSDictionary *dictWeather = [CommonMethods getWeaterData];
  NSArray *array = [dictWeather allKeys];
  NSArray *arr = [dictWeather allValues];
  //获取当前值在数组所在的索引
  NSInteger index = [array indexOfObject:fw];
  //获取需要的code
  NSString *weatherCodeString = [arr objectAtIndex:index];
  return weatherCodeString;
}

/**
 *  获取天气图片
 *
 *  @param num    天气代码
 *  @param prefix 前缀
 *
 *  @return 天气图片名称
 */
- (NSString *)getImageName:(NSString *)num withPrefix:(NSString *)prefix{
  NSInteger ge = [num integerValue];
  NSString *nameFix = prefix;
  if (ge == 01) {
    nameFix = [prefix stringByAppendingString:@"cloudy"];
  } else if (ge == 02) {
    nameFix = [prefix stringByAppendingString:@"cloudyDay"];
  } else if (ge == 29 || ge == 30 || ge == 31 || ge == 20) {
    nameFix = [prefix stringByAppendingString:@"eind"];
  } else if (ge == 00) {
    nameFix = [prefix stringByAppendingString:@"fine"];
  } else if (ge == 18) {
    nameFix = [prefix stringByAppendingString:@"fog"];
  } else if (ge == 10 || ge == 11 || ge == 12 || ge == 23 || ge == 24 || ge == 25) {
    nameFix = [prefix stringByAppendingString:@"heavyRain"];
  } else if (ge == 99) {
    nameFix = [prefix stringByAppendingString:@"NA"];
  } else if (ge == 19) {
    nameFix = [prefix stringByAppendingString:@"sandstorm"];
  } else if (ge == 03) {
    nameFix = [prefix stringByAppendingString:@"shower"];
  } else if (ge == 06) {
    nameFix = [prefix stringByAppendingString:@"sleet"];
  } else if (ge == 13 || ge == 14 || ge == 15) {
    nameFix = [prefix stringByAppendingString:@"smallSnow"];
  } else if (ge == 16 || ge == 17 || ge == 26 || ge == 27 ||ge == 28) {
    nameFix = [prefix stringByAppendingString:@"snow"];
  } else if (ge == 05) {
    nameFix = [prefix stringByAppendingString:@"snowShower"];
  } else if (ge == 04) {
    nameFix = [prefix stringByAppendingString:@"thunderstorms"];
  } else if (ge == 53) {
    nameFix = [prefix stringByAppendingString:@"wind"];
  } else if (ge == 07 || ge == 8 || ge == 9 || ge == 21 || ge == 22) {
    nameFix = [prefix stringByAppendingString:@"rain"];
  }
  return nameFix;
}

/**
 *  获得温度图片
 *
 *  @param fNumber 数字
 *
 *  @return 温度图片名称
 */
- (NSString *)getNumberImagePath:(NSString *)fNumber {
  NSInteger m = [fNumber integerValue];
  NSString *path;
  if (m>=0 && m<=9) {
     path= [NSString stringWithFormat:@"%ld@2x.png",m];
  } else {
    path= @"NA@2x.png";
  }
  return path;
}

/**
 *  风运动动画
 *
 *  @param wseString 风力
 */
- (void)moveWindWithWSE:(NSString *)wseString {
  NSInteger m = [wseString integerValue];
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
  animation.fromValue = [NSNumber numberWithFloat:0];
  animation.toValue = [NSNumber numberWithFloat:2*M_PI];
  animation.speed = m/20.;
  animation.autoreverses = NO;
  animation.repeatCount = MAXFLOAT;
  [_imgvWindmill.layer addAnimation:animation forKey:@"shakeAnimation"];
}

#pragma mark - Events

- (IBAction)onTouchWithCithClick:(UIButton *)sender {
  [_buttonLocation setBackgroundImage:[UIImage imageNamed:@"home_weather_autoLocation@2x.png"] forState:0];
  [self getLocal];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  if (_weatherInfoEnd) {
    _weatherInfoEnd();
  }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  CLLocation *newLocation = [locations lastObject];
  CLGeocoder *myGecoder = [[CLGeocoder alloc] init];
  [myGecoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
    if (error == nil && [placemarks count]>0) {
      NSAssert([placemarks count]>=0, @"CLPlacemark == nil");
      CLPlacemark *placemark = [placemarks objectAtIndex:0];
      NSMutableArray *aArrayPlaceMark = [[NSMutableArray alloc] init];
      [aArrayPlaceMark addObject:placemark.administrativeArea?placemark.administrativeArea:@""];
      [aArrayPlaceMark addObject:placemark.locality?placemark.locality:@""];
      [self requestWeatherDataWithPlace:aArrayPlaceMark];
      [[NSUserDefaults standardUserDefaults] setObject:aArrayPlaceMark forKey:@"home_PlaceMark"];
      [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if (error == nil && [placemarks count]==0)
    {
      DLog(@"NO results were returned.");
    }
    else if (error != nil)
    {
      DLog(@"An error occurred = %@",error);
      if (_weatherInfoEnd) {
        _weatherInfoEnd();
      }
    }
  }];
  [self.myLocationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  switch (status) {
    case kCLAuthorizationStatusNotDetermined:
      if ([self.myLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.myLocationManager requestWhenInUseAuthorization];
      }
      break;
    case kCLAuthorizationStatusRestricted:
      break;
    default:
      break;
      
      
  }
}

@end