//
//  ControllerHistory.m
//  iOrange
//
//  Created by Yoon on 8/16/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import "ApiConfig.h"
#import "ADOHistory.h"
#import "ADOMark.h"
#import "ControllerHistory.h"
#import "CalendarDateUtil.h"
#import "CellForHistory.h"
#import "ModelHistory.h"
#import "ModelMark.h"

@interface ControllerHistory ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate> {
  NSInteger _intTimeDays;//所有不同的天数
  NSArray *_arrayHistoryData;//所有历史数据
  NSArray *_arrayRowData;//每个区里的所有row数据(字符串)(tableHistory)
  NSMutableArray *_arrayMarkData;//所有书签数据
}

@end

@implementation ControllerHistory

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
  [_btnBack addTarget:self action:@selector(onTouchToBack:) forControlEvents:UIControlEventTouchUpInside];
  [_btnEdit addTarget:self action:@selector(onTouchWithEditAndClear:) forControlEvents:UIControlEventTouchUpInside];
  [_segmentBomkHisy addTarget:self action:@selector(onTouchWithSegemnt:) forControlEvents:UIControlEventValueChanged];
  
  [self setupData];
}

#pragma mark - private methods 

- (void)setupDataTable {
  _tableBookmark.delegate = self;
  _tableBookmark.dataSource = self;
  [_tableBookmark setTag:13];
  [_tableBookmark setTableFooterView:[[UIView alloc] init]];
  
  _tableHistory.delegate = self;
  _tableHistory.dataSource = self;
  [_tableHistory setTag:14];
  [_tableHistory setTableFooterView:[[UIView alloc] init]];
}

- (void)setupData {
  NSArray *arrayHistory = [NSArray arrayWithArray:[ADOHistory queryAllHistory]];
  [self receiveDiffDays:arrayHistory];
  
  _arrayMarkData = [NSMutableArray arrayWithArray:[ADOMark queryAllMark]];
  [self setViewMarkbook];
}

- (void)receiveDiffDays:(NSArray *)arrayHistory {
  _arrayHistoryData = arrayHistory;
  //获取不同的天数
  NSMutableArray *mutableModel = [NSMutableArray array];
  for (ModelHistory *modelH in arrayHistory) {
    NSInteger month = [CalendarDateUtil getMonthWithDate:[NSDate dateWithTimeIntervalSince1970:modelH.hDatenow]];
    NSInteger day = [CalendarDateUtil getDayWithDate:[NSDate dateWithTimeIntervalSince1970:modelH.hDatenow]];
    NSString *mDay = [NSString stringWithFormat:@"%ld,%ld",month,day];
    [mutableModel addObject:mDay];
  }
  NSSet *set = [NSSet setWithArray:mutableModel];
  NSArray *desc = @[[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]];
  NSArray *arraySet = [set sortedArrayUsingDescriptors:desc];
  _arrayRowData = [NSArray arrayWithArray:arraySet];
  _intTimeDays = arraySet.count;
  [self setupDataTable];
}

- (NSArray *)receiveCurrentDayHistory:(NSString *)dateString {
  /**
   *  思路：先得到目标日期的月和日，然后从数组里面比较获取所有等于这天的历史纪录
   */
  NSArray *array = [dateString componentsSeparatedByString:@","];
  NSInteger nowMonth = [array[0] integerValue];
  NSInteger nowDay = [array[1] integerValue];
  NSMutableArray *mutableArray = [NSMutableArray array];
  for (ModelHistory *model in _arrayHistoryData) {
    NSDate *dateCurrent = [NSDate dateWithTimeIntervalSince1970:model.hDatenow];
    NSInteger currentMonth = [CalendarDateUtil getMonthWithDate:dateCurrent];
    if (currentMonth == nowMonth) {
      NSInteger currentDay = [CalendarDateUtil getDayWithDate:dateCurrent];
      if (nowDay == currentDay) {
        [mutableArray addObject:model];
      }
    }
  }
  return mutableArray;
}

- (void)setViewMarkbook {
  if (_segmentBomkHisy.selectedSegmentIndex == 0) {
    _viewNoHistory.alpha = 0.;
    if (_arrayMarkData.count == 0) {
      _viewNoMarkbook.alpha = 1.;
    } else {
      _viewNoMarkbook.alpha = 0.;
    }
  } else if (_segmentBomkHisy.selectedSegmentIndex == 1) {
    _viewNoMarkbook.alpha = 0.;
    if (_arrayHistoryData.count == 0) {
      _viewNoHistory.alpha = 1.;
    } else {
      _viewNoHistory.alpha = 0.;
    }
  }
  
}

#pragma mark - events

