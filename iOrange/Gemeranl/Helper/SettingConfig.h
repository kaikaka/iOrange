//
//  SettingConfig.h
//  iOrange
//
//  Created by Yoon on 9/1/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingConfig : NSObject

@property (nonatomic) BOOL noPicture;//无图模式
@property (nonatomic) BOOL fullScreen;//全屏模式
@property(nonatomic) BOOL nTraceBrowser;//无痕模式

@property(nonatomic, assign) UIInterfaceOrientation interfaceOrientation;//(旋转方向)下个版本
@property(nonatomic) BOOL rotateLock;//(锁定方向)下个版本
@property(nonatomic) CGFloat brightValue;//(亮度) 下个版本
@property(nonatomic, assign) CALayer *layerBrightMark;//（亮度）需控制的UI

+(SettingConfig *) defaultSettingConfig;

-(void) setup;

@end
extern NSString * const LightBrowserRotateLock;
extern NSString * const LightBrowserBrightValue;
extern NSString * const LightBrowserNTraceBrowser;
extern NSString * const LightBrowserUIModel;
extern NSString * const LightBrowserNoPicture;
extern NSString * const LightBrowserRememberAccountAndPwd;


#pragma mark CHKeychain
extern NSString * const KEY_REMENBER_ACCOUNT_PWD;
extern NSString * const KEY_REMENBER_ACCOUNT;
extern NSString * const KEY_REMENBER_PWD;

extern NSString * const KEY_MODEL_USER;
extern NSString * const KEY_MODEL_USER_UID;
extern NSString * const KEY_USER_SHARE_TYPE;