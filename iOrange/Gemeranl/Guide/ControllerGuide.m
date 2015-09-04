//
//  ControllerGuide.m
//  browser9374
//
//  Created by xiangkai yin on 14-6-14.
//  Copyright (c) 2014年 arBao. All rights reserved.
//
#ifndef isPhone
#define isPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#endif

#ifndef isPad
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#endif

#ifndef iPhone5
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#endif
#ifndef IOS7_OR_LATER
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#endif

#ifndef IOS_VERSION
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion]floatValue]
#endif

#ifndef iPhone6
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750,1334), [[UIScreen mainScreen] currentMode].size) : NO)
#endif

#ifndef iPhone6Plus
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)
#endif

#import "ControllerGuide.h"
#import "ViewController.h"
#import "SMPageControl.h"

@interface ControllerGuide () <UIScrollViewDelegate> {
  NSInteger _guideNum;
  UIScrollView *_scrollViewGuide;
}

@end

static BOOL _allowRotate = YES;

@implementation ControllerGuide
{
  SMPageControl *_pageControl;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
  if (isPhone) {
    return UIInterfaceOrientationMaskPortrait;
  }
  if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ||[UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)
  {
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown;
  }
  else
    return UIInterfaceOrientationMaskLandscape;
  
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
  if (isPhone) {
    return UIInterfaceOrientationPortrait;
  }
  if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ||[UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)
  {
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown;
  }
  else
    return UIInterfaceOrientationLandscapeLeft|UIInterfaceOrientationLandscapeRight;
}

- (BOOL)shouldAutorotate
{
  return _allowRotate;
}

//为了兼容IOS6以前的版本而保留的方法
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  if (isPhone) {
    return NO;
  }
  return _allowRotate;  //YES即在IOS6.0以下版本，支持所用方向的旋屏
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  _allowRotate = NO;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  //初始化一些必要的数据
  self.view.backgroundColor = [UIColor clearColor];
  [self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
  
  NSInteger guideNumber = [self finderNameAtPath];
  _guideNum = guideNumber;
  
  UIScrollView *aScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
  [aScrollView setBackgroundColor:[UIColor clearColor]];
  [aScrollView setPagingEnabled:YES];
  [aScrollView setShowsHorizontalScrollIndicator:NO];
  [aScrollView setShowsVerticalScrollIndicator:NO];
  [aScrollView setDelegate:self];
  _scrollViewGuide = aScrollView;
  
  CGRect rc = self.view.bounds;
  rc.size.height = 30;
  rc.origin.y = self.view.bounds.size.height-rc.size.height-(iPhone5?30:24)+15;
  /*
  _pageControl = [[SMPageControl alloc] initWithFrame:rc];
  _pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
  _pageControl.numberOfPages = guideNumber;
  _pageControl.currentPage = 0;
  [_pageControl addTarget:self action:@selector(onPageChanged) forControlEvents:UIControlEventValueChanged];
  [_pageControl setPageIndicatorImage:[UIImage imageNamed:@"dot-normal"]];
  [_pageControl setCurrentPageIndicatorImage:[UIImage imageNamed:@"dot-selected"]];
  [self.view addSubview:_pageControl];
  */
}

#pragma mark - UIScrollView
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  CGFloat maxOffsetX = scrollView.contentSize.width-scrollView.bounds.size.width;
  maxOffsetX = MAX(0, maxOffsetX);
  if (scrollView.contentOffset.x > maxOffsetX+50) {
    [self done];
  }
  
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  NSInteger currPage = scrollView.contentOffset.x/scrollView.bounds.size.width;
  _pageControl.currentPage = currPage;
}

#pragma mark - Events

