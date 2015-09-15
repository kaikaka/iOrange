//
//  ViewController.m
//  iOrange
//
//  Created by XiangKai Yin on 5/18/15.
//  Copyright (c) 2015 yinxiangkai. All rights reserved.
//

#define DIC_EXPANDED @"expanded" //是否是展开 0收缩 1展开
#define kSectionHeight 50

#import "ApiConfig.h"
#import "ADOHistory.h"
#import "ADOSite.h"
#import "ControllerScanCode.h"
#import "ControllerSetting.h"
#import "ControllerAddNavigation.h"
#import "Common.h"
#import "CellForAccess.h"
#import "FilePathUtil.h"
#import "ModelHistory.h"
#import "NSStringEx.h"
#import "SVPullToRefresh.h"
#import "SettingConfig.h"
#import "TextFieldInputView.h"
#import "UIWebPage.h"
#import "UIControllerBrowser.h"
#import "UIScrollViewTaskManage.h"
#import "UIImageEx.h"
#import "ViewController.h"
#import "ViewWebSiteButton.h"
#import "ViewHomeSection.h"
#import "ViewGuideSiteButton.h"
#import "ViewCellControl.h"
#import "ViewWeather.h"
#import "ViewSetupButton.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate,ScanCodeDelegate,UIControllerBrowserDelegate,UIScrollViewTaskManageDelegate>{
  
  __weak IBOutlet UIButton *_buttonSearch;
  __weak IBOutlet UIButton *_buttonTwoCode;
  
  __weak IBOutlet UIScrollView *_scrollViewContent;
  __weak IBOutlet UIScrollView *_scrollViewHomeOne;
  __weak IBOutlet UIScrollView *_scrollViewHomeTwo;
  __weak IBOutlet ViewWeather *_viewHomeThree;
  __weak IBOutlet UIView *_viewSearch;
  __weak IBOutlet UIView *_viewTouch;
  __weak IBOutlet UIView *_viewMain;
  
  __weak IBOutlet UIView *viewHomeThreeCenter;
  __weak IBOutlet UIImageView *_imgvBackground;
  
  __weak IBOutlet UIButton *_buttonBack;
  __weak IBOutlet UIButton *_buttonGoforw;
  
  
  UITableView *_tableViewExpend;
  UIPageControl *_pageViewMark;
  UIView *_viewSiteShow;
  UIControllerBrowser *_controllerBrowser;
  ControllerSetting *_controllerSetting;
  UIScrollViewTaskManage *_viewScrollTaskTab;
  UIImageView *_imgvAtPrivacy;
  
  NSMutableArray *_DataArray;//记录所有section是否伸展
  NSArray *_arrayCateImageName;// 图片名称
  NSArray *_arrayCateName;//section名称
  NSArray *_arrayCateDetail;//详细说明
  NSInteger _lastSection;//记录上一个点击的section
  NSInteger _webSiteHeight;//记录手机酷站等高度
  NSArray *_arrayContentSite;//PhoneCoolSite 的plist文件
  NSArray *_arrayOftenHistory;//最常访问记录数组
  NSArray *_arraySum;
  
  /// 全屏显示
  BOOL    _isFullScreen;
  CGFloat _lastOffsetY;
  
  NSLayoutConstraint *_constraintViewTopT;
  NSLayoutConstraint *_constraintViewBottomB;
  
}

@property (weak, nonatomic) IBOutlet UITextField *textFiledContent;
@property (nonatomic,strong)void (^whenTouchEnd) (NSString *);
@property (nonatomic,strong)void (^whenShowWeatherEnd) (void);
@property (nonatomic,strong)void (^whenTouchSiteDelete) (NSString *);

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotificationToHismark:) name:kViewControllerNotionHismark object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotificationToSite:) name:kViewControllerNotionSite object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotificationToPrivacy:) name:kViewControllerNotionPrivacy object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotificationToUpadtePaly:) name:kViewControllerNotionUpadtePaly object:nil];
  
  [self countMargin];
  [self showGuideSiteInView];
  [self showPageView];
  [self initDataSource];
  [self getCoolSitePath];
}

#pragma mrak -
#pragma mark - public Methods

- (UIWebPage *)receiveToWebView {
  return _controllerBrowser.webPage;
}

- (void)reloadWebView {
  [_controllerBrowser.webPage.webView reload];
}

- (void)reloadWeatherData {
  [_viewHomeThree setUp];//更新
}

#pragma mark - private Methods

-(void)collapseOrExpand:(NSInteger)section withExpanded:(BOOL)isExpand{
  if (section == 4 && isExpand == NO) {
    [self dataForHistory];
  }
  NSMutableDictionary *dic=[_DataArray objectAtIndex:section];
  [dic setValue:[NSNumber numberWithInt:!isExpand]forKey:DIC_EXPANDED];
}

