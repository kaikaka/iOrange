//
//  UIControllerBrowser.m
//  Browser-Touch
//
//  Created by David on 14-7-31.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//
#define viewW 150.

#import "ApiConfig.h"
#import "ADOHistory.h"
#import "SettingConfig.h"
#import "UIControllerBrowser.h"
#import "UIWebViewAdditions.h"

#define kMaxWebPageNumber 10

@interface UIControllerBrowser () <WebPageManageDelegate, UIGestureRecognizerDelegate> {
  UIWebPage *_webPage;
  
  UIButton *_btnPage;
  UIView   *_viwePage;
}

@property (nonatomic, assign, readonly) CGRect webPageFrame;

@end

@implementation UIControllerBrowser

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    _webPageManage = [[WebPageManage alloc] init];
    _webPageManage.delegate = self;
  }
  return self;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _webPageManage = [[WebPageManage alloc] init];
    _webPageManage.delegate = self;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.view.backgroundColor = [UIColor clearColor];
  
  //浏览器加载颜色
  [UIWebPage appearance].progressColor = RGBA(0., 0., 180., 0.7);//RGBCOLOR(0, 200, 0);
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotificationAtFont:) name:kBrowserControllerFont object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNOtificationAtPageButton:) name:kBrowserControllerAtPageButton object:nil];
}

#pragma mark - private methods

- (void)loadPageButtonWithEnable:(BOOL)isEnable {
  if (isEnable) {
    if (_btnPage) {
      //刷新时并不创建
      return;
    }
    CGFloat viewH = 40.;
    
    UIButton *btnPage = [UIButton buttonWithType:0];
    [btnPage setFrame:CGRectMake(self.view.width - 40 , self.view.height - viewH, 35, viewH-5)];
    [btnPage setImage:[UIImage imageNamed:@"home_setting_browser_page"] forState:0];
    [btnPage setImage:[UIImage imageNamed:@"home_setting_next"] forState:UIControlStateSelected];
    [btnPage addTarget:self action:@selector(onTouchWithTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:btnPage aboveSubview:_webPage];
    _btnPage = btnPage;
    
    UIView *viewBackground = [[UIView alloc] initWithFrame:CGRectMake(self.view.width,
                                                                      btnPage.top, viewW, viewH)];
    [viewBackground setBackgroundColor:[UIColor clearColor]];
    [self.view insertSubview:viewBackground aboveSubview:btnPage];
    viewBackground.alpha = 0.;
    _viwePage = viewBackground;
    
    UIView *viewWhite = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewW-2, viewH-5)];
    viewWhite.backgroundColor = [UIColor colorWithWhite:1. alpha:0.9];
    [viewBackground addSubview:viewWhite];
    
    UIImageView *imgvBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH-5)];
    [imgvBackground setImage:[UIImage imageNamed:@"home_setting_browserBtn_background"]];
    [viewBackground addSubview:imgvBackground];
    
    UIImageView *imgvLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 30, 30)];
    [imgvLeft setImage:[UIImage imageNamed:@"home_setting_browser_page"]];
    [imgvBackground addSubview:imgvLeft];
    
    UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(imgvLeft.right+5, 5, 1, imgvBackground.height-10)];
    [labelLine setBackgroundColor:RGBA(180., 180., 180., 0.9)];
    [imgvBackground addSubview:labelLine];
    
    CGFloat width = 30.;
    CGFloat space = 6.;
    CGFloat spaceHeight = 2.;
    
    UIButton *btnToTop = [UIButton buttonWithType:0];
    [btnToTop setFrame:CGRectMake(labelLine.right+space, spaceHeight, width, width)];
    [btnToTop setImage:[UIImage imageNamed:@"home_setting_browser_top"] forState:0];
    [viewBackground addSubview:btnToTop];
    
    UIButton *btnToButtom = [UIButton buttonWithType:0];
    [btnToButtom setFrame:CGRectMake(btnToTop.right+space, spaceHeight, width, width)];
    [btnToButtom setImage:[UIImage imageNamed:@"home_setting_browser_bottom"] forState:0];
    [viewBackground addSubview:btnToButtom];
    
    UIButton *btnShare = [UIButton buttonWithType:0];
    [btnShare setFrame:CGRectMake(btnToButtom.right+space, spaceHeight, width, width)];
    [btnShare setImage:[UIImage imageNamed:@"home_setting_browser_share"] forState:0];
    [viewBackground addSubview:btnShare];
    
    [btnToTop addTarget:self action:@selector(onTouchWithTop:) forControlEvents:UIControlEventTouchUpInside];
    [btnToButtom addTarget:self action:@selector(onTouchWithButtom:) forControlEvents:UIControlEventTouchUpInside];
    [btnShare addTarget:self action:@selector(onTouchWithShare:) forControlEvents:UIControlEventTouchUpInside];
  } else {
    [_btnPage setHidden:YES];
    [_viwePage setHidden:YES];
  }
}

#pragma mark - events

