//
//  UIWebPage.m
//  Browser-Touch
//
//  Created by David on 14-5-21.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIWebPage.h"

#import "UnpreventableUILongPressGestureRecognizer.h"
#import "BlockUI.h"
#import "UIWebViewAdditions.h"
#import "MDRadialProgressView.h"
#import "UIImage+Bundle.h"
#import "MDRadialProgressTheme.h"
#import "NSString+URL.h"

#define kProgressWidthForZero (isPad?20.0f:10.0f)
#define kDragWidth 80.0f

#define kTextLeftContinue NSLocalizedString(@"leftContinue", nil)
#define kTextLeftRelease NSLocalizedString(@"leftRelease", nil)

#define kTextLeftContinueBackHome NSLocalizedString(@"leftContinueBackHome", nil)
#define kTextLeftReleaseBackHome NSLocalizedString(@"leftReleaseBackHome", nil)

#define kTextRightContinue NSLocalizedString(@"rightContinue", nil)
#define kTextRightRelease NSLocalizedString(@"rightRelease", nil)
#define kTextRightCannotForward NSLocalizedString(@"rightCannotForward", nil)

typedef NS_ENUM(NSInteger, CustomPanDirection) {
    CustomPanDirectionUnknow,
    CustomPanDirectionLeft,
    CustomPanDirectionRight,
    CustomPanDirectionTop,
    CustomPanDirectionBottom
};

@interface CustomPanGesture : UIPanGestureRecognizer

@property (nonatomic, assign) CustomPanDirection customPanDirection;

@end

@implementation CustomPanGesture

- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer {
    if (CustomPanDirectionUnknow!=self.customPanDirection || 2==self.minimumNumberOfTouches) {
        // 拦截手势传递
        return NO;
    }
    else {
        // 放行手势传递
        return YES;
    }
}

@end

// -----------------------------------------------------

@interface UIWebPage () <UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    // 下拉
    MDRadialProgressView *_progressRefresh;
    // 左右拉
    UIView *_viewDragL;
    UIImageView *_imageViewDragL;
    UILabel *_labelDragL;
    
    UIView *_viewDragR;
    UIImageView *_imageViewDragR;
    UILabel *_labelDragR;
    
    NSTimer *_timer;
    NSInteger _timeTicket;
    
    // cover
    UIView *_viewCover;
    UIView *_viewLogo;
}

/**
 *  初始化设置
 */
- (void)setup;

/**
 *  网页 长按 手势
 *
 *  @param longPressGesture
 */
- (void)longPressGesture:(UILongPressGestureRecognizer *)longPressGesture;

