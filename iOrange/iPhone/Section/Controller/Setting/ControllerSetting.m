//
//  ControllerSetting.m
//  iOrange
//
//  Created by Yoon on 8/13/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import "ApiConfig.h"
#import "ADOMark.h"
#import "ButtonSetting.h"
#import "ControllerSetting.h"
#import "ControllerHistory.h"
#import "ControllerSettingDetail.h"
#import "UIWebPage.h"
#import "ViewSetupButton.h"
#import "ViewController.h"

@interface ControllerSetting ()<UIScrollViewDelegate> {
  UIPageControl *_pageViewMark;
}

@end

@implementation ControllerSetting
@synthesize  ViewContain = _ViewContain,ViewSettingSum = _ViewSettingSum,viewBottom = _viewBottom,buttonDown = _buttonDown,scrollViewSetting = _scrollViewSetting;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  _ViewContain.alpha = 0.;
  _ViewSettingSum.backgroundColor = RGBA(241., 241., 241., 0.9);
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onGestureTapTouch:)];
  [_ViewContain addGestureRecognizer:tapGesture];
  
  [_buttonDown addTarget:self action:@selector(onTouchWithButtonDown:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mrak -  public methods

- (void)showSettingView:(void (^)())completion {
  if (completion) {
    completion();
    _viewBottom.alpha = 1.0;
    [UIView animateWithDuration:kDuration350ms animations:^{
      _ViewContain.alpha = 0.45;
    } completion:^(BOOL finished) {
      [self expandNineSetupButton];
    }];
  }
}

#pragma mark - private methods 

- (void)expandNineSetupButton {
  if (_scrollViewSetting) {
    return;
  }
  UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.ViewSettingSum.width, self.ViewSettingSum.height)];
  [scrollView setContentSize:CGSizeMake(self.ViewSettingSum.width*2, 0)];
  [scrollView setPagingEnabled:YES];
  [scrollView setBackgroundColor:[UIColor clearColor]];
  [scrollView setDelegate:self];
  [scrollView setShowsHorizontalScrollIndicator:NO];
  [self.ViewSettingSum addSubview:scrollView];
  _scrollViewSetting = scrollView;
  
  UIPageControl *pageView = [[UIPageControl alloc] initWithFrame:CGRectMake(0, scrollView.height-25, scrollView.width, 18)];
  pageView.currentPageIndicatorTintColor = RGBA(67., 134., 203., 1.);
  pageView.pageIndicatorTintColor = RGBA(163., 187., 220., 1.);
  pageView.numberOfPages = 2;
  pageView.currentPage = 0;
  [_ViewSettingSum insertSubview:pageView belowSubview:scrollView];
  _pageViewMark = pageView;
  
  NSArray *imageNameArray = @[@"home_setting_addbookmark@2x",@"home_setting_bookmark@2x",
                              @"home_setting_nopicture_noable@2x",@"home_setting_nofull@2x",
                              @"home_setting_reload@2x",@"home_setting_update@2x",
                              @"home_setting_feedback@2x",@"home_setting_share@2x",
                              @"home_setting_noprivacy@2x",@"home_setting_setup@2x"];
  NSArray *labelTextArray = @[@"添加书签",@"书签/历史",@"无图模式",@"全屏模式",@"刷新",@"更新",@"反馈",@"分享",@"无痕模式",@"设置"];
  
  int totalloc = 4;
  CGFloat appvieww = self.view.width/4;
  CGFloat appviewh = (self.ViewSettingSum.height - 20)/2;
  CGFloat margin = 0;
  
  for (int i = 0; i < imageNameArray.count; i++) {
    int row=(i-(i>4?5:0))/totalloc;//行号
    int loc=(i-(i>4?5:0))%totalloc;//列号
    
    CGFloat appviewx=(margin+appvieww)*loc+(i>4?self.ViewSettingSum.width:0);//（间距加上宽度）乘以列号 == x 坐标
    CGFloat appviewy= (margin+appviewh)*row;
    
    ViewSetupButton *viewButton = [[ViewSetupButton alloc] initWithFrame:CGRectMake(appviewx, appviewy, appvieww, appviewh)];
    [scrollView addSubview:viewButton];
    [viewButton setTag:100+i];
    [viewButton.buttonWithSelect setTag:10+i];
    [viewButton setImageName:imageNameArray[i] labelText:labelTextArray[i]];
    [viewButton.buttonWithSelect addTarget:self action:@selector(onTouchWithSelect:) forControlEvents:UIControlEventTouchUpInside];
  }
  
}

