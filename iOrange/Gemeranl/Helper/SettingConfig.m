//
//  SettingConfig.m
//  iOrange
//
//  Created by Yoon on 9/1/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import "SettingConfig.h"

static SettingConfig *_appConfig;
@implementation SettingConfig
@synthesize
interfaceOrientation = _interfaceOrientation,
rotateLock = _rotateLock,
brightValue = _brightValue,
nTraceBrowser = _nTraceBrowser;

+(SettingConfig *) defaultSettingConfig {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _appConfig = [[SettingConfig alloc] init];
  });
  return _appConfig;
}

-(void) setup {
  //初始化屏幕方向
  _interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
  
  
  NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
  
  if ([userDefault objectForKey:LightBrowserRotateLock]) {
    _rotateLock = [userDefault boolForKey:LightBrowserRotateLock];
  }else{
    _rotateLock = NO;
    
    [userDefault setBool:_rotateLock forKey:LightBrowserRotateLock];
    [userDefault synchronize];
  }
  
  if ([userDefault objectForKey:LightBrowserNTraceBrowser]) {
    _nTraceBrowser = [userDefault boolForKey:LightBrowserNTraceBrowser];
  }else{
    _nTraceBrowser = NO;
    
    [userDefault setBool:_nTraceBrowser forKey:LightBrowserNTraceBrowser];
    [userDefault synchronize];
  }
  
  
  if ([userDefault objectForKey:LightBrowserNoPicture]) {
    _noPicture = [userDefault boolForKey:LightBrowserNoPicture];
  }else{
    _noPicture = NO;
    
    [userDefault setBool:_noPicture forKey:LightBrowserNoPicture];
    [userDefault synchronize];
  }
  
  if ([userDefault objectForKey:LightBrowserBrightValue]) {
    [self setBrightValue:[userDefault floatForKey:LightBrowserBrightValue]];
  }else{
    [self setBrightValue:0];
    
    [userDefault setFloat:_brightValue forKey:LightBrowserBrightValue];
    [userDefault synchronize];
  }

}

-(void)setRotateLock:(BOOL)rotateLock {
  _rotateLock = rotateLock;
  
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setBool:_rotateLock forKey:LightBrowserRotateLock];
  [userDefaults synchronize];
}


-(void)setBrightValue:(CGFloat) brightValue {
  _brightValue = brightValue;
  
  
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setFloat:_brightValue forKey:LightBrowserBrightValue];
  [userDefaults synchronize];
  
  CGFloat alpha = _brightValue;
  
  _layerBrightMark.backgroundColor = [[UIColor colorWithWhite:0 alpha:alpha] CGColor];
}


-(void)setNTraceBrowser:(BOOL)nTraceBrowser {
  _nTraceBrowser = nTraceBrowser;
  
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setBool:_nTraceBrowser forKey:LightBrowserNTraceBrowser];
  [userDefaults synchronize];
}


-(void)setNoPicture:(BOOL)noPicture {
  _noPicture = noPicture;
  
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setBool:_noPicture forKey:LightBrowserNoPicture];
  [userDefaults synchronize];
}

- (void)setFontSize:(NSInteger)fontSize {
  _fontSize = fontSize;
  
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setBool:_fontSize forKey:LightBrowserFontSizeChanged];
  [userDefaults synchronize];
}

- (void)setIsEnableWebButton:(BOOL)isEnableWebButton {
  _isEnableWebButton = isEnableWebButton;
  
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setBool:isEnableWebButton forKey:LightBrowserEnableWebButton];
  [userDefaults synchronize];
}

NSString * const LightBrowserRotateLock = @"LightBrowserRotateLock";
NSString * const LightBrowserBrightValue = @"LightBrowserBrightValue";
NSString * const LightBrowserNTraceBrowser = @"LightBrowserNTraceBrowser";
NSString * const LightBrowserUIModel = @"LightBrowserUIModel";
NSString * const LightBrowserNoPicture = @"LightBrowserNoPicture";
NSString * const LightBrowserRememberAccountAndPwd = @"LightBrowserRememberAccountAndPwd";

NSString * const LightBrowserFontSizeChanged = @"LightBrowserFontSizeChanged";
NSString * const LightBrowserEnableWebButton = @"LightBrowserEnableWebButton";

#pragma mark CHKeychain
NSString * const KEY_REMENBER_ACCOUNT_PWD = @"com.LightBrowser.app.accountpwd";
NSString * const KEY_REMENBER_ACCOUNT = @"com.LightBrowser.app.account";
NSString * const KEY_REMENBER_PWD = @"com.LightBrowser.app.pwd";

NSString * const KEY_MODEL_USER = @"com.LightBrowser.app.modelUser";
NSString * const KEY_MODEL_USER_UID = @"com.LightBrowser.app.modelUserUID";
NSString * const KEY_USER_SHARE_TYPE = @"com.LightBrowser.app.userShareType";

@end