static int i = 0;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  ++i;
  if ([change objectForKey:NSKeyValueChangeNewKey] != [NSNull null]) {
    if ([keyPath isEqualToString:@"frame"]) {
      /**
       *  注：需要给当前Controller加导航 才能适配横屏 若不需要横屏 则不需要
       *  在ios 5里面 如果有导航 竖屏 view.frame的 变化会有5次 但是参数一样，在横屏时候 view.frame会变化8次 但是会在第5次 修改frame 所以i==5
       *  在ios 6以后 或者无导航 view.frame只变化一次 也就说此方法只调用一次
       *  根据viewController的生命周期，在viewDidLoad以后来加载viewWillAppear用来构建视图层次，但此时渲染并未完成（详情查看API）
       *  当调用viewDidAppear时，视图渲染完毕，此时就可以确认当前是横屏还是竖屏，原因是因为在viewWillAppear和viewDidAppear之间
       *  系统做了个把view添加到window的操作，此时视图即将显示出来，所以在viewDidAppear里面不适合进行处理UI方面的操作
       *  这里监控self.view的变化来处理横竖屏变化，在系统把view添加到window时同时来处理横竖屏，因为此时view还没有渲染完毕（一点浅见）
       */
      if((IOS_VERSION>=6.0)||(self.navigationController?i==5:i==1)) {
        float height = self.view.frame.size.height;
        float width = self.view.frame.size.width;
        CGRect rect = CGRectZero;
        float paddY = 0;
        if (IOS7_OR_LATER) {
          if (isPad) {
            paddY = 0;
          }
        }
        for (int k =0; k<_guideNum; k++) {
          NSString *imageName = nil;
          if (IOS_VERSION <=7.0 && isPad && (!IsPortrait)) {
            rect = CGRectMake(height * k, paddY, height, width);
          } else
            rect = CGRectMake(width * k, paddY, width, height);
          
          if (height>width && ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait
                               ||[UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) {
            if (isPad) {
              imageName = [NSString stringWithFormat:@"iPad-guide-%d-v",k];
            }
            else if (iPhone5) {
              imageName = [NSString stringWithFormat:@"iPhone5-guide-%d-v@2x",k];
            }
            else if (iPhone6) {
              imageName = [NSString stringWithFormat:@"iPhone6-guide-%d-v@2x",k];
            }
            else if (iPhone6Plus){
              imageName = [NSString stringWithFormat:@"iPhone6Plus-guide-%d-v@3x",k];
            }
            else
              imageName = [NSString stringWithFormat:@"iPhone-guide-%d-v",k];
          }
          else
          {
            if (isPad) {
              imageName = [NSString stringWithFormat:@"iPad-guide-%d-h",k];
            }
            else if (iPhone5) {
              imageName = [NSString stringWithFormat:@"iPhone5-guide-%d-h@2x",k];
            }
            else if (iPhone6) {
              imageName = [NSString stringWithFormat:@"iPhone6-guide-%d-h@2x",k];
            }
            else if (iPhone6Plus){
              imageName = [NSString stringWithFormat:@"iPhone6Plus-guide-%d-h@3x",k];
            }
            else
              imageName = [NSString stringWithFormat:@"iPhone-guide-%d-h",k];
          }
        
          UIImageView *imgvGuideBackground = [[UIImageView alloc] initWithFrame:rect] ;
          imgvGuideBackground.backgroundColor = [UIColor clearColor];
          [imgvGuideBackground setImageWithName:imageName ofType:@"png"];
          
          [_scrollViewGuide addSubview:imgvGuideBackground];
          if (k == _guideNum-1) {
            imgvGuideBackground.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onGestireForTap:)];
            [imgvGuideBackground addGestureRecognizer:tapGesture];
            UIButton *button = [UIButton buttonWithType:0];
//            [button setBackgroundImage:[UIImage imageNamed:@"guide-bg-button"] forState:0];
            [button setTitleColor:RGBA(125., 192., 255., 1.) forState:0];
            [button setBounds:CGRectMake(0, 0, 140, 40)];
//            [button setTitle:NSLocalizedString(@"mashangtiyan", nil) forState:0];//没有国际化的打算
            [button setTitle:@"进入指尖世界" forState:0];
            [button setCenter:CGPointMake(rect.size.width/2, rect.size.height - (iPhone6Plus?100:(iPhone5?65:65)))];
            [button addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
            [button.layer setCornerRadius:3.];
            [button.layer setBorderWidth:1.];
            [button.layer setBorderColor:[UIColor colorWithRed:125./255 green:192./255. blue:255./255. alpha:1.].CGColor];
            [imgvGuideBackground addSubview:button];
          }
        }
        _scrollViewGuide.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        [_scrollViewGuide setContentSize:CGSizeMake(rect.size.width * _guideNum, 0)];
        [self.view addSubview:_scrollViewGuide];
        
//        [self.view bringSubviewToFront:_pageControl];//图片已经有pagecontroller
      }
    }
  }
}

