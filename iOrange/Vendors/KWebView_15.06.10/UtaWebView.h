//
//  UtaWebView.h
//

#import <UIKit/UIKit.h>

#import "UIWebView+Clean.h"

#define kWebFailTips  @"出错提示"
#define kUtaWebViewReloadUrl @"utawebview://reload"

@interface UtaWebView : UIWebView

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *link;

@property (nonatomic, assign) CGFloat textSizeAdjust;

- (CGSize)windowSize;
- (CGPoint)scrollOffset;

/// 显示 加载出错提示
- (void)showFailHtmlWithError:(NSError *)error;

@end
