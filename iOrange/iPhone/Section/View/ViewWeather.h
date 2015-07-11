//
//  ViewWeather.h
//  iOrange
//
//  Created by XiangKai Yin on 7/5/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CLLocationManagerEx.h"

@interface ViewWeather : UIScrollView <CLLocationManagerDelegate>

@property (nonatomic,weak)IBOutlet UIButton *buttonLocation;
@property (nonatomic,weak)IBOutlet UIButton *buttonCityName;
@property (nonatomic,weak)IBOutlet UIButton *buttonShare;
@property (nonatomic,weak)IBOutlet UIImageView *imageTemperatureFirst;
@property (nonatomic,weak)IBOutlet UIImageView *imageTemperatureSecond;
@property (nonatomic,weak)IBOutlet UIImageView *imageBigWeather;
@property (nonatomic,weak)IBOutlet UILabel *labelTemperature;
@property (nonatomic,weak)IBOutlet UILabel *labelWeather;
@property (nonatomic,weak)IBOutlet UIImageView *imgvPMExp;
@property (nonatomic,weak)IBOutlet UILabel *labelAirLevel;
@property (nonatomic,weak)IBOutlet UIImageView *imgvWindmill;
@property (nonatomic,weak)IBOutlet UILabel *labelWindLevel;

@property (nonatomic,weak)IBOutlet UIImageView *imgvWeatherOne;
@property (nonatomic,weak)IBOutlet UILabel *labelTemperatureOne;
@property (nonatomic,weak)IBOutlet UILabel *labelTimeOne;

@property (nonatomic,weak)IBOutlet UIImageView *imgvWeatherTwo;
@property (nonatomic,weak)IBOutlet UILabel *labelTemperatureTwo;
@property (nonatomic,weak)IBOutlet UILabel *labelTimeTwo;

@property (nonatomic,weak)IBOutlet UIImageView *imgvWeatherThree;
@property (nonatomic,weak)IBOutlet UILabel *labelTemperatureThree;
@property (nonatomic,weak)IBOutlet UILabel *labelTimeThree;

@property (nonatomic,weak)IBOutlet UIImageView *imgvWeatherFour;
@property (nonatomic,weak)IBOutlet UILabel *labelTemperatureFour;
@property (nonatomic,weak)IBOutlet UILabel *labelTimeFour;

@property (nonatomic,weak)IBOutlet UIImageView *imgvWeatherFive;
@property (nonatomic,weak)IBOutlet UILabel *labelTemperatureFive;
@property (nonatomic,weak)IBOutlet UILabel *labelTimeFive;

@property (nonatomic,strong) CLLocationManager *myLocationManager;
@property (nonatomic,strong)NSMutableDictionary *weatherDictionary;
@property (nonatomic,strong)NSString *nowTempToString;

- (void)setUp;

@end