/**
 *  保存图片到相册回调
 *
 *  @param image
 *  @param error
 *  @param contextInfo
 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;

- (void)updateProgress:(CGFloat)progress;
- (void)resizeProgresView:(CGFloat)progress;

- (void)resetTimer;
- (void)timerWorking;
- (void)stopTimer;

@end

@implementation UIWebPage

@synthesize title = _title;
@synthesize link = _link;
@synthesize isLoading = _isLoading;
@synthesize isShowCoverLogo = _isShowCoverLogo;
@synthesize isShowCoverView = _isShowCoverView;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (void)dealloc
{
    _progressProxy.webViewProxyDelegate = nil;
    _webView.delegate = nil;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self resizeProgresView:_progress];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - property
- (NSString *)title
{
    if (!_snapshot) {
        if ([_link isEqualToString:_webView.link]) {
            _title = [_webView title];
            if (_title.length==0) {
                if (_isLoading) {
                    _title = NSLocalizedString(@"loading", nil);
                }
                else {
                    _title = NSLocalizedString(@"new-mark", nil);
                }
            }
        }
        else {
            if (_isLoading) {
                _title = NSLocalizedString(@"loading", nil);
            }
            else {
                _title = [_webView title];
                if (_title.length==0) {
                    _title = NSLocalizedString(@"new-mark", nil);
                }
            }
        }
    }
    return _title;
}

- (NSString *)link
{
    return _link;
}

- (BOOL)isShowCoverLogo
{
    return _viewLogo?YES:NO;
}

- (BOOL)isShowCoverView
{
    return _viewCover?YES:NO;
}

- (void)setShouldShowProgress:(BOOL)shouldShowProgress
{
    _shouldShowProgress = shouldShowProgress;
    if (_shouldShowProgress) {
        if (0.0==_progress) {
            [UIView animateWithDuration:0.1 animations:^{
                _viewProgress.alpha = 1.0;
            }];
        }
        
        [UIView animateWithDuration:0.25 delay:0 options:0 animations:^{
            [self resizeProgresView:_progress];
        } completion:nil];
    }
    else {
        [UIView animateWithDuration:0.1 animations:^{
            _viewProgress.alpha = 0;
        }];
    }
}

- (BOOL)canBack
{
    return _webView.canGoBack;
}

- (BOOL)canForward
{
    return _webView.canGoForward;
}

- (BOOL)isLoading
{
    return _isLoading;
}

- (BOOL)hasSnapshot
{
    return _snapshot;
}

- (void)setProgressColor:(UIColor *)progressColor
{
    _progressColor = progressColor;
    _viewProgress.backgroundColor = progressColor;
    [_viewProgress removeFromSuperview];
    [self addSubview:_viewProgress];
}

#pragma mark - private methods
- (void)setup
{
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _progressProxy.progressDelegate = self;
    _progressProxy.webViewProxyDelegate = self;
    
    self.backgroundColor = [UIColor clearColor];
    
    _webView = [[UIWebView alloc] initWithFrame:self.bounds];
    _webView.delegate = _progressProxy;
    _webView.scalesPageToFit = YES;
    _webView.opaque = YES;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _webView.clipsToBounds = NO;
    
    // TOTO: 扩展用，下拉 刷新，左 拉后腿，右 拉前进
    _webView.scrollView.backgroundColor = [UIColor clearColor];
    _webView.scrollView.delegate = self;
    _webView.scrollView.alwaysBounceHorizontal = YES;
    _webView.scrollView.alwaysBounceVertical = YES;
    _webView.scrollView.clipsToBounds = NO;
    
    CGRect rc = CGRectZero;
    rc.size.height = 3;
    rc.size.width = kProgressWidthForZero;
    _viewProgress = [[UIView alloc] initWithFrame:rc];
    _viewProgress.backgroundColor = [UIColor blueColor];
    _viewProgress.alpha = 0;
    
    [self addSubview:_webView];
    [self addSubview:_viewProgress];
    
    _progress = 1;
    _isLoading = NO;
    _snapshot = NO;
    _shouldShowProgress = YES;
    _shouldInterceptRequest = NO;
    
    
    // ------------ 下拉刷新
    rc.size.width =
    rc.size.height = 30;
    rc.origin.x = self.width*0.5-rc.size.width*0.5;
    rc.origin.y = 0;
    _progressRefresh = [[MDRadialProgressView alloc] initWithFrame:rc];
    _progressRefresh.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
	_progressRefresh.progressTotal = 100;
    _progressRefresh.progressCounter = 1;
	_progressRefresh.startingSlice = 1;
	_progressRefresh.clockwise = YES;
    _progressRefresh.theme.thickness =_progressRefresh.bounds.size.width-0;
	_progressRefresh.theme.completedColor = [UIColor colorWithRed:247./255. green:146./255. blue:77./255. alpha:1.];
	_progressRefresh.theme.sliceDividerThickness = 0;
    _progressRefresh.theme.dropLabelShadow = NO;
    [self insertSubview:_progressRefresh atIndex:0];
    
    // ---------- 左右拉
    {
        _viewDragL = [[UIView alloc] initWithFrame:self.bounds];
        _viewDragL.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
        
        _imageViewDragL = [[UIImageView alloc] initWithFrame:_viewDragL.bounds];
        _imageViewDragL.image = [[UIImage imageWithFile:@"res.bundle/shadow_left.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
        _imageViewDragL.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [_viewDragL addSubview:_imageViewDragL];
        
        _labelDragL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 200)];
        _labelDragL.numberOfLines = 0;
        _labelDragL.textColor = [UIColor grayColor];
        _labelDragL.text = kTextLeftContinue;
        _labelDragL.center = CGPointMake(_viewDragL.width/2, _viewDragL.height/2);
        _labelDragL.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
        [_viewDragL addSubview:_labelDragL];
        
        _labelDragL.font = [UIFont boldSystemFontOfSize:14];
        
        [self insertSubview:_viewDragL atIndex:0];
        
        _viewDragL.hidden = YES;
    }
    
    {
        _viewDragR = [[UIView alloc] initWithFrame:self.bounds];
        _viewDragR.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
        
        _imageViewDragR = [[UIImageView alloc] initWithFrame:_viewDragR.bounds];
        _imageViewDragR.image = [[UIImage imageWithFile:@"res.bundle/shadow_right.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
        _imageViewDragR.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [_viewDragR addSubview:_imageViewDragR];
        
        _labelDragR = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 200)];
        _labelDragR.numberOfLines = 0;
        _labelDragR.textColor = [UIColor grayColor];
        _labelDragR.text = kTextRightContinue;
        _labelDragR.center = CGPointMake(_viewDragR.width/2, _viewDragR.height/2);
        _labelDragR.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
        [_viewDragR addSubview:_labelDragR];
        
        _labelDragR.font = [UIFont boldSystemFontOfSize:14];
        
        [self insertSubview:_viewDragR atIndex:0];
        
        _viewDragR.hidden = YES;
    }
    
    
    UnpreventableUILongPressGestureRecognizer *longPressGesture = [[UnpreventableUILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    longPressGesture.allowableMovement = 20;
    longPressGesture.minimumPressDuration = 1.0f;
    [_webView addGestureRecognizer:longPressGesture];
    
//    CustomPanGesture *panGesture1 = [[CustomPanGesture alloc] initWithTarget:self action:@selector(panGesture:)];
//    panGesture1.delegate = self;
//    panGesture1.minimumNumberOfTouches = 1;
//    panGesture1.customPanDirection = CustomPanDirectionUnknow;
//    [_webView addGestureRecognizer:panGesture1];
//    
//    CustomPanGesture *panGesture2 = [[CustomPanGesture alloc] initWithTarget:self action:@selector(panGesture:)];
//    panGesture2.delegate = self;
//    panGesture2.minimumNumberOfTouches = 2;
//    [_webView addGestureRecognizer:panGesture2];
}

/**
 *  网页 长按 手势
 *
 *  @param longPressGesture
 */
