//
//  UIControllerBrowser.h
//  Browser-Touch
//
//  Created by David on 14-7-31.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIWebPage.h"
#import "WebPageManage.h"

@protocol UIControllerBrowserDelegate;

@interface UIControllerBrowser : UIViewController

@property (nonatomic, weak) id<UIControllerBrowserDelegate> delegate;
@property (nonatomic, strong, readonly) WebPageManage *webPageManage;
@property (nonatomic,strong, readonly)UIWebPage *webPage;

- (void)loadLink:(NSString *)link;
- (void)loadLink:(NSString *)link viewLogo:(UIView *)viewLogo;
- (void)setCurrWebPageAtIndex:(NSInteger)index;
- (void)hideCurrWebPageLoadingCover;
- (void)startAllCoverLogoAnimation;

@end

@protocol UIControllerBrowserDelegate <NSObject>

- (void)controllerBrowserWillDimiss:(UIControllerBrowser *)controllerBrowser willRemoveWebPage:(UIWebPage *)webPage;
//- (void)controllerBrowserDidLoad:(ModelSite *)modelSite;

- (void)controllerBrowser:(UIControllerBrowser *)controllerBrowser scrollViewWillBeginDragging:(UIScrollView *)scrollView;

- (void)controllerBrowser:(UIControllerBrowser *)controllerBrowser scrollViewDidScroll:(UIScrollView *)scrollView;

@end
