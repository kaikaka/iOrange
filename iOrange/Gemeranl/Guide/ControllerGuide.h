//
//  ControllerGuide.h
//  browser9374
//
//  Created by xiangkai yin on 14-6-14.
//  Copyright (c) 2014年 arBao. All rights reserved.
//
#ifndef IsPortrait
#define IsPortrait UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)
#endif

#import <UIKit/UIKit.h>
@class UIImageViewEx;
@class Rotation_IOS6;
@interface ControllerGuide : UIViewController

@end

@interface UIImageView (UIImageViewEx)

- (void)setImageWithName:(NSString *)imgName;
- (void)setImageWithName:(NSString *)imgName ofType:(NSString *)ext;

@end

@interface UINavigationController (Rotation_IOS6)

@end