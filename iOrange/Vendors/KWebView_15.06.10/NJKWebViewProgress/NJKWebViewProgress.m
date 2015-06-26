//
//  NJKWebViewProgress.m
//
//  Created by Satoshi Aasano on 4/20/13.
//  Copyright (c) 2013 Satoshi Asano. All rights reserved.
//

#import "NJKWebViewProgress.h"

NSString *completeRPCURLPath = @"/njkwebviewprogressproxy/complete";

const float NJKInitialProgressValue = 0.06f;

@implementation NJKWebViewProgress {
    NSInteger _loadingCount;
    NSInteger _maxLoadCount;
    NSURL *_currentURL;
    BOOL _interactive;
}

- (id)init {
    if (self = [super init]) {
        _maxLoadCount = _loadingCount = 0;
        _interactive = NO;
    }
    
    return self;
}

- (void)startProgress {
    if (_progress < NJKInitialProgressValue) {
        [self setProgress:NJKInitialProgressValue];
    }
}

- (void)incrementProgress {
    float progress = _progress;
    float maxProgress = _interactive?1.0:NJKInitialProgressValue;
    float remainPercent = (float)_loadingCount/(float)_maxLoadCount;
    float increment = (maxProgress-progress)*remainPercent;
    progress += increment;
    progress = fmin(progress, maxProgress);
    
    [self setProgress:progress];
}

- (void)completeProgress {
    [self setProgress:1.0];
}

- (void)setProgress:(float)progress {
    // progress should be incremental only
    if (progress>_progress || progress==0) {
        _progress = progress;
        if ([_progressDelegate respondsToSelector:@selector(webViewProgress:updateProgress:)]) {
            [_progressDelegate webViewProgress:self updateProgress:progress];
        }
        if (_progressBlock) {
            _progressBlock(progress);
        }
    }
}

- (void)reset {
    _maxLoadCount = _loadingCount = 0;
    _interactive = NO;
    [self setProgress:0.0];
}

/// 加载结束
- (void)webViewLoadEnded:(UIWebView *)webView {
    _loadingCount = MAX(0, _loadingCount-1);
    [self incrementProgress];
    
    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive) {
        _interactive = YES;
        NSString *waitForCompleteJS = [NSString stringWithFormat:@"window.addEventListener('load',function() { var iframe = document.createElement('iframe'); iframe.style.display = 'none'; iframe.src = '%@://%@%@'; document.body.appendChild(iframe);  }, false);", webView.request.mainDocumentURL.scheme, webView.request.mainDocumentURL.host, completeRPCURLPath];
        [webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
    }
    
    BOOL isNotRedirect = _currentURL && [_currentURL isEqual:webView.request.mainDocumentURL];
    BOOL complete = [readyState isEqualToString:@"complete"];
    if (complete && isNotRedirect) {
        [self completeProgress];
    }
}

#pragma mark -
#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.path isEqualToString:completeRPCURLPath]) {
        [self completeProgress];
        return NO;
    }
    
    BOOL should = YES;
    if ([_webViewProxyDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        should = [_webViewProxyDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    BOOL isFragmentJump = NO;
    if (request.URL.fragment) {
        NSString *nonFragmentURL = [request.URL.absoluteString stringByReplacingOccurrencesOfString:[@"#" stringByAppendingString:request.URL.fragment] withString:@""];
        isFragmentJump = [nonFragmentURL isEqualToString:webView.request.URL.absoluteString];
    }

    BOOL isTopLevelNavigation = [request.mainDocumentURL isEqual:request.URL]; 
    BOOL isHTTP = [request.URL.scheme isEqualToString:@"http"] || [request.URL.scheme isEqualToString:@"https"];
    if (should && !isFragmentJump && isHTTP && isTopLevelNavigation) {
        _currentURL = request.URL;
        [self reset];
    }
    
    return should;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if ([_webViewProxyDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [_webViewProxyDelegate webViewDidStartLoad:webView];
    }

    _loadingCount++;
    _maxLoadCount = fmax(_maxLoadCount, _loadingCount);

    [self startProgress];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([_webViewProxyDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [_webViewProxyDelegate webViewDidFinishLoad:webView];
    }
    
    [self webViewLoadEnded:webView];
    
    // 内存处理之一
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [ud synchronize];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([_webViewProxyDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [_webViewProxyDelegate webView:webView didFailLoadWithError:error];
    }
    
    [self webViewLoadEnded:webView];
}

#pragma mark - 
#pragma mark Method Forwarding
// for future UIWebViewDelegate impl implementation
- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([super respondsToSelector:aSelector])
        return YES;
    
    if ([self.webViewProxyDelegate respondsToSelector:aSelector])
        return YES;
    
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    if (!signature) {
        if ([_webViewProxyDelegate respondsToSelector:selector]) {
            return [(NSObject *)_webViewProxyDelegate methodSignatureForSelector:selector];
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if ([_webViewProxyDelegate respondsToSelector:[invocation selector]]) {
        [invocation invokeWithTarget:_webViewProxyDelegate];
    }
}

@end
