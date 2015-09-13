//
//  ControllerSettingDetail.m
//  iOrange
//
//  Created by Yoon on 8/17/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import "ApiConfig.h"
#import "ControllerSettingDetail.h"
#import "ControllerFontChanged.h"
#import "ControllerAbout.h"
#import "SettingConfig.h"

@interface ControllerSettingDetail ()<UITableViewDelegate,UITableViewDataSource>{
  UISwitch *_switchX;
}

@end

@implementation ControllerSettingDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
  [_btnBack addTarget:self action:@selector(onTouchToBack:) forControlEvents:UIControlEventTouchUpInside];
  [_tableContent setDelegate:self];
  [_tableContent setDataSource:self];
}

#pragma mark - events

- (void)onTouchToBack:(UIButton *)sender {
  [self.navigationController popViewControllerAnimated:YES];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)onTouchToSelect:(UIButton *)sender {
  [_switchX setOn:NO animated:YES];
  [[SettingConfig defaultSettingConfig] setFontSize:0];
  [[SettingConfig defaultSettingConfig] setIsEnableWebButton:NO];
  [[NSNotificationCenter defaultCenter] postNotificationName:kBrowserControllerAtPageButton object:[NSNumber numberWithBool:NO]];
}

- (void)onTouchAtValueChanged:(UISwitch *)sender {
  [[SettingConfig defaultSettingConfig] setIsEnableWebButton:sender.on];
  [[NSNotificationCenter defaultCenter] postNotificationName:kBrowserControllerAtPageButton object:[NSNumber numberWithBool:sender.on]];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 3;
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"cellIdentifier";
  UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  NSString *textString;
  switch (indexPath.row) {
    case 0:
      textString = @"字体大小";
      break;
    case 1:
      textString = @"关于我们";
      break;
    case 2:
      textString = @"启用页面按钮";
      break;
      
    default:
      break;
  }
  cell.textLabel.text = textString;
  if (indexPath.row != 2) {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  } else if(indexPath.row == 2){
    UISwitch *switchw = [[UISwitch alloc] initWithFrame:CGRectMake(tableView.width - 60, 7, 60, 30)];
    [switchw addTarget:self action:@selector(onTouchAtValueChanged:) forControlEvents:UIControlEventValueChanged];
    [switchw setOn:[[SettingConfig defaultSettingConfig] isEnableWebButton] animated:YES];
    [cell addSubview:switchw];
    _switchX = switchw;
  }
  return cell;
}

- (CGFloat)tableView:(nonnull UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return 50.;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  UIViewController *controller;
  switch (indexPath.row) {
    case 0:
      controller = [ControllerFontChanged loadFromStoryboard];
      break;
    case 1:
      controller = [ControllerAbout loadFromStoryboard];
      break;
    default:
      break;
  }
  [self.navigationController pushViewController:controller animated:YES];
}

- (UIView *)tableView:(nonnull UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 50)];
  [view setBackgroundColor:RGBA(232., 232., 232., 0.7)];
  UIButton *button = [UIButton buttonWithType:0];
  [button setFrame:CGRectMake(0, 6, tableView.width, 38)];
  [button setTitle:@"恢复默认设置" forState:0];
  [button setTitleColor:[UIColor blackColor] forState:0];
  [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
  [button setBackgroundColor:[UIColor whiteColor]];
  [button addTarget:self action:@selector(onTouchToSelect:) forControlEvents:UIControlEventTouchUpInside];
  [view addSubview:button];
  return view;
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