- (UIView *)showWebSitesInView {
  
  NSString *pathString = [[NSBundle mainBundle] pathForResource:@"HomeNavSite" ofType:@"plist"];
  NSArray *arraySite = [NSArray arrayWithContentsOfFile:pathString];
  
  int totalloc =3;//列的总数
  CGFloat appvieww = (CGRectGetWidth(self.view.frame)-30)/3;//列的宽度
  CGFloat appviewh = iPhone5?(0.85*50):50;//列的高度
  CGFloat margin = (self.view.frame.size.width-totalloc*appvieww)/(totalloc+1);//间距
  CGFloat siteHeight = (appviewh + margin )* totalloc + totalloc * 3;
  
  UIView *viewShow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _scrollViewHomeOne.width, siteHeight)];
  [viewShow setBackgroundColor:[UIColor clearColor]];
  [_scrollViewHomeOne addSubview:viewShow];
  _viewSiteShow = viewShow;
  
  for (int i = 0 ; i < [arraySite count]; i++) {
    int row=i/totalloc;//行号
    int loc=i%totalloc;//列号
    
    CGFloat appviewx=(margin+appvieww)*loc;
    CGFloat appviewy= (margin+appviewh)*row;
    
    ViewWebSiteButton *viewSiteButton = [[ViewWebSiteButton alloc] initWithFrame:
                                         CGRectMake(appviewx, appviewy, appvieww, appviewh)
                                          WithImgDict:arraySite[i]];
    viewSiteButton.touched = whenTouchEnd;
    [viewShow addSubview:viewSiteButton];
  }

  return viewShow;
}

- (void)countMargin {
  int totalloc =3;
  CGFloat appvieww = (CGRectGetWidth(self.view.frame)-30)/3;
  CGFloat appviewh = iPhone5?(0.85*50):50;
  CGFloat margin = (self.view.frame.size.width-totalloc*appvieww)/(totalloc+1);
  CGFloat siteHeight = (appviewh + margin )* totalloc + totalloc * 3  - margin;
  [self showCategoryTableWithMargin:margin withHeight:siteHeight];
}

- (void)showGuideSiteInView {
  NSString *pathString = [[NSBundle mainBundle] pathForResource:@"HomeGuideSite" ofType:@"plist"];
  NSArray *arraySite = [NSArray arrayWithContentsOfFile:pathString];
  NSArray *arrayCustomSite = [NSArray arrayWithArray:[ADOSite queryAllSite]];
  arraySite = [arraySite arrayByAddingObjectsFromArray:arrayCustomSite];
  _arraySum = [NSArray arrayWithArray:arraySite];
  CGFloat widthS = (self.view.width-22*5)/4;
  CGFloat heightS = iPhone5?(0.85 * 90):90;
  CGFloat margin = 22;
  int totalloc = 4;
  
  for (int i = 0; i<[arraySite count]; i++) {
    NSDictionary *dictSite = [arraySite objectAtIndex:i];
    int row = i / totalloc;
    int loc = i % totalloc;
    
    CGFloat appviewx = margin + (margin + widthS) * loc;
    CGFloat appviewy = margin + (margin + heightS) * row;
    
    ViewGuideSiteButton *siteView = [[ViewGuideSiteButton alloc] initWithFrame:CGRectMake(appviewx, appviewy, widthS, heightS) withDict:dictSite];
    [siteView setTag:10+i];
    siteView.touched = whenTouchEnd;
    siteView.touchedDelete = whenTouchSiteDelete;
    [_scrollViewHomeTwo addSubview:siteView];
    if (i == [arraySite count]-1) {
      int row = (i+1) / totalloc;
      int loc = (i+1) % totalloc;
      
      CGFloat appviewW = margin + (margin + widthS) * loc;
      CGFloat appviewH = margin + (margin + heightS) * row;
      ViewGuideSiteButton *siteViewNine = [[ViewGuideSiteButton alloc] initWithFrame:CGRectMake(appviewW, appviewH, widthS, heightS) withIconName:@"home_site_icon9" withSiteName:@""];
      siteViewNine.touched = whenTouchEnd;
      siteViewNine.touchedDelete = whenTouchSiteDelete;
      [_scrollViewHomeTwo addSubview:siteViewNine];
    }
  }
  
}

//广告
- (void)showAdvertInView {
  
}

- (void)showCategoryTableWithMargin:(CGFloat)margin withHeight:(CGFloat)siteHeight {
  UITableView *tableCategory = [[UITableView alloc] initWithFrame:CGRectMake(margin, margin, self.view.width-margin * 2, siteHeight + kSectionHeight * 5 ) style:UITableViewStylePlain];
  tableCategory.backgroundColor = [UIColor clearColor];
  [_scrollViewHomeOne addSubview:tableCategory];
  [tableCategory setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  [tableCategory setShowsVerticalScrollIndicator:NO];
//  tableCategory.tableFooterView = [[UIView alloc] init];
  //使向右偏移的线填满
//  [tableCategory setSeparatorInset:UIEdgeInsetsZero];
  tableCategory.delegate = self;
  tableCategory.dataSource = self;
  tableCategory.scrollEnabled = YES;
  _tableViewExpend = tableCategory;
  
}

- (void)showPageView {
  UIPageControl *pageView = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-65, _scrollViewHomeOne.width, 8)];
  pageView.currentPageIndicatorTintColor = RGBA(125., 125., 125., 1.);
  pageView.pageIndicatorTintColor = [UIColor blackColor];
  pageView.numberOfPages = 3;
  pageView.currentPage = 0;
  [_viewMain insertSubview:pageView belowSubview:_viewTouch];
  _pageViewMark = pageView;
}