- (void)longPressGesture:(UILongPressGestureRecognizer *)longPressGesture
{
    // 正在执行 页内查找 操作 不允许
    if (UIGestureRecognizerStateBegan==longPressGesture.state) {
        UIWebView *webView = (UIWebView *)longPressGesture.view;
        CGPoint point = [longPressGesture locationInView:webView];
        
        // convert point from view to HTML coordinate system
        CGSize viewSize = [webView frame].size;
        CGSize windowSize = [webView windowSize];
        
        CGFloat f = windowSize.width / viewSize.width;
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.) {
            point.x = point.x * f;
            point.y = point.y * f;
        } else {
            // On iOS 4 and previous, document.elementFromPoint is not taking
            // offset into account, we have to handle it
            CGPoint offset = [webView scrollOffset];
            point.x = point.x * f + offset.x;
            point.y = point.y * f + offset.y;
        }
        
        // Load the JavaScript code from the Resources and inject it into the web page
        NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"js.bundle/JSTools.js"];
        NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [webView stringByEvaluatingJavaScriptFromString: jsCode];
        
        // get the Tags at the touch location
        NSString *tags = [webView stringByEvaluatingJavaScriptFromString:
                          [NSString stringWithFormat:@"MyAppGetHTMLElementsAtPoint(%li,%li);",(long)point.x,(long)point.y]];
        
        NSString *tagsHREF = [webView stringByEvaluatingJavaScriptFromString:
                              [NSString stringWithFormat:@"MyAppGetLinkHREFAtPoint(%li,%li);",(long)point.x,(long)point.y]];
        
        NSString *tagsSRC = [webView stringByEvaluatingJavaScriptFromString:
                             [NSString stringWithFormat:@"MyAppGetLinkSRCAtPoint(%li,%li);",(long)point.x,(long)point.y]];
        
        NSArray *arrA = [tagsHREF componentsSeparatedByString:@","];
        NSArray *arrIMG = [tagsSRC componentsSeparatedByString:@","];
        
        NSString *href = nil;
        NSString *src = nil;
        if ([tags rangeOfString:@",A,"].location != NSNotFound) {
            href = arrA[1];
            NSURL *url = [NSURL URLWithString:href];
            if ([url.scheme isEqualToString:@"newtab"]) {
                href = [url.resourceSpecifier urlDecode]?:url.resourceSpecifier;
            }
        }
        if ([tags rangeOfString:@",IMG,"].location != NSNotFound) {
            src = arrIMG[1];
        }
        
        if (href || src) {
            void (^sheetClick)(UIActionSheet *, NSInteger) = ^(UIActionSheet *sheet, NSInteger buttonIndex){

                if (sheet.cancelButtonIndex==buttonIndex) {
                    return;
                }
                switch (buttonIndex) {
                    case 0:
                    {
                        // 打开
                        if ([_delegate respondsToSelector:@selector(webPage:reqLink:urlOpenMode:)])
                            [_delegate webPage:self reqLink:href.length>0?href:src urlOpenMode:UrlOpenModeOpenInSelf];
                    }
                        break;
                    case 1:
                    {
                        // 新窗口打开
                        if ([_delegate respondsToSelector:@selector(webPage:reqLink:urlOpenMode:)])
                            [_delegate webPage:self reqLink:href.length>0?href:src urlOpenMode:UrlOpenModeOpenInNewWindow];
                        
                    }
                        break;
                    case 2:
                    {
                        // 后台打开
                        if ([_delegate respondsToSelector:@selector(webPage:reqLink:urlOpenMode:)])
                            [_delegate webPage:self reqLink:href.length>0?href:src urlOpenMode:UrlOpenModeOpenInBackground];
                    }
                        break;
                    case 3:
                    {
                        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                        pasteboard.string = href.length>0?href:src;
                    }break;
                    case 4:
                    {
                        // 查看图片
                        if ([_delegate respondsToSelector:@selector(webPage:reqLink:urlOpenMode:)])
                            [_delegate webPage:self reqLink:href.length>0?src:href urlOpenMode:UrlOpenModeOpenInSelf];
                    }
                        break;
                    case 5:
                    {
                        // 下载图片
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:src]]];
                            if(image) {
                                dispatch_sync(dispatch_get_main_queue(), ^{
                                    // TODO: 保存图片
                                    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                                });
                            }
                        });
                    }
                        break;
                        
                    default:
                        break;
                }
            };
            
            UIActionSheet *sheet = nil;
            if (src) {
                sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:nil
                                           cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                      destructiveButtonTitle:NSLocalizedString(@"open", nil)
                                           otherButtonTitles:NSLocalizedString(@"open-a-new-win", nil), NSLocalizedString(@"o-i-t-back", nil),
                         NSLocalizedString(@"copy", nil), NSLocalizedString(@"view-Photo", nil), NSLocalizedString(@"d-pic", nil), nil];
            }
            else {
                sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:nil
                                           cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                      destructiveButtonTitle:NSLocalizedString(@"open", nil)
                                           otherButtonTitles:NSLocalizedString(@"open-a-new-win", nil), NSLocalizedString(@"o-i-t-back", nil), NSLocalizedString(@"copy", nil), nil];
            }
            
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
                [sheet showFromRect:CGRectMake(point.x-1, point.y-1, 2, 2) inView:self animated:YES withCompletionHandler:^(NSInteger buttonIndex) {
                    sheetClick(sheet, buttonIndex);
                }];
            }
            else {
                [sheet showInView:self.window withCompletionHandler:^(NSInteger buttonIndex) {
                    sheetClick(sheet, buttonIndex);
                }];
            }
        }
    }
}

