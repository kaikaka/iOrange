//
//  ControllerBase.m
//  iOrange
//
//  Created by XiangKai Yin on 5/20/15.
//  Copyright (c) 2015 yinxiangkai. All rights reserved.
//

#import "ControllerBase.h"

@interface ControllerBase () {
  __weak UIView *_viewSelf;
}

@end

@implementation ControllerBase

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  _viewSelf = self.view;
}

+ (instancetype)loadFromStoryboard {
  id vcself = nil;
  static UIStoryboard *stroyboard = nil;
  if (!stroyboard) {
    if (isPad)
      stroyboard = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
    else
      stroyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
  }
  if (stroyboard) {
    vcself = [stroyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
  }
  return vcself;
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