- (void)showSettingView:(void(^)(bool complite))completie {
  UIView *viewSetting = _controllerSetting.view;
  [_controllerSetting showSettingView:^{
    [self.view insertSubview:viewSetting aboveSubview:_viewTouch];
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, 0.35 * NSEC_PER_SEC);
    dispatch_after(when, dispatch_get_main_queue(), ^{
      [self enableWithWebView];
    });
  }];
}

static id _aSelf;
- (void)initDataSource {
  _aSelf = self;
  _scrollViewContent.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame)*3, 0);
  _scrollViewContent.pagingEnabled = YES;
  _scrollViewContent.delegate = self;
  _scrollViewContent.showsHorizontalScrollIndicator = NO;
  _scrollViewContent.layer.masksToBounds = YES;//越界裁剪
  //适配
  _scrollViewHomeOne.contentSize = CGSizeMake(_scrollViewContent.width,
                                                _scrollViewContent.height + 30);
  
  _textFiledContent.delegate = self;
  _buttonBack.enabled = NO;
  _buttonGoforw.enabled = NO;
  
  _controllerBrowser = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UIControllerBrowser"];
  _controllerBrowser.delegate = self;
  
  _controllerSetting = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ControllerSetting"];
  _controllerSetting.delegateMian = self;
  //显示无痕浏览模式
  [self onNotificationToPrivacy:nil];
  //天气注释
  [_viewHomeThree setUp];
  //快捷键盘
  [TextFieldInputView attachToInputView:_textFiledContent];
  //创建一个数组
  _DataArray=[[NSMutableArray alloc] init];
  for (int i = 0; i<5; i++) {
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:0],DIC_EXPANDED,nil];
    [_DataArray addObject:dic];
  }
  //可以用plist 便于维护
  _arrayCateImageName = @[@"home_image_cool",@"home_image_sevice",@"home_image_movie",@"home_image_baike",@"home_image_now"];
  _arrayCateName = @[@"手机酷站",@"生活服务",@"影视音乐",@"趣味百科",@"最常访问"];
  _arrayCateDetail = @[@"",@"查询.资讯.服务",@"视频.综艺.音乐台",@"笑话.漫画.百科",@""];
  
  int totalloc =3;
  CGFloat appvieww = (CGRectGetWidth(self.view.frame)-30)/3;
  CGFloat appviewh = iPhone5?(0.85*50):50;
  CGFloat margin = (self.view.frame.size.width-totalloc*appvieww)/(totalloc+1);
  CGFloat siteHeight = (appviewh + margin )* totalloc + totalloc * 3 - margin;
  _webSiteHeight = siteHeight;
  
//  [_viewMain bringSubviewToFront:_viewSearch];
  [_viewHomeThree setContentSize:CGSizeMake(0, _viewHomeThree.height+1)];
  [_viewHomeThree setShowsVerticalScrollIndicator:NO];
  [_viewHomeThree setDelegate:self];
  /* 取消下拉刷新
  [_viewHomeThree addPullToRefreshWithActionHandler:^{
    [_viewHomeThree setUp];
  }];
  [_viewHomeThree.pullToRefreshView setHidden:YES];
  [_viewHomeThree.pullToRefreshView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
  [_viewHomeThree.pullToRefreshView setTextColor:[UIColor whiteColor]];
  [_viewHomeThree.pullToRefreshView setArrowColor:[UIColor whiteColor]];
  [_viewHomeThree setWeatherInfoEnd:whenShowWeatherEnd];
   */
}

- (void)setLayerRadius:(UIView *)viewRadius rectCorner:(UIRectCorner)corner{
  UIBezierPath *maskPath=  [UIBezierPath bezierPathWithRoundedRect:viewRadius.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(5, 5)];
  CAShapeLayer *maskLayer=[[CAShapeLayer alloc] init];
  maskLayer.frame=viewRadius.bounds;
  maskLayer.path=maskPath.CGPath;
  viewRadius.layer.mask=maskLayer;
  viewRadius.layer.masksToBounds=YES;
}

- (int)isExpanded:(NSInteger)section{
  NSDictionary *dic=[_DataArray objectAtIndex:section];
  int expanded=[[dic objectForKey:DIC_EXPANDED] intValue];
  return expanded;
}

- (void)getCoolSitePath {
  NSString *lastPath = [[NSBundle mainBundle] pathForResource:@"PhoneCoolSite" ofType:@"plist"];
  NSArray *array = [NSArray arrayWithContentsOfFile:lastPath];
  _arrayContentSite = array;
}

- (NSArray  *)arrayCutWithRow:(NSInteger)row withSection:(NSInteger)section {
  NSMutableArray *array = [NSMutableArray array];
  NSArray *sectionArray = [_arrayContentSite objectAtIndex:section-1];
  NSInteger m = 4 * row;

  for (NSInteger i = m; i<sectionArray.count; i++) {
    [array addObject:[sectionArray objectAtIndex:i]];
    if (array.count>=4) {
      return array;
    }
  }
  return array;
}

