//
//  ViewSetupButton.m
//  iOrange
//
//  Created by Yoon on 8/14/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import "ButtonSetting.h"
#import "SettingConfig.h"
#import "ViewSetupButton.h"

@interface ViewSetupButton () {
  UILabel *_labelSetting;
}

@end

@implementation ViewSetupButton

- (id)init {
  self = [self init];
  if (self) {
    [self setup];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setup];
  }
  return self;
}

#pragma mark - public methods

- (void)setImageName:(NSString *)imageName labelText:(NSString *)labelText {
  if (imageName) {
    [_imgvSetting setImage:[UIImage imageNamed:imageName]];
  }
  if (labelText) {
    [_labelSetting setText:labelText];
  }
  SettingConfig *config = [SettingConfig defaultSettingConfig];;
  switch (self.buttonWithSelect.tag) {
    case 12:
      self.buttonWithSelect.selected = config.noPicture;
      if (config.noPicture) {
        [self.imgvSetting setImage:[UIImage imageNamed:@"home_setting_nopicture_able@2x"]];
      } else {
        [self.imgvSetting setImage:[UIImage imageNamed:@"home_setting_nopicture_noable@2x"]];
      }
      break;
    case 13:
      self.buttonWithSelect.selected = config.fullScreen;
      if (config.fullScreen) {
        [self.imgvSetting setImage:[UIImage imageNamed:@"home_setting_full@2x"]];
      } else {
        [self.imgvSetting setImage:[UIImage imageNamed:@"home_setting_nofull@2x"]];
      }
      break;
    case 18:
      self.buttonWithSelect.selected = config.nTraceBrowser;
      if (config.nTraceBrowser) {
        [self.imgvSetting setImage:[UIImage imageNamed:@"home_setting_privacy@2x"]];
      } else {
        [self.imgvSetting setImage:[UIImage imageNamed:@"home_setting_noprivacy@2x"]];
      }
      break;
    default:
      break;
  }
}

- (void)setImageEnable:(BOOL)isEable {
  if (isEable) {
    [_imgvSetting setAlpha:1.];
    [_labelSetting setTextColor:[UIColor blackColor]];
  } else {
    [_imgvSetting setAlpha:0.6];
    [_labelSetting setTextColor:[UIColor grayColor]];
  }
  [_buttonWithSelect setEnabled:isEable];
}

#pragma mark - init

- (void)setup {
  
  CGRect rectImage = CGRectMake(0, 0, 80., 70.);
  
  UIImageView *imgvShow = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - rectImage.size.width/2)/2, 5, rectImage.size.width/2, rectImage.size.height/2)];
  [self addSubview:imgvShow];
  _imgvSetting = imgvShow;
  
  UILabel *labelMark = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imgvShow.frame), self.width, 20)];
  labelMark.textAlignment = NSTextAlignmentCenter;
  labelMark.font = Font_Size(13.);
  [self addSubview:labelMark];
  [labelMark setBackgroundColor:[UIColor clearColor]];
  _labelSetting = labelMark;
  
  ButtonSetting *button = [ButtonSetting buttonWithType:0];
  [button setFrame:self.bounds];
  _buttonWithSelect = button;
  [self addSubview:button];
}

#pragma mark - events

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
