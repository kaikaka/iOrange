//
//  ViewController.m
//  iOrange
//
//  Created by XiangKai Yin on 5/18/15.
//  Copyright (c) 2015 yinxiangkai. All rights reserved.
//

#import "ViewController.h"
#import "ViewWebSiteButton.h"

@interface ViewController () {
  
  __weak IBOutlet UIButton *_buttonSearch;
  __weak IBOutlet UIButton *_buttonTwoCode;
  
  __weak IBOutlet UIView *_viewContent;
  
}

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  [self showWebSitesInView];
}

#pragma mark- public Methods

- (void)showWebSitesInView {
  
  NSArray *arrayImageName = @[@"home_webSite_baidu",@"home_webSite_weibo",@"home_webSite_jianshu",
                              @"home_webSite_jd",@"home_webSite_amazon",@"home_webSite_tmall",
                              @"home_webSite_toutiao",@"home_webSite_ctrip",@"home_webSite_youku"];
  int totalloc=3;
  CGFloat appvieww=115;
  CGFloat appviewh=50;
  CGFloat margin=(self.view.frame.size.width-totalloc*appvieww)/(totalloc+1);
  
  for (int i = 0 ; i < [arrayImageName count]; i++) {
    int row=i/totalloc;//行号
    int loc=i%totalloc;//列号
    
    CGFloat appviewx=margin+(margin+appvieww)*loc;
    CGFloat appviewy=margin+(margin+appviewh)*row;
    
    ViewWebSiteButton *viewSiteButton = [[ViewWebSiteButton alloc] initWithFrame:
                                         CGRectMake(appviewx, appviewy, appvieww, appviewh)
                                          WithImgName:arrayImageName[i]];
    [_viewContent addSubview:viewSiteButton];
  }
}



@end