- (void)panGesture:(UIPanGestureRecognizer *)panGesture
{
    DLog(@"----:%s:%ld", __FUNCTION__, (long)panGesture.state);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // TODO: 提示保存结果
    if (error) {
        DLog(@"%s:%ld:%@", __func__, (long)error.code, error);
    }
    else {
        // 成功
        DLog(@"%s:%ld:%@", __func__, (long)error.code, error);
    }
}

- (void)updateProgress:(CGFloat)progress
{
    if (progress == 0.0) {
        /**
         *  动画 显示，即时调整 frame
         */
        _isLoading = YES;
        if([_delegate respondsToSelector:@selector(webPageDidStartLoad:)])
            [_delegate webPageDidStartLoad:self];
        
        if (_shouldShowProgress) {
            [self resizeProgresView:progress];
            [UIView animateWithDuration:0.1 animations:^{
                _viewProgress.alpha = 1.0;
            }];
        }
        
        // TODO: 重置计时器，超时后 强制终止
        [self resetTimer];
    }
    else {
        /**
         *  动画调整 frame
         */
        if (_shouldShowProgress) {
            [UIView animateWithDuration:0.25 delay:0 options:0 animations:^{
                [self resizeProgresView:progress];
            } completion:nil];
        }
    }
    
    if (progress == 1.0) {
        [self stopTimer];
        /**
         *  动画 隐藏
         */
        _isLoading = NO;
        
        if([_delegate respondsToSelector:@selector(webPageDidEndLoad:)])
            [_delegate webPageDidEndLoad:self];
        
        [UIView animateWithDuration:0.25 delay:progress-_progress options:0 animations:^{
            _viewProgress.alpha = 0.0;
        } completion:nil];
        
        [self hideLoadingCover];
    }
    
    // 设置标题和链接
    if ([_delegate respondsToSelector:@selector(webPage:didUpdateTitle:)])
        [_delegate webPage:self didUpdateTitle:[self title]];
    
    if ([_delegate respondsToSelector:@selector(webPage:didUpdateLink:)])
        [_delegate webPage:self didUpdateLink:[self link]];
    
    _progress = progress;
}