/// 全屏显示
- (void)toFullScreen:(BOOL)fullScreen {
  //全屏模式
  if (![SettingConfig defaultSettingConfig].fullScreen) {
    return;
  }
  if (_isFullScreen == fullScreen) {
    return;
  }
  _isFullScreen = fullScreen;
  [[UIApplication sharedApplication] setStatusBarHidden:fullScreen withAnimation:UIStatusBarAnimationSlide];
  static CGFloat attrTop = 0;
  if (!_constraintViewTopT) {
    for (NSLayoutConstraint *constraint in _viewMain.constraints) {
      if ((constraint.firstItem == _viewSearch)
          && (constraint.firstAttribute == NSLayoutAttributeTop)) {
        attrTop = constraint.constant;
        _constraintViewTopT = constraint;
        break;
      }
    }
    for (NSLayoutConstraint *constraint in _viewMain.constraints) {
      if ((constraint.secondItem == _viewTouch)
          && (constraint.secondAttribute == NSLayoutAttributeBottom)) {
        _constraintViewBottomB = constraint;
        break;
      }
    }
  }
  _constraintViewTopT.constant = attrTop-(_isFullScreen?_viewSearch.bounds.size.height:0);
//  _constraintViewBottomB.constant = _isFullScreen?-_viewTouch.bounds.size.height:0;
  [UIView animateWithDuration:kDuration250ms animations:^{
    [self.view layoutIfNeeded];
  }];
}

- (void)goToHome {
//  [_controllerBrowser.view removeFromSuperview];
  if (_controllerBrowser.webPage.webView) {
    _controllerBrowser.webPage.show = NO;
  }
  [self toFullScreen:NO];
  [self overBackgroundToHidden:NO];
  [self browserToHomeCompletion:^{
    
  }];
}

/// 更新界面显示
- (void)updateDisplay {
  _buttonGoforw.enabled = _controllerBrowser.webPage.webView.canGoForward;
  if (_controllerBrowser.view) {
    _buttonBack.enabled = YES;
  } else
    _buttonBack.enabled = NO;

}

- (void)overBackgroundToHidden:(BOOL)isHidden {
  [self.textFiledContent setText:@""];
  _buttonBack.enabled = NO;
  _buttonGoforw.enabled = NO;
  [[UIApplication sharedApplication] setStatusBarHidden:NO];
  _viewSearch.hidden = _scrollViewContent.hidden = isHidden;
}

- (void)browserToHomeCompletion:(void(^)())completion {
  // 将首页其他视图的容器添加回来
  
  UIView *viewBrowser = _controllerBrowser.view;
  viewBrowser.layer.anchorPoint = CGPointMake(0.5, 1);
  viewBrowser.layer.position = CGPointMake(viewBrowser.width/2, viewBrowser.bottom);
  [UIView animateWithDuration:0.35 animations:^{
    viewBrowser.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.001, 0.001), CGAffineTransformMakeTranslation(0, _viewTouch.height));
    _viewTouch.transform = CGAffineTransformMakeTranslation(0, _viewTouch.height);
    _viewMain.alpha = 1;
    _viewMain.transform = CGAffineTransformIdentity;
  } completion:^(BOOL finished) {
    [viewBrowser removeFromSuperview];
    viewBrowser.transform = CGAffineTransformIdentity;
    viewBrowser.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [UIView animateWithDuration:0.35 animations:^{
      _viewTouch.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
    if (completion) completion();
  }];
}

- (void)completionToMoreThumb:(void (^)())completion {
    CGRect rect = [self browserFrame];
    
    if (!_viewScrollTaskTab) {
        _viewScrollTaskTab = [[UIScrollViewTaskManage alloc] initWithFrame:rect];
        _viewScrollTaskTab.delegate = self;
    }
    _viewScrollTaskTab.frame = rect;
    [_viewScrollTaskTab setArrayOfView:_controllerBrowser.webPageManage.arrWebPage];
    [_viewScrollTaskTab showInView:self.view completion:^{
        
    }];
    
    [_controllerBrowser startAllCoverLogoAnimation];
    
    self.view.userInteractionEnabled = YES;
    
    _viewScrollTaskTab.alpha = 0;
    _viewScrollTaskTab.transform = CGAffineTransformMakeScale(4, 4);
    
    [UIView animateWithDuration:ShowAnimationTime animations:^{
        _viewScrollTaskTab.transform = CGAffineTransformIdentity;
        _viewScrollTaskTab.alpha=1;
        
        _viewMain.alpha = 0;
        _viewMain.transform =
        _imgvBackground.transform = CGAffineTransformMakeScale(kScaleContain, kScaleContain);
        _viewTouch.transform = CGAffineTransformMakeTranslation(0, _viewTouch.height);
        
        [self.view bringSubviewToFront:_viewTouch];
        
    } completion:^(BOOL finished) {
        if (_controllerBrowser.webPageManage.arrWebPage.count>0) {
            [_viewScrollTaskTab setAlphaFullForSubviews];
        }
        if (_controllerBrowser.webPageManage.numberOfWebPage == 0) {
          //
        }
        [UIView animateWithDuration:0.35 animations:^{
            _viewTouch.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        }];
        if (completion) completion();
        else {
            [UIView animateWithDuration:0.3 animations:^{
                _viewMain.alpha = 1;
                _imgvBackground.transform = CGAffineTransformIdentity;
            }];
        }
    }];
  _imgvBackground.alpha = 0.8;
}

/**
 *  从标签缩略图跳转到浏览器; 当前网页放大，标签页渐出，
 *
 *  @param completion 动画结束
 */