- (NSArray *)getArrayForPlist
{
  NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
  NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
  NSArray *orientation;
  if (isPhone) {
    NSArray *array = [dictionary objectForKey:@"UISupportedInterfaceOrientations"];
    orientation = [NSArray arrayWithArray:array];
  }
  else
  {
    NSArray *array = [dictionary objectForKey:@"UISupportedInterfaceOrientations~ipad"];
    orientation = [NSArray arrayWithArray:array];
  }
  return orientation;
}

- (void)onGestireForTap:(UITapGestureRecognizer *)recognizer
{
  [self done];
}

- (void)done
{
  self.navigationController.navigationBarHidden = YES;
  [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  UIViewController *viewContronller ;
  if (isPad) {
    viewContronller = [[UIViewController alloc] init];
  }
  else
  {
    ViewController *vc = [ViewController loadFromStoryboard];
    viewContronller = vc;
  }
  [UIView animateWithDuration:0.35 animations:^{
    self.view.alpha = 0.0;
  } completion:^(BOOL finished) {
    if (isPad) {
      //带导航的
      //            [self.navigationController pushViewController:viewContronller animated:NO];
      [self presentViewController:viewContronller animated:NO completion:nil];
    }
    else
//      [self.navigationController pushViewController:viewContronller animated:NO];
      //不带导航的
      [self presentViewController:viewContronller animated:NO completion:nil];
  }];
}

- (float)finderNameAtPath
{
  NSFileManager *fm = [NSFileManager defaultManager];
  NSString *path = [[NSBundle mainBundle] resourcePath];
  NSArray *files = [fm subpathsAtPath:path];
  NSString *guideName = [NSString stringWithFormat:@"%@-guide",isPad?@"iPad":iPhone5?@"iPhone5":iPhone6Plus?@"iPhone6Plus":iPhone6?@"iPhone6":@"iPhone"];
  
  float k = 0;
  for (NSString *imageName in files) {
    if ([imageName rangeOfString:guideName].length>0) {
      k++;
    }
  }
  if (iPhone5||iPhone6||iPhone6Plus) {
    return k;
  }
  else if (isPad) {
    if ([self getArrayForPlist].count>2) {
      return k/4;
    }
    return k/2;
  }
  else
    return k/2;
  
}

- (void)onPageChanged
{
  [_scrollViewGuide setContentOffset:CGPointMake(_scrollViewGuide.bounds.size.width*_pageControl.currentPage, _scrollViewGuide.contentOffset.y) animated:YES];
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
/*
 * ---写在appdelegate的---
 if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
 }
 if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
 self.window.rootViewController = [[ControllerGuide alloc] init];
 }
 else {
 self.window.rootViewController = [[UIControllerRoot alloc] init];
 }
 */

@end


@implementation UIImageView (UIImageViewEx)

- (void)setImageWithName:(NSString *)imgName {
  [self setImageWithName:imgName ofType:@"png"];
}

- (void)setImageWithName:(NSString *)imgName ofType:(NSString *)ext {
  NSString *imgPath = [[NSBundle mainBundle] pathForResource:imgName ofType:ext];
  if ([UIScreen mainScreen].scale == 2) {
    NSString *imgPath2 = [[NSBundle mainBundle] pathForResource:[imgName stringByAppendingString:@"@2x"] ofType:ext];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imgPath2]) {
      imgPath = imgPath2;
    }
  }
  self.image = [UIImage imageWithContentsOfFile:imgPath];
}

@end

@implementation UINavigationController (Rotation_IOS6)

-(BOOL)shouldAutorotate {
  return [[self.viewControllers lastObject] shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations {
  return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
  if ([self isKindOfClass:[UIImagePickerController class]])
  {
    return UIInterfaceOrientationPortrait;
  }
  return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}
@end
