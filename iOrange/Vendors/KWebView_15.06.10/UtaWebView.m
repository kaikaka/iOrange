//
//  UtaWebView.m
//

#import "UtaWebView.h"

#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface UtaWebView () <NJKWebViewProgressDelegate> {
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    /// 显示错误提示页时, 靠它来reload
    NSURLRequest *_startRequest;
}

@end

@implementation UtaWebView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configSubviews];
    }

    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self configSubviews];
}

- (void)setDelegate:(id<UIWebViewDelegate>)delegate {
    if (delegate == _progressProxy) {
        [super setDelegate:delegate];
    }
    else {
        _progressProxy.webViewProxyDelegate = delegate;
    }
}

- (void)configSubviews {
    self.textSizeAdjust = 1;
    self.backgroundColor = [UIColor whiteColor];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    self.delegate = _progressProxy;
    _progressProxy.progressDelegate = self;
 
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 2.0f)];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:_progressView];
    
    CGRect rc = self.bounds;
    rc.origin.x = 10;
    rc.size.width -= rc.origin.x*2;
    rc.size.height = 250;
    rc.origin.y = (self.bounds.size.height-rc.size.height)*0.5;
}

- (void)loadRequest:(NSURLRequest *)request {
    [super loadRequest:request];
    
    if ([request.URL.path compare:[[NSBundle mainBundle] bundlePath]] == NSOrderedSame) {
        return; // 是错误提示页不保存
    }
    
    if (_startRequest != request) {
        _startRequest = request;
    }
}

- (void)reload {
    if (_startRequest) {
        [self loadRequest:_startRequest];
    }
    else {
        [super reload];
    }
} 

- (NSString *)title {
    return [self stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (NSString *)link {
    if ([self.request.URL.path compare:[[NSBundle mainBundle] bundlePath]] == NSOrderedSame) {
        return nil; // 是错误提示页
    }
    
    NSString *link = self.request.URL.absoluteString;
    if (![link length]) {
        link = _startRequest.URL.absoluteString;
    }
    
    return link;
}

- (CGSize)windowSize {
    CGSize size;
    size.width = [[self stringByEvaluatingJavaScriptFromString:@"window.innerWidth"] integerValue];
    size.height = [[self stringByEvaluatingJavaScriptFromString:@"window.innerHeight"] integerValue];
    
    return size;
}

- (CGPoint)scrollOffset {
    CGPoint pt;
    pt.x = [[self stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] integerValue];
    pt.y = [[self stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] integerValue];
    
    return pt;
}

/// 显示 加载出错提示
- (void)showFailHtmlWithError:(NSError *)error {
    NSString *strFail = nil;
    switch ([error code]) {
        case NSURLErrorNotConnectedToInternet:
            strFail = @"木有网络连接! 请检查设置.";
            break;
        case 101: // WebKitErrorDomain:The URL can’t be shown
        case 102: // WebKitErrorDomain:Frame load interrupted
        case NSURLErrorBadURL:
            strFail = @"网址有误! 无法正确连接.";
            break;
        case NSURLErrorCannotFindHost:
            strFail = @"未找到此网页! 稍后再试试.";
            break;
        case NSURLErrorTimedOut:
            strFail = @"请求连接超时! 戳一戳重试.";
            break;

        default:
            break;
    }
    
    BOOL loadFail = strFail.length!=0;
    if (loadFail) {
        NSBundle *mb = [NSBundle mainBundle];
        NSString *localHtml = [NSString stringWithContentsOfFile:[mb pathForResource:@"web_error" ofType:@"html"]
                                                        encoding:NSUTF8StringEncoding
                                                           error:NULL];
        [self loadHTMLString:[NSString stringWithFormat:localHtml, kWebFailTips, kUtaWebViewReloadUrl, strFail]
                     baseURL:[NSURL fileURLWithPath:[mb bundlePath]]];
    }
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [_progressView setProgress:progress animated:YES];
}

@end