- (void)thumbToBrowserWithIndex:(NSInteger)idx completion:(void(^)())completion {
  // 显示=》隐藏
  [_controllerBrowser setCurrWebPageAtIndex:idx];
  UIWebPage *webPage = (UIWebPage *)[_viewScrollTaskTab viewAtIndex:idx];
  if (webPage.snapshot) {
    [webPage reload];
  }
  _controllerBrowser.view.frame = [self browserFrame];
  webPage.frame = _controllerBrowser.view.bounds;
  [_controllerBrowser.view insertSubview:webPage atIndex:0];
  [self.view insertSubview:_controllerBrowser.view belowSubview:_viewTouch];
  [self moveWebPageByIndex:idx];
  _controllerBrowser.view.layer.anchorPoint = CGPointMake(0.5, 0.5);
  _controllerBrowser.view.alpha = 1.;
  [UIView animateWithDuration:0.25 animations:^{
    _viewMain.alpha = 1;
    _viewMain.transform =
    _imgvBackground.transform = CGAffineTransformIdentity;
    _viewTouch.transform = CGAffineTransformMakeTranslation(0, _viewTouch.height);
    [self.view insertSubview:_viewMain aboveSubview:_imgvBackground];
  } completion:^(BOOL finished) {
    [UIView animateWithDuration:0.25 animations:^{
      _viewTouch.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
      _imgvBackground.alpha = 1.0;
    }];
  }];
  if (completion) {
    completion();
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.view.userInteractionEnabled = YES;
    CGFloat duration = 0.0;
    _pageViewMark.alpha = 0.0;
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
      
    });
  }
}

- (void)moveWebPageByIndex:(NSInteger)idx {
  /**
   *  顺序不能错（***）
   */
  _controllerBrowser.webPageManage.currWebPageIndex = idx;
  [_controllerBrowser setCurrWebPageAtIndex:idx];
  [_controllerBrowser.webPageManage moveCurrPageToLast];
}

- (CGRect)browserFrame {
  CGRect rc = self.view.bounds;
  rc.origin.y = 0;
  rc.size.height = self.view.height-rc.origin.y-50;
  return rc;
}

- (void)dataForHistory {
  _arrayOftenHistory = [NSArray arrayWithArray:[ADOHistory queryHistoryFour]];
}

- (void)loadAddNavigationController {
  ControllerAddNavigation *controller = [ControllerAddNavigation loadFromStoryboard];
  [self.navigationController pushViewController:controller animated:YES];
}

- (void)deleteAllSite {
  for (UIView *view in _scrollViewHomeTwo.subviews) {
    [view removeFromSuperview];
  }
}

- (void)siteAloneForDelete:(NSString *)link {
  UIView *viewSiteDelete = [[UIView alloc] initWithFrame:self.view.bounds];
  viewSiteDelete.backgroundColor = [UIColor clearColor];
  
  CGFloat widthS = 20;
  CGFloat heightS = 20;
  CGFloat marginW = (self.view.width-19*5)/4;
  CGFloat marginH = (self.view.width-((self.view.width-23*5)/4)*4)/5;
  int totalloc = 4;
  
  for (int i = 9; i<[_arraySum count]; i++) {
    int row = i / totalloc;
    int loc = i % totalloc;
    
    CGFloat appviewx = marginW + (marginW + 19) * loc;
    CGFloat appviewy = 64 + 25 + (marginH + 90) * row;

    UIButton *btnDelete = [UIButton buttonWithType:0];
    [btnDelete setFrame: CGRectMake(appviewx, appviewy, widthS, heightS)];
    [btnDelete setImage:[UIImage imageNamed:@"home_site_delete@2x"] forState:0];
    [btnDelete addTarget:self action:@selector(onTouchAtSiteToDelete:) forControlEvents:UIControlEventTouchUpInside];
    [btnDelete setTag:10+i];
    [viewSiteDelete addSubview:btnDelete];
  }
  
  UIButton *btnDone = [UIButton buttonWithType:0];
  [btnDone setFrame:CGRectMake(0, self.view.height - 49, self.view.width, 49)];
  [btnDone setBackgroundColor:[UIColor whiteColor]];
  [btnDone setTitle:@"完成" forState:0];
  [btnDone setTitleColor:[UIColor blackColor] forState:0];
  [btnDone setTitleColor:[UIColor grayColor] forState:1];
  [btnDone addTarget:self action:@selector(onTouchAtSiteToDone:) forControlEvents:UIControlEventTouchUpInside];
  [viewSiteDelete addSubview:btnDone];
  
  [self.view addSubview:viewSiteDelete];
}

- (void)enableWithWebView {
  ViewSetupButton *view10 = (ViewSetupButton *)[_controllerSetting.scrollViewSetting viewWithTag:100];
  ViewSetupButton *view104 = (ViewSetupButton *)[_controllerSetting.scrollViewSetting viewWithTag:104];
  ViewSetupButton *view105 = (ViewSetupButton *)[_controllerSetting.scrollViewSetting viewWithTag:105];
  //控制设置按钮
  if (_controllerBrowser.webPage.webView) {
    if (_controllerBrowser.webPage.show) {
      [view10 setImageEnable:YES];
      [view104 setImageEnable:YES];
    } else {
      [view10 setImageEnable:NO];
      [view104 setImageEnable:NO];
    }
  } else {
    [view10 setImageEnable:NO];
    [view104 setImageEnable:NO];
  }
  if (_pageViewMark.currentPage == 2 ) {
    [view105 setImageEnable:YES];
  } else {
    [view105 setImageEnable:NO];
  }
}

