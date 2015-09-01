//
//  ControllerSuggest.m
//  iOrange
//
//  Created by Yoon on 9/1/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import "ControllerSuggest.h"

@interface ControllerSuggest ()

@end

@implementation ControllerSuggest

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  [_btnBack addTarget:self action:@selector(onTouchToBack:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - events

- (void)onTouchToBack:(UIButton *)sender {
  [self.navigationController popViewControllerAnimated:YES];
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