- (void)resizeProgresView:(CGFloat)progress
{
    CGRect rc = _viewProgress.frame;
    rc.size.width = kProgressWidthForZero+progress*(self.bounds.size.width-kProgressWidthForZero);
    _viewProgress.frame = rc;
}

- (void)resetTimer
{
    if (_timer) {
        _timeTicket = 0;
    }
    else {
        _timeTicket = 0;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerWorking) userInfo:nil repeats:YES];
    }
}

- (void)timerWorking
{
    _timeTicket++;
    if (_timeTicket>=MIN(30, _webView.request.timeoutInterval)) {
        [self stopTimer];
        [self stop];
    }
}

- (void)stopTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
        _timeTicket = 0;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_delegate scrollViewDidScroll:scrollView];
    CGPoint pt = [scrollView.panGestureRecognizer translationInView:scrollView];
    if (pt.x==0) {
        // y轴方向移动
        if (scrollView.contentOffset.y<0) {
            _progressRefresh.hidden = NO;
            CGFloat y = fabs(scrollView.contentOffset.y);
            CGFloat yMore = y-_progressRefresh.progressTotal;
            CGAffineTransform tfScale = CGAffineTransformIdentity;
            if (yMore>0) {
                CGFloat scale = MIN(1+yMore/_progressRefresh.progressTotal, 2);
                _progressRefresh.progressCounter = _progressRefresh.progressTotal;
                tfScale = CGAffineTransformMakeScale(scale, scale);
            }
            else
            {
                _progressRefresh.progressCounter = MAX(y, 0);
            }
            
            CGAffineTransform tfTrans = CGAffineTransformMakeTranslation(0, MAX(0, (y-_progressRefresh.height)*0.5));
            _progressRefresh.transform = CGAffineTransformConcat(tfScale, tfTrans);
        }
        else {
            _progressRefresh.hidden = YES;
        }
    }
    else {
        _progressRefresh.hidden = YES;
        if (pt.y==0) {
            // x轴方向移动
            CGFloat right = scrollView.contentOffset.x+scrollView.width-scrollView.contentSize.width;
            CGFloat left = -scrollView.contentOffset.x;
            
            _viewDragL.hidden = YES;
            _viewDragR.hidden = YES;
            if (left>0) {
                
                if (_webView.canGoBack) {
                    // 这是要后退的节奏
                    
                    _viewDragL.hidden = NO;
                    CGRect rc = _webView.bounds;
                    rc.size.width = MAX(kDragWidth, left);
                    rc.origin.x = MIN(0, left-kDragWidth);
                    _viewDragL.frame = rc;
                    
                    _labelDragL.text = kTextLeftContinue;
                    if (left>kDragWidth) {
                        _labelDragL.text = kTextLeftRelease;
                    }
                }
                else {
                    // 这是要消失的节奏
                    
                    _viewDragL.hidden = YES;
                    
                    /*
                    _viewDragL.hidden = NO;
                    CGRect rc = _webView.bounds;
                    rc.size.width = MAX(kDragWidth, left);
                    rc.origin.x = MIN(0, left-kDragWidth);
                    _viewDragL.frame = rc;
                    
                    _labelDragL.text = kTextLeftContinueBackHome;
                    if (left>kDragWidth) {
                        _labelDragL.text = kTextLeftReleaseBackHome;
                    }
                     */
                }
            }
            if (right>0) {
                if (_webView.canGoForward) {
                    // 这是要前进的节奏
                    
                    _viewDragR.hidden = NO;
                    CGRect rc = _webView.bounds;
                    rc.size.width = MAX(kDragWidth, right);
                    rc.origin.x = self.width-right;
                    rc.origin.y = 0;
                    _viewDragR.frame = rc;
                    
                    _labelDragR.text = kTextRightContinue;
                    if (right>kDragWidth) {
                        _labelDragR.text = kTextRightRelease;
                    }
                }
                else {
                    _viewDragR.hidden = YES;
                    
                    _labelDragR.text = kTextRightCannotForward;
                }
            }
        }
        else {
            _viewDragL.hidden = YES;
            _viewDragR.hidden = YES;
        }
    }
    
    _viewProgress.transform = CGAffineTransformMakeTranslation(-scrollView.contentOffset.x, MAX(0, -scrollView.contentOffset.y));
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGPoint pt = [scrollView.panGestureRecognizer translationInView:scrollView];
    if (pt.x==0) {
        if (_progressRefresh.progressTotal==_progressRefresh.progressCounter) {
            [_webView reload];
        }
    }
    else if (pt.y==0) {
        
        // x轴方向移动
        CGFloat right = scrollView.contentOffset.x+scrollView.width-scrollView.contentSize.width;
        CGFloat left = -scrollView.contentOffset.x;
        
        if (left>kDragWidth) {
            // 这是要后退的节奏
            if (_webView.canGoBack) {
                // 能后退则后退
                [_webView goBack];
            }
            else {
                [_delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
            }
        }
        if (right>kDragWidth) {
            // 这是要前进的节奏
            if (_webView.canGoForward) {
                // 能前进则前进
                [_webView goForward];
            }
            else {
                [_delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
            }
        }
    }
}

#pragma mark - NJKWebViewProgressDelegate
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [self updateProgress:progress];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    if ([url hasPrefix:@"http://itunes.apple.com/"]||
        [url hasPrefix:@"https://itunes.apple.com/"]||
        [url hasPrefix:@"itms-apps://itunes.apple.com/"]) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    
    if (UIWebViewNavigationTypeLinkClicked==navigationType && _shouldInterceptRequest) {
        if ([request.URL.scheme isEqualToString:@"newtab"]) {
            // 处理多标签的
            url = [request.URL.resourceSpecifier urlDecode]?:request.URL.resourceSpecifier;
        }
        
        if (url.length>0) {
            if ([_delegate respondsToSelector:@selector(webPage:reqLink:urlOpenMode:)])
                [_delegate webPage:self reqLink:url urlOpenMode:UrlOpenModeOpenInSelf];
        }
        return NO;
    }
    
    if ([request.URL.scheme isEqualToString:@"newtab"]) {
        // 处理多标签的
        NSString *link = [request.URL.resourceSpecifier urlDecode]?:request.URL.resourceSpecifier;
        if (link.length>0) {
            if ([_delegate respondsToSelector:@selector(webPage:reqLink:urlOpenMode:)])
                [_delegate webPage:self reqLink:link urlOpenMode:UrlOpenModeOpenInNewWindow];
        }
        return NO;
    }
    
    if (UIWebViewNavigationTypeOther!=navigationType && ([url hasPrefix:@"http://"]||[url hasPrefix:@"https://"])) {
        _link = url;
        if ([_delegate respondsToSelector:@selector(webPage:didUpdateLink:)])
        {
            // 设置标题和链接
            if ([_delegate respondsToSelector:@selector(webPage:didUpdateTitle:)])
                [_delegate webPage:self didUpdateTitle:[self title]];
            
            if ([_delegate respondsToSelector:@selector(webPage:didUpdateLink:)])
                [_delegate webPage:self didUpdateLink:[self link]];
        }
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 自定义长按选择
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
  
    // 注入 JS（修改打开链接方式）
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"js.bundle/handle.js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [webView stringByEvaluatingJavaScriptFromString:jsCode];
    [webView stringByEvaluatingJavaScriptFromString:@"MyIPhoneApp_Init();"];
    
    NSString *link = webView.link;
    if ([link hasPrefix:@"http://"]||[link hasPrefix:@"https://"]) {
        _link = link;
    }
    
    // 设置标题和链接
    if ([_delegate respondsToSelector:@selector(webPage:didUpdateTitle:)])
        [_delegate webPage:self didUpdateTitle:[self title]];
    
    if ([_delegate respondsToSelector:@selector(webPage:didUpdateLink:)])
        [_delegate webPage:self didUpdateLink:[self link]];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DLog(@"%@", error);
    switch (error.code) {
        case NSURLErrorTimedOut:
        case NSURLErrorCannotFindHost:
        case NSURLErrorFileDoesNotExist:
        case NSURLErrorNotConnectedToInternet:
//        case 101:
        case 102:
        case 306:
        {
            // TODO: 这部分有待优化 ***
            NSString *htmlError = [NSString stringWithContentsOfURL:[[[NSBundle mainBundle] bundleURL] URLByAppendingPathComponent:@"html.bundle/koto_error.html"] encoding:NSUTF8StringEncoding error:nil];
            htmlError = [htmlError stringByReplacingOccurrencesOfString:@"@{code}" withString:[@(error.code) stringValue]];
            htmlError = [htmlError stringByReplacingOccurrencesOfString:@"@{title}" withString:error.localizedDescription];
            htmlError = [htmlError stringByReplacingOccurrencesOfString:@"@{error}" withString:[error description]];
            [webView loadHTMLString:htmlError baseURL:[[NSBundle mainBundle] bundleURL]];
            [self updateProgress:1];
        }break;
        default:
            break;
    }
}

#pragma mark - public methods
- (void)snapshot
{
    /**
     *  if _link 找不到host呢？
     */
    if (_snapshot || _link.length==0) {
        return;
    }
    
    _snapshot = YES;
    
    _imageViewSnapshot = [[UIImageView alloc] initWithFrame:_webView.bounds];
    _imageViewSnapshot.autoresizingMask = _webView.autoresizingMask;
    _imageViewSnapshot.backgroundColor = [UIColor whiteColor];
    _imageViewSnapshot.clipsToBounds = YES;
    _imageViewSnapshot.image = [UIImage imageFromView:_webView];
    [_webView loadHTMLString:@"" baseURL:nil];
    _webView.alpha = 0;
    
    [_webView removeFromSuperview];
    [self insertSubview:_imageViewSnapshot belowSubview:_viewProgress];
}

- (void)load:(NSString *)link
{
    _linkOrigin = link;
    _link = link;
    if ([_delegate respondsToSelector:@selector(webPage:didUpdateLink:)])
        [_delegate webPage:self didUpdateLink:[self link]];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:link]
                                           cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                       timeoutInterval:30]];
}

