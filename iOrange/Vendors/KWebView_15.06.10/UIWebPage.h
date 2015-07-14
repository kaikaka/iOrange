//
//  UIWebPage.h
//  Browser-Touch
//
//  Created by David on 14-5-21.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NJKWebViewProgress.h"
#import <QuartzCore/QuartzCore.h>



/**
 *  链接打开方式
 */
typedef NS_ENUM(NSInteger, UrlOpenMode) {
    /**
     *  当前窗口打开
     */
    UrlOpenModeOpenInSelf,
    /**
     *  后台打开
     */
    UrlOpenModeOpenInBackground,
    /**
     *  新窗口打开
     */
    UrlOpenModeOpenInNewWindow
};

@protocol UIWebPageDelegate;

@interface UIWebPage : UIView <NJKWebViewProgressDelegate, UIWebViewDelegate>
{
    NJKWebViewProgress *_progressProxy;
    UIImageView *_imageViewSnapshot;
    UIView *_viewProgress;
}

@property (nonatomic, weak) IBOutlet id<UIWebPageDelegate> delegate;

@property (nonatomic, strong, readonly) UIWebView *webView;

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *link;
@property (nonatomic, strong, readonly) NSString *linkOrigin;

@property (nonatomic, assign, readonly) BOOL isShowCoverLogo;
@property (nonatomic, assign, readonly) BOOL isShowCoverView;

@property (nonatomic, assign) BOOL show;

@property (nonatomic, strong) id userInfo;

/**
 *  是否显示 进度条，默认 YES
 */
@property (nonatomic, assign) BOOL shouldShowProgress;
@property (nonatomic, assign, readonly) CGFloat progress;
@property (nonatomic, assign, readonly) BOOL canBack;
@property (nonatomic, assign, readonly) BOOL canForward;
@property (nonatomic, assign, readonly) BOOL isLoading;

@property (nonatomic, strong) UIColor *progressColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) BOOL shouldInterceptRequest;

/**
 *  快照，检查是否有快照，快照需要外部来调用
 */
@property (nonatomic, assign, getter = hasSnapshot) BOOL snapshot;

/**
 *  抓拍 快照
 */
- (void)snapshot;

/**
 *  加载网页链接地址
 *
 *  @param link 链接地址
 */
- (void)load:(NSString *)link;

/**
 *  重新加载 网页 （*** 这是函数超重要）
 *  1、判断是否 有快照
 *      有：网页强制加载原来的链接地址
 *      无：判断是否是标准 href (带有 http:// 或 https:// 的 _link)
 */
- (void)reload;

/**
 *  停止加载
 */
- (void)stop;

/**
 *  后退
 */
- (void)goBack;

/**
 *  前进
 */
- (void)goForward;

/**
 *  显示加载封面
 *
 *  @param viewCover 封面视图
 *  @param viewLogo logo视图
 */
- (void)showLoadingCover:(UIView *)viewCover viewLogo:(UIView *)viewLogo;
- (void)startCoverLogoAnimation;
- (void)hideLoadingCover;

@end

@protocol UIWebPageDelegate <NSObject, UIScrollViewDelegate>

@optional
/**
 *  请求打开链接
 *
 *  @param webPage UIWebPage
 *  @param link        链接地址
 *  @param urlOpenMode 链接打开方式
 */
- (void)webPage:(UIWebPage *)webPage reqLink:(NSString *)link urlOpenMode:(UrlOpenMode)urlOpenMode;

/**
 *  开始加载, 外部接受此事件后 要显示 停止按钮
 *
 *  @param webPage UIWebPage
 */
- (void)webPageDidStartLoad:(UIWebPage *)webPage;

/**
 *  结束加载, 外部接受此事件后 要显示 刷新按钮
 *
 *  @param webPage UIWebPage
 */
- (void)webPageDidEndLoad:(UIWebPage *)webPage;

/**
 *  标题已更新
 *
 *  @param webPage UIWebPage
 *  @param title       网页标题
 */
- (void)webPage:(UIWebPage *)webPage didUpdateTitle:(NSString *)title;

/**
 *  网页链接
 *
 *  @param webPage UIWebPage
 *  @param link        网页链接
 */
- (void)webPage:(UIWebPage *)webPage didUpdateLink:(NSString *)link;

@end