#pragma mark -
#pragma mark - Webview Methods

- (void)loadWebViewWithLink:(NSString *)link {
  //实例化浏览器控制器
  _controllerBrowser.view.frame = self.browserFrame;
  [_controllerBrowser loadLink:link];
  [_viewMain insertSubview:_controllerBrowser.view belowSubview:_viewTouch];
  [[UIApplication sharedApplication] setStatusBarHidden:YES];
  [self overBackgroundToHidden:YES];
  if (_controllerBrowser.webPage.webView) {
    _controllerBrowser.webPage.show = YES;
  }
}

#pragma mark -  Block Methods

void (^whenTouchEnd)(NSString *) = ^ void (NSString *link) {
  if (link.length > 0) {
    [[_aSelf textFiledContent] setText:link];
    [_aSelf loadWebViewWithLink:link];
  } else {
    [_aSelf loadAddNavigationController];
  }
};

void (^whenTouchSiteDelete)(NSString *) = ^ void(NSString *link) {
  [_aSelf siteAloneForDelete:link];
};

#pragma mark - 
#pragma mark - ScanCodeDelegate

- (void)scanEndResultWithString:(NSString *)link {
  NSString *url = link;
  if ([url hasPrefix:@"http://itunes.apple.com/"]
      || [url hasPrefix:@"https://itunes.apple.com/"]
      || [url hasPrefix:@"itms-apps://itunes.apple.com/"]) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
  }
  url = [url getLinkWithText];
  [self loadWebViewWithLink:url];
  [self.textFiledContent setText:url];
  [self.view endEditing:YES];
}

#pragma mark - Systems Methods

- (void)viewDidLayoutSubviews{
  [_scrollViewContent.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *layConstant, NSUInteger idx, BOOL *stop) {
    
    if (layConstant.firstItem == _scrollViewHomeOne) {
      if (layConstant.firstAttribute == NSLayoutAttributeWidth) {
        layConstant.constant = _scrollViewContent.width;
      }
      if (layConstant.firstAttribute == NSLayoutAttributeHeight) {
        layConstant.constant = _scrollViewContent.height;
      }
    }
    if (layConstant.firstItem == _scrollViewHomeTwo) {
      if (layConstant.firstAttribute == NSLayoutAttributeWidth) {
        layConstant.constant = _scrollViewContent.width;
      }
      if (layConstant.firstAttribute == NSLayoutAttributeLeft) {
        layConstant.constant = _scrollViewContent.width;
      }
      if (layConstant.firstAttribute == NSLayoutAttributeHeight) {
        layConstant.constant = _scrollViewContent.height;
      }
    }
    if (layConstant.firstItem == _viewHomeThree) {
      if (layConstant.firstAttribute == NSLayoutAttributeWidth) {
        layConstant.constant = _scrollViewContent.width;
      }
      if (layConstant.firstAttribute == NSLayoutAttributeLeft) {
        layConstant.constant = _scrollViewContent.width*2;
      }
    }
  }];
  
  [_viewHomeThree.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *layConstant, NSUInteger idx, BOOL *stop) {
    if (layConstant.firstItem == viewHomeThreeCenter) {
      if (layConstant.firstAttribute == NSLayoutAttributeLeft) {
        layConstant.constant = (_scrollViewContent.width - viewHomeThreeCenter.width)/2;
      }
    }
  }];
  
  [_scrollViewContent layoutSubviews];
  
}

#pragma mark - Events

