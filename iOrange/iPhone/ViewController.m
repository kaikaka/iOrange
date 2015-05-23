//
//  ViewController.m
//  iOrange
//
//  Created by XiangKai Yin on 5/18/15.
//  Copyright (c) 2015 yinxiangkai. All rights reserved.
//

#define DIC_EXPANDED @"expanded" //是否是展开 0收缩 1展开
#define kSectionHeight 50

#import "ViewController.h"
#import "ViewWebSiteButton.h"
#import "ViewHomeSection.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
  
  __weak IBOutlet UIButton *_buttonSearch;
  __weak IBOutlet UIButton *_buttonTwoCode;
  
  __weak IBOutlet UIScrollView *_scrollViewContent;
  
  __weak IBOutlet UIView *_viewHomeOne;
  __weak IBOutlet UIView *_viewHomeTwo;
  __weak IBOutlet UIView *_viewHomeThree;

  UITableView *_tableViewExpend;
  UIPageControl *_pageViewMark;
  
  NSMutableArray *_DataArray;//记录所有section是否伸展
  NSArray *_arrayCateImageName;// 图片名称
  NSArray *_arrayCateName;//section名称
  NSArray *_arrayCateDetail;//详细说明
  NSInteger _lastSection;//记录上一个点击的section
}


@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  [self showWebSitesInView];
  [self showPageView];
  [self initDataSource];
}

#pragma mark - events

- (void)onGestureSectionWithTop:(UITapGestureRecognizer *)recognizer {
  ViewHomeSection *viewSection = (ViewHomeSection *)[recognizer view];
  NSInteger section = viewSection.tag - 10;
  
  if (_lastSection == section) {
    NSMutableDictionary *dic=[_DataArray objectAtIndex:section];
    int expanded=[[dic objectForKey:DIC_EXPANDED] intValue];
    [self collapseOrExpand:section withExpanded:expanded];
    [_tableViewExpend reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    _lastSection = section;
    return;
  }
  for (int i = 0; i<5; i++) {
    if (i != section) {
      [self collapseOrExpand:i withExpanded:YES];
    } else {
      [self collapseOrExpand:i withExpanded:NO];
      _lastSection = section;
    }
    [_tableViewExpend reloadSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationFade];
  }
}

#pragma mark- public Methods

#pragma mark - private Methods

-(void)collapseOrExpand:(NSInteger)section withExpanded:(BOOL)isExpand{

  NSMutableDictionary *dic=[_DataArray objectAtIndex:section];
  [dic setValue:[NSNumber numberWithInt:!isExpand]forKey:DIC_EXPANDED];
}

- (void)showWebSitesInView {
  
  NSArray *arrayImageName = @[@"home_webSite_baidu",@"home_webSite_weibo",@"home_webSite_jianshu",
                              @"home_webSite_jd",@"home_webSite_amazon",@"home_webSite_tmall",
                              @"home_webSite_toutiao",@"home_webSite_ctrip",@"home_webSite_youku"];
  int totalloc =3;
  CGFloat appvieww = (CGRectGetWidth(self.view.frame)-30)/3;
  CGFloat appviewh = iPhone5?(0.85*50):50;
  CGFloat margin = (self.view.frame.size.width-totalloc*appvieww)/(totalloc+1);
  CGFloat siteHeight = (appviewh + margin )* totalloc + totalloc * 3;
  
  for (int i = 0 ; i < [arrayImageName count]; i++) {
    int row=i/totalloc;//行号
    int loc=i%totalloc;//列号
    
    CGFloat appviewx=margin+(margin+appvieww)*loc;
    CGFloat appviewy=margin+(margin+appviewh)*row;
    
    ViewWebSiteButton *viewSiteButton = [[ViewWebSiteButton alloc] initWithFrame:
                                         CGRectMake(appviewx, appviewy, appvieww, appviewh)
                                          WithImgName:arrayImageName[i]];
    [_viewHomeOne addSubview:viewSiteButton];
  }
  [self showCategoryTableWithMargin:margin withHeight:siteHeight];
}

//广告
- (void)showAdvertInView {
  
}

- (void)showCategoryTableWithMargin:(CGFloat)margin withHeight:(CGFloat)siteHeight {
  UITableView *tableCategory = [[UITableView alloc] initWithFrame:CGRectMake(margin, siteHeight, CGRectGetWidth(self.view.frame)-margin * 2, kSectionHeight*5-1) style:UITableViewStylePlain];
  tableCategory.layer.masksToBounds = YES;
  tableCategory.layer.cornerRadius = 5.;
  tableCategory.backgroundColor = RGBA(230., 230., 230., 1.);
  [_viewHomeOne addSubview:tableCategory];
//  tableCategory.tableFooterView = [[UIView alloc] init];
  //使向右偏移的线填满
  [tableCategory setSeparatorInset:UIEdgeInsetsZero];
  tableCategory.delegate = self;
  tableCategory.dataSource = self;
  tableCategory.scrollEnabled = NO;
  _tableViewExpend = tableCategory;
  
}

- (void)showPageView {
  UIPageControl *pageView = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-70, CGRectGetWidth(self.view.frame), 10)];
  pageView.currentPageIndicatorTintColor = RGBA(125., 125., 125., 1.);
  pageView.pageIndicatorTintColor = [UIColor blackColor];
  pageView.numberOfPages = 3;
  pageView.currentPage = 0;
  [self.view addSubview:pageView];
  _pageViewMark = pageView;
}

- (void)initDataSource {
  _scrollViewContent.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame)*3, 0);
  _scrollViewContent.pagingEnabled = YES;
  _scrollViewContent.delegate = self;
  //创建一个数组
  _DataArray=[[NSMutableArray alloc] init];
  for (int i = 0; i<5; i++) {
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:0],DIC_EXPANDED,nil];
    [_DataArray addObject:dic];
  }
  //可以用plist 便于维护
  _arrayCateImageName = @[@"home_image_cool",@"home_image_sevice",@"home_image_movie",@"home_image_baike",@"home_image_now"];
  _arrayCateName = @[@"手机酷站",@"生活服务",@"影视音乐",@"趣味百科",@"最近访问"];
  _arrayCateDetail = @[@"",@"查询.资讯.服务",@"视频.综艺.音乐台",@"笑话.漫画.百科",@""];
}

-(int)isExpanded:(NSInteger)section{
  NSDictionary *dic=[_DataArray objectAtIndex:section];
  int expanded=[[dic objectForKey:DIC_EXPANDED] intValue];
  return expanded;
}

#pragma mark - UIScrollViewDelegate 

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  CGFloat f = scrollView.contentOffset.x /scrollView.width;
  _pageViewMark.currentPage = f;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSMutableDictionary *dic=[_DataArray objectAtIndex:section];
  //判断是收缩还是展开
  if ([[dic objectForKey:DIC_EXPANDED]intValue]) {
    return 3;
    
  } else {
    return 0;
  }
  return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return kSectionHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"cellIdentifier";
  UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.backgroundColor = CLEARCOLOR;
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  ViewHomeSection *viewSection = [[ViewHomeSection alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), kSectionHeight) withImageName:_arrayCateImageName[section] withLableName:_arrayCateName[section]];
  [viewSection setIsMarkDown:[self isExpanded:section]];
  [viewSection.labelDetail setText:_arrayCateDetail[section]];
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onGestureSectionWithTop:)];
  viewSection.tag = section+10;
  [viewSection addGestureRecognizer:tapGesture];
  return viewSection;
}

@end