/**
 *  重新加载 网页 （*** 这是函数超重要）
 
 判断是否 有快照
    有：网页强制加载原来的链接地址
    无：判断是否是标准 href (带有 http:// 或 https:// 的 _link)
        是：
        否：
 */
- (void)reload
{
    if (_link) {
        if (_snapshot) {
            _snapshot = NO;
            [self insertSubview:_webView belowSubview:_imageViewSnapshot];
            [UIView animateWithDuration:1 animations:^{
                _imageViewSnapshot.alpha = 0;
                _webView.alpha = 1;
            } completion:^(BOOL finished) {
                [_imageViewSnapshot removeFromSuperview];
                _imageViewSnapshot = nil;
            }];
            
            // 一定要重新加载链接（***）
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_link]
                                                   cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                               timeoutInterval:30]];
        }
        else {
            if ([_webView title].length==0 || ![_webView.link isEqualToString:_link]) {
                [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_link]
                                                       cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                   timeoutInterval:30]];
            }
            else {
                [_webView reload];
            }
        }
    }
}

- (void)stop
{
    [_webView stopLoading];
    
    // TODO: 超重要
    [self updateProgress:1];
}

- (void)goBack
{
    [_webView goBack];
}

- (void)goForward
{
    [_webView goForward];
}

/**
 *  显示加载封面
 *
 *  @param viewCover 封面视图
 *  @param viewLogo logo视图
 */
