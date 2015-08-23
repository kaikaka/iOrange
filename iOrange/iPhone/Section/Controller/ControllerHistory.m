//
//  ControllerHistory.m
//  iOrange
//
//  Created by Yoon on 8/16/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import "ADOHistory.h"
#import "ADOMark.h"
#import "ControllerHistory.h"
#import "CalendarDateUtil.h"
#import "CellForHistory.h"
#import "ModelHistory.h"
#import "ModelMark.h"

@interface ControllerHistory ()<UITableViewDelegate,UITableViewDataSource> {
  NSInteger _intTimeDays;//所有不同的天数
  NSArray *_arrayHistoryData;//所有历史数据
  NSArray *_arrayRowData;//每个区里的所有row数据(字符串)
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
  _arrayHistoryData = arrayHistory;
  
  [self receiveDiffDays:arrayHistory];
  
  [self setupDataTable];
}

- (void)receiveDiffDays:(NSArray *)arrayHistory {
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

#pragma mark - events

- (void)onTouchToBack:(UIButton *)sender {
  [self.navigationController popViewControllerAnimated:YES];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)onTouchWithEditAndClear:(UIButton *)sender {
}

- (void)onTouchWithSegemnt:(UISegmentedControl *)sender {
  [_viewHome exchangeSubviewAtIndex:1 withSubviewAtIndex:2];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView {
  if (tableView == _tableHistory) {
    return _intTimeDays;
  }
  return 0;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (tableView == _tableHistory) {
    NSString *modelString = [_arrayRowData objectAtIndex:section];
    NSArray *arr = [self receiveCurrentDayHistory:modelString];
    return arr.count;
  }
  return 0;
}

- (CGFloat)tableView:(nonnull UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 30.;
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"cellIdentifier";
  UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (!cell) {
    if (tableView == _tableHistory) {
    cell = [[CellForHistory alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    } else {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
  }
  if (tableView == _tableHistory) {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CellForHistory *cellHis = (CellForHistory *)cell;
    NSString *modelString = [_arrayRowData objectAtIndex:indexPath.section];
    NSArray *arrModel = [self receiveCurrentDayHistory:modelString];
    ModelHistory *model = [arrModel objectAtIndex:indexPath.row];
    cellHis.labelLinkTitle.text = model.hTitle;
    cellHis.labelLinkLink.text = model.hLink;
    [cellHis setIconAtUrl:model.hLink];
  }
  
  return cell;
}

- (UIView *)tableView:(nonnull UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
