//
//  ViewController.h
//  iOrange
//
//  Created by XiangKai Yin on 5/18/15.
//  Copyright (c) 2015 yinxiangkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ControllerBase.h"
#import "UIWebPage.h"

@interface ViewController : ControllerBase

/**
 *  返回当前承载显示的view
 *
 *  @return view
 */
- (UIWebPage *)receiveToWebView;

/**
 *  刷新webview
 */
- (void)reloadWebView;

/**
 *  刷新天气数据
 */
- (void)reloadWeatherData;

@end