- (void)onGestureSectionWithTop:(UITapGestureRecognizer *)recognizer {
  ViewHomeSection *viewSection = (ViewHomeSection *)[recognizer view];
  NSInteger section = viewSection.tag - 10;
  section = section + 1;
  
  if (_lastSection == section) {
    NSMutableDictionary *dic=[_DataArray objectAtIndex:section-1];
    int expanded=[[dic objectForKey:DIC_EXPANDED] intValue];
    [self collapseOrExpand:section-1 withExpanded:expanded];
    [_tableViewExpend reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    _lastSection = section;
    if (expanded == 1) {
      [_tableViewExpend scrollsToTop];
    } else {
      dispatch_time_t when =  dispatch_time(DISPATCH_TIME_NOW, kDuration150ms * NSEC_PER_SEC);
      dispatch_after(when, dispatch_get_main_queue(), ^{
        CGPoint bottomOffset = CGPointMake(0, 44 * 4);
        [_tableViewExpend setContentOffset:bottomOffset animated:YES];
      });
    }
    return;
  }
  for (int i = 1; i<6; i++) {
    if (i != section) {
      [self collapseOrExpand:i-1 withExpanded:YES];
    } else {
      [self collapseOrExpand:i-1 withExpanded:NO];
      _lastSection = section;
    }
    [_tableViewExpend reloadSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationNone];
  }
  dispatch_time_t when =  dispatch_time(DISPATCH_TIME_NOW, kDuration150ms * NSEC_PER_SEC);
  dispatch_after(when, dispatch_get_main_queue(), ^{
    CGPoint bottomOffset = CGPointMake(0, 44 * 4);
    [_tableViewExpend setContentOffset:bottomOffset animated:YES];
  });
}

- (IBAction)onTouchWithShow:(UIButton *)sender {
  switch (sender.tag) {
    case MainHomeButtonTypeHome:
      [self goToHome];
      _buttonBack.enabled = NO;
      _buttonGoforw.enabled = NO;
      break;
    case MainHomeButtonTypeBack:
      if (_controllerBrowser.webPage.webView.canGoBack) {
        [_controllerBrowser.webPage.webView goBack];
        [self updateDisplay];
      } else {
        [self goToHome];
        _buttonBack.enabled = NO;
      }
      break;
    case MainHomeButtonTypeForward:
      if (_controllerBrowser.webPage.webView) {
        [_controllerBrowser.webPage.webView goForward];
        [self updateDisplay];
      }
      break;
    case MainHomeButtonTypeMore:
      [self completionToMoreThumb:^{
        
      }];
      break;
    case MainHomeButtonTypeSetting:
      [self showSettingView:^(bool complite) {
        
      }];
          break;
    default:
      break;
  }
}

- (IBAction)onTouchWithScan:(UIButton *)sender {
  ControllerScanCode *scanView = [[ControllerScanCode alloc] init];
  scanView.delegateScanCode = self;
  [self presentViewController:scanView animated:YES completion:nil];
}

- (IBAction)onTouchWithSearchAction:(UIButton *)sender {
  [_textFiledContent becomeFirstResponder];
  return;
}

- (void)onNotificationToHismark:(NSNotification *)notification {
  NSString *urlString = [notification object];
  [self loadWebViewWithLink:urlString];
}

- (void)onNotificationToSite:(NSNotification *)notification {
  [self deleteAllSite];
  [self showGuideSiteInView];
}

- (void)onNotificationToPrivacy:(NSNotification *)notification {
  
  if ([SettingConfig defaultSettingConfig].nTraceBrowser) {
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width - 90, 0, 50, 50)];
    [imgv setImage:[UIImage imageNamed:@"home_touch_privacy@2x"]];
    [imgv setAlpha:0.35];
    [_viewTouch addSubview:imgv];
    _imgvAtPrivacy = imgv;
  } else {
    if (_imgvAtPrivacy) {
      [_imgvAtPrivacy removeFromSuperview];
    }
  }
}

- (void)onNotificationToUpadtePaly:(NSNotification *)center {
  [self updateDisplay];
}

- (void)onTouchAtSiteToDelete:(UIButton *)sender {
  [sender removeFromSuperview];
  ViewGuideSiteButton *guideView = (ViewGuideSiteButton *)[_scrollViewHomeTwo viewWithTag:sender.tag];
  if ([ADOSite deleteWithSiteId:guideView.modelSite.s_id]) {
    [self deleteAllSite];
    [self showGuideSiteInView];
  }
}

- (void)onTouchAtSiteToDone:(UIButton *)sender {
  [sender.superview removeFromSuperview];
}

#pragma mark - UIControllerBrowserDelegate

- (void)controllerBrowserWillDimiss:(UIControllerBrowser *)controllerBrowser willRemoveWebPage:(UIWebPage *)webPage {
  
}

- (void)controllerBrowser:(UIControllerBrowser *)controllerBrowser scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  [_viewMain endEditing:YES];
  _lastOffsetY = scrollView.contentOffset.y;
}

- (void)controllerBrowser:(UIControllerBrowser *)controllerBrowser scrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat currOffsetY = scrollView.contentOffset.y;
  CGFloat maxOffsetY = MAX(0, scrollView.contentSize.height-scrollView.bounds.size.height);
  if (!_isFullScreen && maxOffsetY<(_viewSearch.bounds.size.height+20)) {
    return;
  }
  
  if (fabs(currOffsetY-_lastOffsetY) > 10) {
    BOOL needFullScreen = NO;
    if (currOffsetY > 10
        && (currOffsetY>_lastOffsetY || currOffsetY>maxOffsetY)) {
      needFullScreen = YES;
    }
    [self toFullScreen:needFullScreen];
    
    _lastOffsetY = currOffsetY;
  }
  
  CGPoint offset = scrollView.contentOffset;
  CGRect bounds = scrollView.bounds;
  CGSize size = scrollView.contentSize;
  UIEdgeInsets inset = scrollView.contentInset;
  CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
  CGFloat maximumOffset = size.height;
  
  //当currentOffset与maximumOffset的值相等时，说明scrollview已经滑到底部了。也可以根据这两个值的差来让他做点其他的什么事情
  if((maximumOffset - currentOffset) <= 0.0) {
    _constraintViewBottomB.constant = -_viewTouch.bounds.size.height;
    [UIView animateWithDuration:kDuration250ms animations:^{
      [self.view layoutIfNeeded];
    }];
  } else {
    _constraintViewBottomB.constant = 0;
    [UIView animateWithDuration:kDuration250ms animations:^{
      [self.view layoutIfNeeded];
    }];
  }
}