- (void)showLoadingCover:(UIView *)viewCover viewLogo:(UIView *)viewLogo;
{
    if (_viewLogo) {
        [_viewLogo.layer removeAllAnimations];
        [_viewLogo removeFromSuperview];
        _viewLogo = nil;
    }
    
    if (_viewCover) {
        [_viewCover removeFromSuperview];
        _viewCover = nil;
    }
    
    viewCover.frame = self.bounds;
    viewCover.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [self insertSubview:viewCover belowSubview:_viewProgress];
    _viewCover = viewCover;
    
    self.userInteractionEnabled = NO;
    if (viewLogo) {
        viewLogo.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
        viewLogo.center = CGPointMake(viewCover.width/2, viewCover.height/2);
        [viewCover addSubview:viewLogo];
        _viewLogo = viewLogo;
        
        [self startCoverLogoAnimation];
    }
}

- (void)startCoverLogoAnimation
{
    if (_viewLogo) {
        [_viewLogo.layer removeAllAnimations];
        
        _viewLogo.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
        _viewLogo.center = CGPointMake(_viewCover.width/2, _viewCover.height/2);
        [_viewCover addSubview:_viewLogo];
        
        CABasicAnimation *animScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animScale.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.8, 0.8)];
        animScale.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
        
        CABasicAnimation *animOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animOpacity.fromValue = @(0.2);
        animOpacity.toValue = @(1);
        
        CAAnimationGroup *animGroup = [CAAnimationGroup animation];
        animGroup.animations = @[animScale, animOpacity];
        
        animGroup.autoreverses = YES;
        animGroup.duration = 0.5;
        animGroup.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.8 :0.1 :0.95 :0.95];
        animGroup.repeatCount = MAXFLOAT;
        [_viewLogo.layer addAnimation:animGroup forKey:@"group"];
    }
}

- (void)hideLoadingCover
{
    // 加载完成，隐藏加载封面
    if (_viewCover) {
        [UIView animateWithDuration:0.5 animations:^{
            _viewCover.alpha = 0;
        } completion:^(BOOL finished) {
            [_viewLogo.layer removeAllAnimations];
            [_viewLogo removeFromSuperview];
            _viewLogo = nil;
            
            [_viewCover removeFromSuperview];
            _viewCover = nil;
            
        }];
    }
    self.userInteractionEnabled = YES;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    DLog(@"%@ %@", [gestureRecognizer class], [otherGestureRecognizer class]);
    return NO;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    _DEBUG_LOG(@"%s  %@", __FUNCTION__, [gestureRecognizer class]);
//    return NO;
//}

@end
