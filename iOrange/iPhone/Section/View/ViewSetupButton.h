//
//  ViewSetupButton.h
//  iOrange
//
//  Created by Yoon on 8/14/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonSetting.h"

@interface ViewSetupButton : UIView

@property (nonatomic,strong)ButtonSetting *buttonWithSelect;
@property (nonatomic,strong)UIImageView *imgvSetting;

- (void)setImageName:(NSString *)imageName labelText:(NSString *)labelText;

- (void)setImageEnable:(BOOL)isEable;

@end
