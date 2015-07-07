//
//  CLLocationManagerEx.m
//  iWakeUp
//
//  Created by xiangkai yin on 14-5-8.
//  Copyright (c) 2014年 VeryApps. All rights reserved.
//

#import "CLLocationManagerEx.h"

@implementation CLLocationManager (CLLocationManagerEx)

- (void)hackLocationFix {
    float latitude = 39.9;
    float longitude = 116.3;  //这里可以是任意的经纬度值
    CLLocation *location= [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    [[self delegate] locationManager:self didUpdateLocations:[NSArray arrayWithObject:location]];
}

- (void)startUpdatingLocationNoEnabled {
    if ([CLLocationManager locationServicesEnabled]==NO||TARGET_IPHONE_SIMULATOR) {
        [self performSelector:@selector(hackLocationFix) withObject:nil afterDelay:0.1];
    }
}

@end
