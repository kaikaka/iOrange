//
//  ControllerSetting.h
//  iOrange
//
//  Created by Yoon on 8/13/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ControllerSetting : UIViewController

@property (weak, nonatomic,readonly) IBOutlet UIView *ViewContain;
@property (weak, nonatomic,readonly) IBOutlet UIView *ViewSettingSum;
@property (weak, nonatomic,readonly) IBOutlet UIView *viewBottom;


- (void)showSettingView:(void(^)())completion;

@end