- (void)onTouchToBack:(UIButton *)sender {
  [self.navigationController popViewControllerAnimated:YES];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)onTouchWithEditAndClear:(UIButton *)sender {
  NSString *stringTitle;
  NSString *stringMessage;
  NSInteger alertTag = 0;
  if (_segmentBomkHisy.selectedSegmentIndex == 0) {
    stringTitle = @"您确定要删除全部书签吗？";
    stringMessage = @"(您可以滑动删除单个书签)";
    alertTag = 10;
  } else if(_segmentBomkHisy.selectedSegmentIndex == 1) {
    stringTitle = @"您确定要删除全部历史吗？";
    stringMessage = @"(您可以滑动删除单个历史记录)";
    alertTag = 20;
  }
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:stringTitle message:stringMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
  [alert setTag:alertTag];
  [alert show];
}

- (void)onTouchWithSegemnt:(UISegmentedControl *)sender {
  [self setViewMarkbook];
  [_viewHome exchangeSubviewAtIndex:1 withSubviewAtIndex:2];
  if (sender.selectedSegmentIndex == 0) {
    _arrayMarkData = [NSMutableArray arrayWithArray:[ADOMark queryAllMark]];
    [self setViewMarkbook];
    [_tableBookmark reloadData];
  } else {
  }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) {
    if (alertView.tag == 10) {
      [ADOMark deleteAllRecord];
      _arrayMarkData = [NSMutableArray array];
      [_tableBookmark reloadData];
    } else if (alertView.tag == 20) {
      [ADOHistory deleteAllRecord];
      _arrayHistoryData = [NSArray array];
      [_tableHistory reloadData];
    }
  }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView {
  if (tableView == _tableHistory) {
    return _intTimeDays;
  }
  return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (tableView == _tableHistory) {
    NSString *modelString = [_arrayRowData objectAtIndex:section];
    NSArray *arr = [self receiveCurrentDayHistory:modelString];
    return arr.count;
  }
  return _arrayMarkData.count;
}

- (CGFloat)tableView:(nonnull UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (tableView == _tableHistory) {
    return 30.;
  }
  return 0;
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"cellIdentifier";
  CellForHistory * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (!cell) {
    cell = [[CellForHistory alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  CellForHistory *cellHis = (CellForHistory *)cell;
  if (tableView == _tableHistory) {
    NSString *modelString = [_arrayRowData objectAtIndex:indexPath.section];
    NSArray *arrModel = [self receiveCurrentDayHistory:modelString];
    ModelHistory *model = [arrModel objectAtIndex:indexPath.row];
    cellHis.labelLinkTitle.text = model.hTitle;
    cellHis.labelLinkLink.text = model.hLink;
    [cellHis setIconAtUrl:model.hLink];
    [cellHis setModelHistroy:model];
  } else {
    [cell.btnRight setHidden:YES];
    ModelMark *modelMark = [_arrayMarkData objectAtIndex:indexPath.row];
    cellHis.labelLinkTitle.text = modelMark.mTitle;
    cellHis.labelLinkLink.text = modelMark.mLink;
    [cellHis setIconAtUrl:modelMark.mLink];
  }
  
  return cell;
}

- (UIView *)tableView:(nonnull UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (tableView == _tableHistory) {
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:RGBA(210., 210., 210., 1.)];
    NSString *modelString = [_arrayRowData objectAtIndex:section];
    NSArray *array = [modelString componentsSeparatedByString:@","];
    NSInteger nowMonth = [array[0] integerValue];
    NSInteger nowDay = [array[1] integerValue];
    
    UILabel *labelDate = [[UILabel alloc] initWithFrame:CGRectMake(15, 2, 200, 26)];
    [labelDate setText:[NSString stringWithFormat:@"%ld月%ld日",nowMonth,nowDay]];
    [labelDate setTextColor:[UIColor grayColor]];
    [labelDate setFont:Font_Size(13.)];
    [view addSubview:labelDate];
    
    return view;
  }
  return nil;
}

- (BOOL)tableView:(nonnull UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  return YES;
}

- (void)tableView:(nonnull UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPat{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    CellForHistory *cell = [tableView cellForRowAtIndexPath:indexPat];
    if (tableView == _tableHistory) {
      //删除原始数据源
      [cell deleteHistory];
      //删除UITableViewData数据源
      [self receiveDiffDays:[ADOHistory queryAllHistory]];
      if ([tableView numberOfRowsInSection:indexPat.section]>1) {
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPat] withRowAnimation:UITableViewRowAnimationFade];
      } else {
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPat.section] withRowAnimation:UITableViewRowAnimationFade];
      }
    } else if (tableView == _tableBookmark) {
      ModelMark *model = [_arrayMarkData objectAtIndex:indexPat.row];
      [cell deleteBookMarkWithModel:model];
      [_arrayMarkData removeObjectAtIndex:indexPat.row];
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPat] withRowAnimation:UITableViewRowAnimationFade];
    }
    [self setViewMarkbook];
  }
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  CellForHistory *cellHis = [tableView cellForRowAtIndexPath:indexPath];
  NSString *linkString = cellHis.labelLinkLink.text;
  [[NSNotificationCenter defaultCenter] postNotificationName:kViewControllerNotionHismark object:linkString];
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
