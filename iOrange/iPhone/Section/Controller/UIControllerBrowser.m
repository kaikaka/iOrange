//
//  UIControllerBrowser.m
//  Browser-Touch
//
//  Created by David on 14-7-31.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControllerBrowser.h"
#import "ADOHistory.h"

#import "UIWebViewAdditions.h"

#define kMaxWebPageNumber 10

@interface UIControllerBrowser () <WebPageManageDelegate, UIGestureRecognizerDelegate> {
  UIWebPage *_webPage;
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
  
  [UIWebPage appearance].progressColor = [UIColor orangeColor];//RGBCOLOR(0, 200, 0);
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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
  UIWebPage *webPage = [webPageManage webPageAtIndex:index];
  NSString *title = webPage.webView.title;
  NSString *link = webPage.webView.link;
  
  if (title.length>0 && link.length>0) {
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