#pragma mark - 
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  NSString *link = textField.text;
  if (link.length) {
    if ([link hasPrefix:@"http://itunes.apple.com/"]
        || [link hasPrefix:@"https://itunes.apple.com/"]
        || [link hasPrefix:@"itms-apps://itunes.apple.com/"]) {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
      return YES;
    }
    link =  [link getLinkWithText];
    [self loadWebViewWithLink:link];
    [self updateDisplay];
    [self.view endEditing:YES];
  }
  return YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  if (scrollView == _viewHomeThree) {
    [_viewHomeThree.pullToRefreshView setHidden:NO];
    return;
  }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  if (scrollView.tag == 50) {
    CGFloat f = scrollView.contentOffset.x /scrollView.width;
    _pageViewMark.currentPage = f;
  }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return 0;
  }
  section = section -1;
  NSMutableDictionary *dic=[_DataArray objectAtIndex:section];
  //判断是收缩还是展开
  if ([[dic objectForKey:DIC_EXPANDED]intValue]) {
    return 4;
    
  } else {
    return 0;
  }
  return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return _webSiteHeight;
  }
  return kSectionHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell * cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.backgroundColor = RGBA(182., 182., 182., 0.5);
  if (indexPath.section == 5) {
    CellForAccess * cellAcc = [[CellForAccess alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 44)];
    if (indexPath.row <= (NSInteger)(_arrayOftenHistory.count-1)) {
      ModelHistory *model = [_arrayOftenHistory objectAtIndex:indexPath.row];
      [cellAcc setTitleString:model.hTitle];
    } else {
      [cellAcc setImgvHidden:YES];
    }
    
    if (indexPath.row == 3) {
      [cellAcc setLabelHidden:YES];
    }
    return cellAcc;
  }
  ViewCellControl *viewS = [[ViewCellControl alloc] initWithFrame:CGRectMake(0, 0, tableView.width, cell.height)];
  viewS.touched = whenTouchEnd;
  [cell addSubview:viewS];
  [viewS setArraySite:[self arrayCutWithRow:indexPath.row withSection:indexPath.section]];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   if (indexPath.section == 5) {
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
     ModelHistory *model = [_arrayOftenHistory objectAtIndex:indexPath.row];
     [self loadWebViewWithLink:model.hLink];
   }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return [self showWebSitesInView];
  }
  section = section-1;
  ViewHomeSection *viewSection = [[ViewHomeSection alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), kSectionHeight) withImageName:_arrayCateImageName[section] withLableName:_arrayCateName[section]];
  [viewSection setIsMarkDown:[self isExpanded:section]];
  [viewSection setBackgroundColor:RGBA(230., 230., 230., 1.)];
  [viewSection.labelDetail setText:_arrayCateDetail[section]];
  
  if (section == 0) {
    //圆角上面两个角
    [self setLayerRadius:viewSection rectCorner: UIRectCornerTopLeft|UIRectCornerTopRight];
    [viewSection setIsHiddenLine:NO];
  } else if (section == 4) {
    [self setLayerRadius:viewSection rectCorner: UIRectCornerBottomLeft|UIRectCornerBottomRight];
    [viewSection setIsHiddenLine:YES];
  } else {
    [viewSection setIsHiddenLine:NO];
  }
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(onGestureSectionWithTop:)];
  viewSection.tag = section+10;
  [viewSection addGestureRecognizer:tapGesture];
  return viewSection;
}

#pragma mark- UIScrollViewTaskManageDelegate

- (void)viewTaskManageEmpty:(UIScrollViewTaskManage *)view isAfterOfAnimate:(BOOL)animation {
  self.view.userInteractionEnabled = YES;
  CGFloat duration = animation?0.8:0.;
  dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC));
  dispatch_after(when, dispatch_get_main_queue(), ^{
    [UIView animateWithDuration:0.5 animations:^{
      _viewMain.alpha = 1;
      _viewMain.transform =
      _imgvBackground.transform = CGAffineTransformIdentity;
      _viewTouch.transform = CGAffineTransformMakeTranslation(0, _viewTouch.height);
      [_controllerBrowser.view removeFromSuperview];
      [self.view insertSubview:_viewMain aboveSubview:_imgvBackground];
    } completion:^(BOOL finished) {
      _viewScrollTaskTab = nil;
      [UIView animateWithDuration:0.35 animations:^{
        _viewTouch.transform = CGAffineTransformIdentity;
        [self overBackgroundToHidden:NO];
      } completion:^(BOOL finished) {
        _imgvBackground.alpha = 1.0;
      }];
    }];
  });
 
}

- (void)viewTaskManageDidRemoved:(UIScrollViewTaskManage *)view atIndex:(NSInteger)idx {
  [_controllerBrowser.webPageManage removeAtIndex:idx];
  NSInteger count = _controllerBrowser.webPageManage.numberOfWebPage;
  _controllerBrowser.webPageManage.currWebPageIndex = MIN(idx, count-1);
}

- (void)viewTaskManage:(UIScrollViewTaskManage *)view didSelectShareButton:(TMShareButtonItem )shareTag ofCurrentWebIndex:(NSInteger)currentIdx {
}

- (void)viewTaskManage:(UIScrollViewTaskManage *)view didTaskViewSelected:(NSInteger)selectedIdx {
  [self thumbToBrowserWithIndex:selectedIdx completion:^{
    
  }];
}

@end
