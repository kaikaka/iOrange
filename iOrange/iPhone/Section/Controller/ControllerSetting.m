//
//  ControllerSetting.m
//  iOrange
//
//  Created by Yoon on 8/13/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import "ControllerSetting.h"

@interface ControllerSetting ()

@end

@implementation ControllerSetting
@synthesize  ViewContain = _ViewContain,ViewSettingSum = _ViewSettingSum,viewBottom = _viewBottom;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  _ViewContain.alpha = 0.;
  _ViewSettingSum.backgroundColor = RGBA(223., 223., 223., 0.9);
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onGestureTapTouch:)];
  [_ViewContain addGestureRecognizer:tapGesture];
}

#pragma mrak -  public methods

- (void)showSettingView:(void (^)())completion {
  if (completion) {
    completion();
    _viewBottom.alpha = 1.0;
    [UIView animateWithDuration:kDuration350ms animations:^{
      _ViewContain.alpha = 0.45;
    } completion:^(BOOL finished) {
      
    }];
  }
}

#pragma mark - events

- (void)onGestureTapTouch:(UITapGestureRecognizer *)recognizer {
  [UIView animateWithDuration:kDuration350ms animations:^{
    CGRect rect = _ViewSettingSum.frame;
    rect.origin.y = self.view.height;
    _ViewSettingSum.frame = rect;
  } completion:^(BOOL finished) {
    _ViewContain.alpha = 0.0;
    _viewBottom.alpha = 0.0;
    
    CGRect rect = _ViewSettingSum.frame;
    rect.origin.y = self.view.height - 200;
    _ViewSettingSum.frame = rect;
    
    [self.view removeFromSuperview];
  }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
