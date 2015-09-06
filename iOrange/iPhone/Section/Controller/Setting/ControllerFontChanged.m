//
//  ControllerFontChanged.m
//  iOrange
//
//  Created by Yoon on 8/26/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import "ApiConfig.h"
#import "ControllerFontChanged.h"
#import "SettingConfig.h"

@interface ControllerFontChanged ()<UITableViewDataSource,UITableViewDelegate> {
}

@end

@implementation ControllerFontChanged

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [_btnBack addTarget:self action:@selector(onTouchToBack:) forControlEvents:UIControlEventTouchUpInside];
  [_tableContent setDelegate:self];
  [_tableContent setDataSource:self];
}

#pragma mark - events

- (void)onTouchToBack:(UIButton *)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma marl - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 4;
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
      textString = @"小号(默认)";
      break;
    case 1:
      textString = @"中号";
      break;
    case 2:
      textString = @"大号";
      break;
    case 3:
      textString = @"超大号";
      break;
      
    default:
      break;
  }
  cell.textLabel.text = textString;
  if (indexPath.row == [SettingConfig defaultSettingConfig].fontSize) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  return cell;
}

- (CGFloat)tableView:(nonnull UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return 50.;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  UITableViewCell *cell= [tableView cellForRowAtIndexPath:indexPath];
  if (cell.accessoryType == UITableViewCellAccessoryNone) {
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    UITableViewCell *cell1;
    UITableViewCell *cell2;
    UITableViewCell *cell3;
    switch (indexPath.row) {
      case 0: {
        cell1= [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell2= [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        cell3= [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
      }
        break;
      case 1: {
        cell1= [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell2= [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        cell3= [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
      }
        break;
        
      case 2: {
        cell1= [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell2= [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell3= [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
      }
        break;
      case 3: {
        cell1= [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell2= [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell3= [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
      }
        break;
        
      default:
        break;
    }
    [cell1 setAccessoryType:UITableViewCellAccessoryNone];
    [cell2 setAccessoryType:UITableViewCellAccessoryNone];
    [cell3 setAccessoryType:UITableViewCellAccessoryNone];
    
  } else {
      [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
  }
  [[NSNotificationCenter defaultCenter] postNotificationName:kBrowserControllerFont object:[NSNumber numberWithInteger:indexPath.row]];
  [[SettingConfig defaultSettingConfig] setFontSize:indexPath.row];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(nonnull UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 50)];
  [view setBackgroundColor:RGBA(232., 232., 232., 0.7)];
  UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
  [label setTextAlignment:NSTextAlignmentCenter];
  [label setFont:Font_Size(13.)];
  [label setText:@"字体过大可能会导致个别网页版面错乱."];
  [label setTextColor:[UIColor grayColor]];
  [view addSubview:label];
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