- (void)onTouchWithTouch:(UIButton *)sender {
  sender.selected = !sender.selected;
  if (sender.selected) {
    [UIView animateWithDuration:kDuration250ms animations:^{
      CGRect rect = _viwePage.frame;
      rect.origin.x = self.view.width - viewW - _btnPage.width-10;
      _viwePage.frame = rect;
      
      _viwePage.alpha = 1.;
    } completion:^(BOOL finished) {
      
    }];
  } else {
    [UIView animateWithDuration:kDuration250ms animations:^{
      CGRect rect = _viwePage.frame;
      rect.origin.x = self.view.width;
      _viwePage.frame = rect;
      
      _viwePage.alpha = 0.;
    } completion:^(BOOL finished) {
      
    }];
  }
}

- (void)onTouchWithTop:(UIButton *)sender {
  if (_webPage.webView) {
    [UIView animateWithDuration:kDuration250ms animations:^{
      CGPoint point = _webPage.webView.scrollView.contentOffset;
      point.y = 0;
      _webPage.webView.scrollView.contentOffset = point;
    } completion:^(BOOL finished) {
      
    }];
  }
}

- (void)onTouchWithButtom:(UIButton *)sender {
  if (_webPage.webView) {
    [UIView animateWithDuration:kDuration250ms animations:^{
      CGPoint point = _webPage.webView.scrollView.contentOffset;
      point.y = _webPage.webView.scrollView.contentSize.height - _webPage.webView.scrollView.bounds.size.height;
      _webPage.webView.scrollView.contentOffset = point;
    } completion:^(BOOL finished) {
      
    }];
  }
}

- (void)onTouchWithShare:(UIButton *)sender {
  DLog(@"onTouchWithShare");
}

#pragma mark - property
- (CGRect)webPageFrame {
  CGRect rc  = self.view.bounds;
  rc.origin.y = 20.0f;
  rc.size.height = self.view.height-34-rc.origin.y;
  return rc;
}

- (void)loadLink:(NSString *)link {
  [self loadLink:link viewLogo:nil];
}

- (void)loadLink:(NSString *)link viewLogo:(UIView *)viewLogo {
  if (_webPage) {
    [_webPage removeFromSuperview];
  }
  
  if (!_webPageManage) {
    _webPageManage = [[WebPageManage alloc] init];
    _webPageManage.delegate = self;
  }
  
  void(^showLoadingViewLogo)(UIView *) = ^(UIView *logo){
    UIView *viewCover = [[UIView alloc] initWithFrame:self.view.bounds];
    viewCover.backgroundColor = [UIColor whiteColor];
    
    [_webPage showLoadingCover:viewCover viewLogo:logo];
  };
  
  UIWebPage *currWebPage = [_webPageManage findWebPageWithOriginLink:link];
  if (currWebPage) {
    _webPage = currWebPage;
    _webPage.frame = self.view.bounds;
    [_webPageManage setCurrWebPage:_webPage];
    [_webPageManage moveCurrPageToLast];
    [_webPage load:link];
    if (_webPage.canBack) {
      showLoadingViewLogo(viewLogo);
    }
    else {
      if (_webPage.isShowCoverLogo) {
        [_webPage startCoverLogoAnimation];
      }
      else {
        UIView *viewCover = [[UIView alloc] initWithFrame:self.view.bounds];
        viewCover.backgroundColor = [UIColor whiteColor];
        [_webPage showLoadingCover:viewCover viewLogo:nil];
      }
    }
  }
  else {
    if (_webPageManage.numberOfWebPage>=kMaxWebPageNumber) {
      [_webPageManage removeAtTopExceptCurrWebPage];
    }
    _webPage = [_webPageManage newWebPageAndReturnWithFrame:self.view.bounds];
    [_webPageManage setCurrWebPage:_webPage];
    [_webPage load:link];
    
    showLoadingViewLogo(viewLogo);
  }
  
  [self.view insertSubview:_webPage atIndex:0];
}

- (void)setCurrWebPageAtIndex:(NSInteger)index {
  UIWebPage *webPage = [_webPageManage webPageAtIndex:index];
  if (webPage && webPage!=_webPage) {
    [_webPage removeFromSuperview];
    _webPage = webPage;
  }
}

- (void)hideCurrWebPageLoadingCover {
  BOOL isShowCoverLogo  = _webPage.isShowCoverLogo;
  BOOL isShowCoverView = _webPage.isShowCoverView;
  if (!isShowCoverLogo && isShowCoverView) {
    [_webPage hideLoadingCover];
  }
}

- (void)startAllCoverLogoAnimation {
  for (UIWebPage *webPage in _webPageManage.arrWebPage) {
    [webPage startCoverLogoAnimation];
  }
}

#pragma mark - WebPageManageDelegate: UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(nonnull UIScrollView *)scrollView {
  if ([_delegate respondsToSelector:@selector(controllerBrowser:scrollViewWillBeginDragging:)]) {
    [_delegate controllerBrowser:self scrollViewWillBeginDragging:scrollView];
  }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  CGPoint pt = [scrollView.panGestureRecognizer translationInView:self.view];
  if (pt.y==0) {
    // 横向拉动
    if (scrollView.contentOffset.x<-80) {
      [_delegate controllerBrowserWillDimiss:self willRemoveWebPage:_webPage];
    }
  }
  
}

