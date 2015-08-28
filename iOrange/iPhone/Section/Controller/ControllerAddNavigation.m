//
//  ControllerAddNavigation.m
//  iOrange
//
//  Created by Yoon on 8/28/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import "ADOHistory.h"
#import "ADOSite.h"
#import "ControllerAddNavigation.h"
#import "CellForHistory.h"

@interface ControllerAddNavigation ()<UITableViewDataSource,UITableViewDelegate>{
  NSArray *_arrayRecently;
}

@end

@implementation ControllerAddNavigation

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
  [_btnBack addTarget:self action:@selector(onTouchToBack:) forControlEvents:UIControlEventTouchUpInside];
  [_btnDone addTarget:self action:@selector(onTouchToDone:) forControlEvents:UIControlEventTouchUpInside];
  [_tableNow setTableFooterView:[[UIView alloc] init]];
  [_tableNow setDelegate:self];
  [_tableNow setDataSource:self];
  [self viewForRound:_viewLink];
  [self viewForRound:_viewTitle];
  [self viewForRound:_btnBack];
  _btnDone.layer.cornerRadius = 3.;
  
  [self revicedNowData];
}

#pragma mark -  private methods

- (void)viewForRound:(UIView *) viewX{
  viewX.layer.cornerRadius = 3.;
  viewX.layer.borderWidth = 1.;
  viewX.layer.borderColor = [UIColor grayColor].CGColor;
}

- (void)revicedNowData {
  _arrayRecently = [NSArray arrayWithArray:[ADOHistory queryHistoryFive]];
}

#pragma mark - events 

- (void)onTouchToBack:(UIButton *)sender {
  [self.navigationController popViewControllerAnimated:YES];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)onTouchToDone:(UIButton *)sender {
  if (_texFieldName.text.length == 0) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入名称" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    return;
  }
  if (_textFileLink.text.length == 0) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入网址" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    return;
  }
  ModelSite *model = [ModelSite modelSite];
  NSString *stringUrl = _textFileLink.text;
  model.s_dateNow = [[NSDate date] timeIntervalSince1970];
  model.s_icon = [NSString stringWithFormat:@"http://%@/favicon.ico", [NSURL URLWithString:stringUrl].host];
  model.s_link = stringUrl;
  model.s_title = [_texFieldName text];
  [ADOSite InsertWithModelList:model];
  [self.navigationController popViewControllerAnimated:YES];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _arrayRecently.count;
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"cellIdentifier";
  CellForHistory * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (!cell) {
    cell = [[CellForHistory alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  CellForHistory *cellHis = (CellForHistory *)cell;
  ModelHistory *model = [_arrayRecently objectAtIndex:indexPath.row];
  cellHis.labelLinkTitle.text = model.hTitle;
  cellHis.labelLinkLink.text = model.hLink;
  [cellHis setIconAtUrl:model.hLink];
  [cellHis setModelHistroy:model];
  [cellHis.btnRight setHidden:YES];
  return cell;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  CellForHistory *cellHisy = [tableView cellForRowAtIndexPath:indexPath];
  _textFileLink.text = cellHisy.labelLinkLink.text;
  _texFieldName.text = cellHisy.labelLinkTitle.text;
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
