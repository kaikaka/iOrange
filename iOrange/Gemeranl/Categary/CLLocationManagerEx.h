//
//  CLLocationManagerEx.h
//  iWakeUp
//
//  Created by xiangkai yin on 14-5-8.
//  Copyright (c) 2014年 VeryApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CLLocationManager (CLLocationManagerEx)

- (void)startUpdatingLocationNoEnabled;

@end