- (void)webPageManage:(WebPageManage *)webPageManage didUpdateLink:(NSString *)link atIndex:(NSInteger)index {
  [[NSNotificationCenter defaultCenter] postNotificationName:kViewControllerNotionUpadtePaly object:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGPoint pt = [scrollView.panGestureRecognizer translationInView:self.view];
  if (pt.y==0) {
    // 横向拉动
  }
  if ([_delegate respondsToSelector:@selector(controllerBrowser:scrollViewDidScroll:)]) {
    [_delegate controllerBrowser:self scrollViewDidScroll:scrollView];
  }
}

#pragma mark - WebPageManageDelegate

- (void)webPageManage:(WebPageManage *)webPageManage reqLink:(NSString *)link urlOpenMode:(UrlOpenMode)urlOpenMode {
  //    NSURL *url = [NSURL URLWithString:link];
  
  switch (urlOpenMode) {
    case UrlOpenModeOpenInSelf:
    {
      [_webPage load:link];
    }break;
    case UrlOpenModeOpenInBackground:
    {
      if (_webPageManage.numberOfWebPage>=kMaxWebPageNumber) {
        [_webPageManage removeAtTopExceptCurrWebPage];
      }
      UIWebPage *webPage = [_webPageManage newWebPageAndReturnWithFrame:_webPage.frame];
      [webPage load:link];
      
      [_webPageManage moveCurrPageToLast];
    }break;
    case UrlOpenModeOpenInNewWindow:
    {
      if (_webPageManage.numberOfWebPage>=kMaxWebPageNumber) {
        [_webPageManage removeAtTopExceptCurrWebPage];
      }
      UIWebPage *webPage = [_webPageManage newWebPageAndReturnWithFrame:_webPage.frame];
      [webPage load:link];
      [self.view addSubview:webPage];
      
      CGFloat scale = 0.85;
      webPage.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(scale, scale),
                                                  CGAffineTransformMakeTranslation(webPage.width, 0));
      [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        webPage.transform = CGAffineTransformIdentity;
        _webPage.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(scale, scale),
                                                     CGAffineTransformMakeTranslation(-webPage.width, 0));
      } completion:^(BOOL finished) {
        [_webPage removeFromSuperview];
        _webPage = webPage;
        [_webPageManage setCurrWebPage:_webPage];
      }];
    }break;
    default:
      break;
  }
}

- (void)webPageManageDidEndLoad:(WebPageManage *)webPageManage atIndex:(NSInteger)index {
  if ([SettingConfig defaultSettingConfig].noPicture) {
    [[[webPageManage webPageAtIndex:index] webView]stringByEvaluatingJavaScriptFromString:@"JSHandleHideImage()"];
  }else{
    [[[webPageManage webPageAtIndex:index] webView] stringByEvaluatingJavaScriptFromString:@"JSHandleShowImage()"];
  }
  NSString* str1 =[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'",([SettingConfig defaultSettingConfig].fontSize * 10)+100.];
  UIWebPage *webPage = [webPageManage webPageAtIndex:index];
  NSString *title = webPage.webView.title;
  NSString *link = webPage.webView.link;
  [webPage.webView stringByEvaluatingJavaScriptFromString:str1];
  
  if (title.length>0 && link.length>0) {
    if (![SettingConfig defaultSettingConfig].nTraceBrowser) {
      ModelHistory *modelHisy = [ADOHistory queryModelWithLink:link];
      BOOL isExist = modelHisy?YES:NO;
      if (!modelHisy) {
        modelHisy = [ModelHistory modelHistory];
      }
      
      modelHisy.hTitle = title;
      modelHisy.hLink = link;
      modelHisy.hDatenow = [[NSDate date] timeIntervalSince1970];
      if (isExist) {
        NSInteger num = [modelHisy.hNumber integerValue];
        modelHisy.hNumber = [NSString stringWithFormat:@"%ld",num+1];
        [ADOHistory updateModel:modelHisy atUid:[NSString stringWithFormat:@"%ld",modelHisy.hid]];
      }
      else {
        modelHisy.hNumber = @"1";
        [ADOHistory InsertWithModelList:modelHisy];
      }
    }
  }
  
  [self loadPageButtonWithEnable:[SettingConfig defaultSettingConfig].isEnableWebButton];
}

#pragma mark - events

- (void)onNotificationAtFont:(NSNotification *)center {
  NSInteger itg = [[center object] integerValue];
  NSString* str1 =[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'",(itg*10)+100.];
  [_webPage.webView stringByEvaluatingJavaScriptFromString:str1];
}

- (void)onNOtificationAtPageButton:(NSNotification *)center {
  BOOL isEnable = [[center object] boolValue];
  [self loadPageButtonWithEnable:isEnable];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