#pragma mark - events

- (void)onGestureTapTouch:(UITapGestureRecognizer *)recognizer {
  [UIView animateWithDuration:kDuration350ms animations:^{
    CGRect rect = _ViewSettingSum.frame;
    rect.origin.y = self.view.height;
    _ViewSettingSum.frame = rect;
    
    rect = _viewBottom.frame;
    rect.origin.y = self.view.height;
    _viewBottom.frame = rect;
    
  } completion:^(BOOL finished) {
    _ViewContain.alpha = 0.0;
    _viewBottom.alpha = 0.0;
    
    CGRect rect = _ViewSettingSum.frame;
    rect.origin.y = self.view.height - 200;
    _ViewSettingSum.frame = rect;
    
    rect = _ViewSettingSum.frame;
    rect.origin.y = self.view.height - 50;
    _viewBottom.frame = rect;
    
    [self.view removeFromSuperview];
    
  }];
}

- (void)onTouchWithButtonDown:(UIButton *)sender {
  [self onGestureTapTouch:nil];
}

- (void)onTouchWithSelect:(UIButton *)sender {
  sender.selected = !sender.selected;
  ViewSetupButton *viewBtn = (ViewSetupButton *)sender.superview;
  if (sender.tag == 12 && sender.selected == YES) {
    [viewBtn.imgvSetting setImage:[UIImage imageNamed:@"home_setting_nopicture_able@2x"]];
  } else if (sender.tag == 12 && sender.selected == NO) {
    [viewBtn.imgvSetting setImage:[UIImage imageNamed:@"home_setting_nopicture_noable@2x"]];
  } else if (sender.tag == 13 && sender.selected == YES) {
    [viewBtn.imgvSetting setImage:[UIImage imageNamed:@"home_setting_full@2x"]];
  } else if (sender.tag == 13 && sender.selected == NO) {
    [viewBtn.imgvSetting setImage:[UIImage imageNamed:@"home_setting_nofull@2x"]];
  } else if (sender.tag == 18 && sender.selected == YES) {
    [viewBtn.imgvSetting setImage:[UIImage imageNamed:@"home_setting_privacy@2x"]];
  } else if (sender.tag == 18 && sender.selected == NO) {
    [viewBtn.imgvSetting setImage:[UIImage imageNamed:@"home_setting_noprivacy@2x"]];
  }
  
  switch (sender.tag) {
    case HomeSettingTypeAddBookMark: {
      ViewController *viewCon = (ViewController *)_delegateMian;
      UIWebPage *webpage = [viewCon receiveToWebView];
      if (webpage) {
        NSString *host = [NSString stringWithFormat:@"http://%@/favicon.ico", [NSURL URLWithString:webpage.link].host];
        ModelMark *model = [ModelMark modelMark];
        model.mDatenow = [[NSDate date] timeIntervalSince1970];
        model.mLink = webpage.link;
        model.mIcon = host;
        model.mTitle = webpage.title;
        BOOL isSuccess = [ADOMark InsertWithModelList:model];
        NSString *message;
        if (isSuccess) {
          message = @"添加成功!";
        } else {
          message = @"添加失败,请重试!";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
      }
    }
      break;
    case HomeSettingTypeBookMark: {
      ControllerHistory *controllerHy = [ControllerHistory loadFromStoryboard];
      ViewController *viewCon = (ViewController *)_delegateMian;
      [viewCon.navigationController pushViewController:controllerHy animated:YES];
    }
      break;
    case HomeSettingTypeSetup: {
      ControllerSettingDetail *controllerDetail = [ControllerSettingDetail loadFromStoryboard];
      ViewController *viewCon = (ViewController *)_delegateMian;
      [viewCon.navigationController pushViewController:controllerDetail animated:YES];
    }
      break;
      
    default:
      break;
  }
  dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * kDuration250ms);
  dispatch_after(when, dispatch_get_main_queue(), ^{
    [self onTouchWithButtonDown:nil];
  });
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  CGFloat f = scrollView.contentOffset.x /scrollView.width;
  _pageViewMark.currentPage = f;
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
