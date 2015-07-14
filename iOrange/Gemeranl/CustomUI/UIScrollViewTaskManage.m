//
//  UIScrollViewTaskManage.m
//  iStollStore
//
//  Created by xiangkai yin on 14-7-31.
//  Copyright (c) 2014年 VeryApps. All rights reserved.
//

#import "UIScrollViewTaskManage.h"

@interface UIScrollViewTaskManage()<UIScrollViewDelegate,UIViewTaskPageDelegate>
{
    BOOL            _isDismiss;
    BOOL            _isMoved;
    BOOL            _isRemoved;
    BOOL            _isPad;
    
    CGFloat         _sharePointX;
    NSInteger       _currentSpaceX;
    NSInteger       _heightSpace;
    NSInteger       _numberOfArray;
    NSInteger       _selectAtIndex;
    NSMutableArray  *_arrayWebPage;
    
    UIButton        *_btnForEamil;
    UIButton        *_btnForMessage;
    UIButton        *_btnForSina;
    UIButton        *_btnForWeChat;
    UIButton        *_btnForWeiXinTimeline;
    
    UIButton        *_btnShare;
    
    UIPageControl   *_controlPageView;
    UIScrollView    *_scrollViewHelp;
    UIScrollView    *_scrollViewListWeb;
    UITaskPageManage *_taskManagePages;
    UIView          *_animateForView;
    CGFloat         _shareCurrentX;
}

@end


@implementation UIScrollViewTaskManage

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBegin];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setBegin];
}

#pragma mark - public methods

- (UIViewTaskPage *)loadView:(UIView *)view
{
    UIWebPage *webPage = (UIWebPage *)view;
    UIViewTaskPage *viewTask = [[UIViewTaskPage alloc] initWithFrame:webPage.bounds];
    webPage.frame = webPage.bounds;
    viewTask.labTitle.text = webPage.title;
    [viewTask.webViewPage addSubview:webPage];
    [[UITaskPageManage sharedManage] addTaskView:viewTask];
    [self loadImageIcon:viewTask link:webPage.link];
    return viewTask;
}

- (void)addView:(UIView *)view
{
    if ([self isExistViewInArray:view]) return;
    [self loadView:view];
}

- (void)insertView:(UIView *)view atIndex:(NSInteger)index
{
    if ([self isExistViewInArray:view]) return;
    UIWebPage *webPage = (UIWebPage *)view;
    UIViewTaskPage *viewTask = [[UIViewTaskPage alloc] initWithFrame:webPage.bounds];
    webPage.frame = webPage.bounds;
    viewTask.labTitle.text = webPage.title;
    [viewTask.webViewPage addSubview:webPage];
    [[UITaskPageManage sharedManage] insertTaskView:viewTask atIndex:index];
    [self loadImageIcon:viewTask link:webPage.link];
}

- (void)removeView:(UIView *)view
{
    [[[UITaskPageManage sharedManage] nowArrayTask] enumerateObjectsUsingBlock:^(UIViewTaskPage *obj, NSUInteger idx, BOOL *stop) {
        if ([[obj.webViewPage.subviews objectAtIndex:0] isEqual:view]) {
            [[UITaskPageManage sharedManage] removeTaskView:obj];
            * stop = YES;
        };
    }];
}

- (void)removeViewAtIndex:(NSInteger)index
{
    [[UITaskPageManage sharedManage] removeTaskViewAtIndex:index];
}

- (void)setArrayOfView:(NSArray *)arrView
{
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
    [arrView enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        UIViewTaskPage *view = [self loadView:obj];
        [mutableArray addObject:view];
    }];
    [[UITaskPageManage sharedManage] setTaskArrayOfView:mutableArray];
}

- (UIView *)viewAtIndex:(NSInteger)index
{
    UIViewTaskPage *viewPage = (UIViewTaskPage *)[[UITaskPageManage sharedManage] taskViewAtIndex:index];
    return [viewPage.webViewPage.subviews objectAtIndex:0];
}

- (BOOL)isExistViewInArray:(UIView *)view
{
    __block BOOL isExist = NO;
    [[[UITaskPageManage sharedManage] nowArrayTask] enumerateObjectsUsingBlock:^(UIViewTaskPage *obj, NSUInteger idx, BOOL *stop) {
        if ([[obj.webViewPage.subviews objectAtIndex:0] isEqual:view]) {
            isExist = YES;
            * stop = YES;
        };
    }];
    return isExist;
}

- (NSInteger)indexForView:(UIView *)view
{
    return [[UITaskPageManage sharedManage] indexOfTaskView:view];
}

/**
 *  显示视图
 *
 *  @param view view
 */
- (void)showInView:(UIView *)view completion:(void(^)(void))completion
{
    self.alpha = 1.;
    [self scrollViewSubViewsRemoved];
    [view addSubview:self];
    _numberOfArray = [_taskManagePages nowArrayTask].count;
    self.backgroundColor = [UIColor clearColor];
    if (_numberOfArray==0) {
        [self animationNotForItem];
        return;
    }
    _isDismiss = NO;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    _selectAtIndex = [_taskManagePages currentSelectIndexForGet];
    if ([_arrayWebPage count]>0) {
        [_arrayWebPage removeAllObjects];
    }
    _arrayWebPage = [NSMutableArray arrayWithArray:[_taskManagePages nowArrayTask]];
    [self loadControlPage];
    
    _scrollViewListWeb.contentSize = CGSizeMake(_scrollViewListWeb.bounds.size.width*[_arrayWebPage count], _scrollViewListWeb.bounds.size.height);
    _scrollViewListWeb.contentOffset = CGPointMake(_scrollViewListWeb.bounds.size.width*([_arrayWebPage count]-1), 0);

    _scrollViewHelp.contentSize = CGSizeMake(_scrollViewHelp.bounds.size.width*[_arrayWebPage count], _scrollViewHelp.bounds.size.height);
    _scrollViewHelp.contentOffset = CGPointMake(_scrollViewHelp.bounds.size.width*([_arrayWebPage count]-1), 0);
    CGRect rcVisible = [view convertRect:self.bounds toView:_scrollViewListWeb];

    [_arrayWebPage enumerateObjectsUsingBlock:^(UIViewTaskPage *taskPage, NSUInteger idx, BOOL *stop) {
        taskPage.transform = CGAffineTransformIdentity;
        taskPage.delegate = self;
        taskPage.frame = rcVisible;
        [_scrollViewListWeb addSubview:taskPage];
    }];
    CGAffineTransform tfScale = CGAffineTransformMakeScale(ThumbScale, ThumbScale);
    [_arrayWebPage enumerateObjectsUsingBlock:^(UIViewTaskPage *webPage, NSUInteger idx, BOOL *stop) {
        webPage.transform = tfScale;
    }];

    UIViewTaskPage *webPage = [_arrayWebPage lastObject];
    CGPoint center = webPage.center;
    center.x = ([self thumbScrollViewW]) * ([_arrayWebPage count]-1) + [self thumbScrollViewW]/2;
    webPage.center = center;

    if (UIInterfaceOrientationIsPortrait(orientation)) {
        _controlPageView.center = CGPointMake(self.center.x, self.bounds.size.height-47);
    }
    else
        _controlPageView.center = CGPointMake(self.center.x, self.bounds.size.height-17);
    
    [_arrayWebPage enumerateObjectsUsingBlock:^(UIViewTaskPage *taskPage, NSUInteger idx, BOOL *stop) {
        CGPoint center = taskPage.center;
        center.x = ([self thumbScrollViewW]) * idx;
        if ([_arrayWebPage count]-1 == idx) {
            center.x += [self thumbScrollViewW]/2;
        }
        taskPage.center = center;
    }];
    
    [UIView animateWithDuration:0.12 delay:ShowAnimationTime options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_arrayWebPage enumerateObjectsUsingBlock:^(UIViewTaskPage *taskPage, NSUInteger idx, BOOL *stop) {
            if ([_arrayWebPage count]-1 != idx) {
                CGPoint center = taskPage.center;
                center.x += [self thumbScrollViewW]/2;
                taskPage.center = center;
            }
        }];
    } completion:^(BOOL finished) {
        [self.superview addSubview:_btnShare];
        [self.superview addSubview:_controlPageView];
    }];
    if (completion) completion();
}

/**
 *  未访问站点调用此方法
 */
- (void)animationNotForItem
{
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:self.bounds];
    [promptLabel setBackgroundColor:[UIColor clearColor]];
    [promptLabel setText:NSLocalizedString(@"nsvy", nil)];
    [promptLabel setTextColor:[UIColor whiteColor]];
    [promptLabel setTextAlignment:NSTextAlignmentCenter];
    [promptLabel setAlpha:0.];
    [self addSubview:promptLabel];
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [promptLabel setAlpha:1.];
    } completion:^(BOOL finished) {
        dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, 0.8 * NSEC_PER_SEC);
        dispatch_after(when, dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.35 animations:^{
                promptLabel.alpha = 0.;
                self.alpha = 0.;
            } completion:^(BOOL finished) {
                [promptLabel removeFromSuperview];
                [self removeFromSuperview];
            }];
        });
        
        if ([_delegate respondsToSelector:@selector(viewTaskManageEmpty:isAfterOfAnimate:)]) {
            [_delegate viewTaskManageEmpty:self isAfterOfAnimate:YES];
        }
    }];
}

- (void)loadImageIcon:(UIViewTaskPage *)viewTask link:(NSString *)link
{
    NSURL *url = [NSURL URLWithString:link];
    NSString *icoLink = [NSString stringWithFormat:@"http://%@/favicon.ico", url.host];
    
    NSString *icoPath = [GetCacheDirAppend(@"ico") stringByAppendingPathComponent:[icoLink fileNameMD5WithExtension:@"ico"]];
    UIImage *ico = [UIImage imageWithContentsOfFile:icoPath];
    if (ico) {
        viewTask.imgvIcon.image = ico;
        return;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:icoLink]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               UIImage *image = [UIImage imageWithData:data];
                               if (image) {
                                   viewTask.imgvIcon.image = [UIImage imageWithData:data];
                                   [data writeToFile:icoPath atomically:NO];
                               }
                               else {
                                   
                               }
                           }];
}

#pragma mark - private methods

- (CGFloat)thumbW
{
    return ThumbScale * self.bounds.size.width;
}

- (CGFloat)thumbScrollViewW
{
    return 0.7 * self.bounds.size.width;
}

- (CGFloat)thumbH
{
    return ThumbScale * self.bounds.size.height;
}

- (void)loadShareButtonItem
{
    CGRect rect = CGRectMake(CGRectGetWidth(self.bounds)*0.8+_currentSpaceX-50,CGRectGetHeight(self.bounds)*(1-ThumbScale)/2-_heightSpace,34,34);
    UIButton *btnMessage = [UIButton buttonWithType:0];
    [btnMessage setImage:[UIImage imageWithFile:@"Image/iPhone/window/icon00-Share.png"] forState:UIControlStateNormal];
    [btnMessage setFrame:rect];
    [btnMessage addTarget:self action:@selector(onTouchWithItems:) forControlEvents:UIControlEventTouchUpInside];
    [btnMessage setTag:TMShareButtonItemFaceBook];
    _btnForMessage = btnMessage;
    [self addSubview:btnMessage];
    
    rect = btnMessage.frame;
    UIButton *btnEmail = [UIButton buttonWithType:0];
    [btnEmail setTag:TMShareButtonItemEmail];
    [btnEmail setImage:[UIImage imageWithFile:@"Image/iPhone/window/icon01-Share.png"] forState:UIControlStateNormal];
    [btnEmail setFrame:rect];
    [btnEmail addTarget:self action:@selector(onTouchWithItems:) forControlEvents:UIControlEventTouchUpInside];
    _btnForEamil = btnEmail;
    [self addSubview:btnEmail];
    
    rect = btnEmail.frame;
    
    UIButton *btnWeChat = [UIButton buttonWithType:0];
    [btnWeChat setTag:TMShareButtonItemTwitter];
    [btnWeChat setImage:[UIImage imageWithFile:@"Image/iPhone/window/icon02-Share.png"] forState:UIControlStateNormal];
    [btnWeChat setFrame:rect];
    [btnWeChat addTarget:self action:@selector(onTouchWithItems:) forControlEvents:UIControlEventTouchUpInside];
    _btnForWeChat = btnWeChat;
    [self addSubview:btnWeChat];
    
    rect = btnWeChat.frame;
    UIButton *btnMoments = [UIButton buttonWithType:0];
    [btnMoments setTag:TMShareButtonItemSMS];
    [btnMoments setImage:[UIImage imageWithFile:@"Image/iPhone/window/icon04-Share.png"] forState:UIControlStateNormal];
    [btnMoments setFrame:rect];
    [btnMoments addTarget:self action:@selector(onTouchWithItems:) forControlEvents:UIControlEventTouchUpInside];
    _btnForWeiXinTimeline = btnMoments;
    [self addSubview:btnMoments];
    
    rect = btnMoments.frame;
    UIButton *btnSina = [UIButton buttonWithType:0];
    [btnSina setTag:TMShareButtonItemCopy];
    [btnSina setImage:[UIImage imageWithFile:@"Image/iPhone/window/icon03-Share.png"] forState:UIControlStateNormal];
    [btnSina setFrame:rect];
    [btnSina addTarget:self action:@selector(onTouchWithItems:) forControlEvents:UIControlEventTouchUpInside];
    _btnForSina = btnSina;
    [self addSubview:btnSina];
    
    [_btnForEamil setAlpha:0.];
    [_btnForMessage setAlpha:0.];
    [_btnForSina setAlpha:0.];
    [_btnForWeChat setAlpha:0.];
    [_btnForWeiXinTimeline setAlpha:0.];
}

- (void)removePartSubviews
{
    for (UIView *view in _scrollViewListWeb.subviews) {
        if (view.tag == 710) {
            continue;
        }
        [view removeFromSuperview];
    }
}

- (void)setAlphaZeroForSubviews
{
    _btnShare.alpha = 0.;
    _controlPageView.alpha = 0.;
}

- (void)setAlphaFullForSubviews
{
    _btnShare.alpha = 1.;
    _controlPageView.alpha = 1.;
}

- (void)resizedSubViews
{
    [_btnShare setFrame:CGRectMake(CGRectGetWidth(self.bounds)*0.8-16-_currentSpaceX/2,CGRectGetHeight(self.bounds)*(1-ThumbScale)/2, 16, 16)];
}

- (void)loadInitialization
{
    _taskManagePages = [UITaskPageManage sharedManage];
    _isPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    _currentSpaceX = _isPad?60:20;
    _sharePointX = 200;
    _shareCurrentX = _isPad?0:50;
    _heightSpace = 20;
}

- (void)setBegin
{
   
    [self loadInitialization];
    if (!_scrollViewHelp) {
        _scrollViewHelp = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollViewHelp.backgroundColor = [UIColor clearColor];
        _scrollViewHelp.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _scrollViewHelp.pagingEnabled = NO;
        _scrollViewHelp.showsHorizontalScrollIndicator = NO;
        _scrollViewHelp.showsVerticalScrollIndicator = NO;
        _scrollViewHelp.delegate = self;
        [self addSubview:_scrollViewHelp];
    }
    
    if (!_scrollViewListWeb) {
        _scrollViewListWeb = [[UIScrollView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-[self thumbScrollViewW]/2,
                                                                            self.bounds.size.height/2-[self thumbH]/2-_heightSpace,
                                                                            [self thumbScrollViewW],[self thumbH]+_heightSpace)];
        _scrollViewListWeb.clipsToBounds = NO;
        _scrollViewListWeb.backgroundColor = [UIColor clearColor];
        _scrollViewListWeb.showsHorizontalScrollIndicator = NO;
        _scrollViewListWeb.showsVerticalScrollIndicator = NO;
        _scrollViewListWeb.pagingEnabled = NO;
        _scrollViewListWeb.scrollEnabled = YES;
        _scrollViewListWeb.delegate = self;
        _scrollViewListWeb.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_scrollViewListWeb];
    }
    
    if (!_controlPageView) {
        _controlPageView = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)];
        _controlPageView.center = CGPointMake(self.center.x, self.bounds.size.height-22);
        _controlPageView.alpha = 0.;
        _controlPageView.userInteractionEnabled = NO;
    }
    if (!_btnShare) {
        UIImage *shareImage = [UIImage imageWithFile:@"Image/iPhone/window/icon-Share.png"];
        UIButton *btnToShare = [UIButton buttonWithType:0];
        [btnToShare setImage:shareImage forState:UIControlStateNormal];
        [btnToShare setImage:shareImage forState:UIControlStateSelected];
        [btnToShare setFrame:CGRectMake(CGRectGetWidth(self.bounds)*(1+ThumbScale)/2 - shareImage.size.width,
                                        CGRectGetHeight(self.bounds)*(1-ThumbScale)/2,
                                        shareImage.size.width, shareImage.size.height)];
//        [btnToShare addTarget:self action:@selector(onTouchWithShare:) forControlEvents:UIControlEventTouchUpInside];
        [btnToShare setTag:710];
        //隐藏掉这个页面的分享按钮(即取消分享)
        [btnToShare setHidden:YES];
        _btnShare = btnToShare;
        [self setAlphaZeroForSubviews];
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topGesture:)];
    [self addGestureRecognizer:tapGesture];
    
    [self loadShareButtonItem];
}

- (void)loadControlPage
{
    _controlPageView.numberOfPages =  _numberOfArray;
    _controlPageView.currentPage = _numberOfArray-1;
}

- (void)dismissAnimation:(void (^)(UIView *, NSInteger))currentTaskView completion:(void (^)(void))completion
{
    if (_isMoved) {
        [self animationDidEndWithCompletion:^{
            [self viewBackToHomeWith:currentTaskView completion:completion];
        }];
    }
    else
    {
        [self viewBackToHomeWith:currentTaskView completion:completion];
    }
   
}

- (void)animationWillBegin
{
    _isMoved = YES;
    CGFloat moveY = 54;
    [UIView animateWithDuration:0.35 animations:^{
        [_btnForMessage setAlpha:1.];
        [_btnForEamil setAlpha:1.];
        [_btnForSina setAlpha:1.];
        [_btnForWeiXinTimeline setAlpha:1.];
        [_btnForWeChat setAlpha:1.];
        
        CGRect rect = _btnForMessage.frame;
        _btnForMessage.frame = rect;
        
        rect = _btnForMessage.frame;
        rect.origin.y += moveY;
        _btnForEamil.frame = rect;
        
        rect = _btnForEamil.frame;
        rect.origin.y += moveY;
        _btnForWeChat.frame = rect;
        
        rect = _btnForWeChat.frame;
        rect.origin.y += moveY;
        _btnForWeiXinTimeline.frame = rect;
        
        rect = _btnForWeiXinTimeline.frame;
        rect.origin.y += moveY;
        _btnForSina.frame = rect;
        
    } completion:^(BOOL finished) {
        _scrollViewListWeb.clipsToBounds = YES;
        _scrollViewListWeb.scrollEnabled = NO;
        _scrollViewListWeb.userInteractionEnabled = NO;
        _scrollViewHelp.scrollEnabled = NO;
        _scrollViewHelp.userInteractionEnabled = NO;
        [_btnShare setSelected:YES];
    }];
    
    [UIView animateWithDuration:0.22 animations:^{
        CGFloat f = floorf(_scrollViewListWeb.contentOffset.x/(_scrollViewListWeb.bounds.size.width));
        if ([_arrayWebPage count]-1 == f) {
            if (f-1>=0) {
                UIViewTaskPage *webPageLast = [_arrayWebPage objectAtIndex:f-1];
                CGPoint point = webPageLast.center;
                point.x -= _sharePointX;
                webPageLast.center = point;
            }
        }
        else
        {
            CGPoint currentPoint = CGPointZero;
            if (f-1>=0) {
                UIViewTaskPage *webPageLast = [_arrayWebPage objectAtIndex:f-1];
                currentPoint = webPageLast.center;
                currentPoint.x -= _sharePointX;
                webPageLast.center = currentPoint;
            }
            if (f+1>=1) {
                UIViewTaskPage *webPageNext = [_arrayWebPage objectAtIndex:f+1];
                currentPoint = webPageNext.center;
                currentPoint.x += _sharePointX;
                webPageNext.center = currentPoint;
            }
        }
        CGPoint currentPoint = _scrollViewListWeb.center;
        currentPoint.x -= _shareCurrentX;
        _scrollViewListWeb.center = currentPoint;
        
        currentPoint = _btnShare.center;
        currentPoint.x -= _shareCurrentX;
        _btnShare.center = currentPoint;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)animationDidEndWithCompletion:(void(^)(void))completion
{
    [UIView animateWithDuration:0.35 animations:^{
        CGRect rect = CGRectMake(CGRectGetWidth(self.bounds)*0.8+_currentSpaceX-50,CGRectGetHeight(self.bounds)*(1-ThumbScale)/2-_heightSpace,34,34);;
        _btnForMessage.frame = rect;
        _btnForEamil.frame = rect;
        _btnForSina.frame = rect;
        _btnForWeChat.frame = rect;
        _btnForWeiXinTimeline.frame = rect;
        
        [_btnForEamil setAlpha:0.];
        [_btnForMessage setAlpha:0.];
        [_btnForSina setAlpha:0.];
        [_btnForWeChat setAlpha:0.];
        [_btnForWeiXinTimeline setAlpha:0.];
    } completion:^(BOOL finished) {
        
        [_scrollViewListWeb setClipsToBounds:NO];
        [_scrollViewListWeb setScrollEnabled:YES];
        [_scrollViewListWeb setUserInteractionEnabled:YES];
        [_scrollViewHelp setScrollEnabled:YES];
        [_scrollViewHelp setUserInteractionEnabled:YES];
        [_btnShare setSelected:NO];
        
        [UIView animateWithDuration:0.22 animations:^{
            if (!_isMoved) {
                CGFloat f = floorf(_scrollViewListWeb.contentOffset.x/(_scrollViewListWeb.bounds.size.width));
                if ([_arrayWebPage count]-1 == f) {
                    if (f-1>=0) {
                        UIViewTaskPage *webPageLast = [_arrayWebPage objectAtIndex:f-1];
                        CGPoint point = webPageLast.center;
                        point.x += _sharePointX;
                        webPageLast.center = point;
                    }
                }
                else
                {
                    CGPoint currentPoint = CGPointZero;
                    if (f-1>=0) {
                        UIViewTaskPage *webPageLast = [_arrayWebPage objectAtIndex:f-1];
                        currentPoint = webPageLast.center;
                        currentPoint.x += _sharePointX;
                        webPageLast.center = currentPoint;
                    }
                    if (f+1>=1) {
                        UIViewTaskPage *webPageNext = [_arrayWebPage objectAtIndex:f+1];
                        currentPoint = webPageNext.center;
                        currentPoint.x -= _sharePointX;
                        webPageNext.center = currentPoint;
                    }
                }
            }
            
            CGPoint currentPoint = _scrollViewListWeb.center;
            currentPoint.x += _shareCurrentX;
            _scrollViewListWeb.center = currentPoint;
            
            currentPoint = _btnShare.center;
            currentPoint.x += _shareCurrentX;
            _btnShare.center = currentPoint;
        } completion:^(BOOL finished) {
            if (completion) completion();
            
            [UIView animateWithDuration:0.22 animations:^{
                CGFloat f = floorf(_scrollViewListWeb.contentOffset.x/(_scrollViewListWeb.bounds.size.width));
                if ([_arrayWebPage count]-1 == f) {
                    if (f-1>=0) {
                        UIViewTaskPage *webPageLast = [_arrayWebPage objectAtIndex:f-1];
                        CGPoint point = webPageLast.center;
                        point.x += _sharePointX;
                        webPageLast.center = point;
                    }
                }
                else
                {
                    CGPoint currentPoint = CGPointZero;
                    if (f-1>=0) {
                        UIViewTaskPage *webPageLast = [_arrayWebPage objectAtIndex:f-1];
                        currentPoint = webPageLast.center;
                        currentPoint.x += _sharePointX;
                        webPageLast.center = currentPoint;
                    }
                    if (f+1>=1) {
                        UIViewTaskPage *webPageNext = [_arrayWebPage objectAtIndex:f+1];
                        currentPoint = webPageNext.center;
                        currentPoint.x -= _sharePointX;
                        webPageNext.center = currentPoint;
                    }
                }
            }];
        }];
        
        _isMoved = NO;
    }];
}

- (void)scroll:(UIScrollView *)scrollView toAnimated:(BOOL)animated completion:(void(^)(void))completion
{
    scrollView.userInteractionEnabled = NO;
    CGFloat index = floorf((_scrollViewListWeb.contentOffset.x + _scrollViewListWeb.bounds.size.width/2)/(_scrollViewListWeb.bounds.size.width));
    CGPoint centerOfViewWebPage = CGPointMake(_scrollViewListWeb.bounds.size.width*index+_scrollViewListWeb.bounds.size.width/2, _scrollViewListWeb.bounds.size.height/2);
    CGRect rcVisible = CGRectMake(centerOfViewWebPage.x - _scrollViewListWeb.bounds.size.width/2,
                                  0,[self thumbScrollViewW],_scrollViewListWeb.bounds.size.height);
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            
            [_scrollViewListWeb scrollRectToVisible:rcVisible animated:NO];
        } completion:^(BOOL finished) {
            scrollView.userInteractionEnabled = YES;
            if (completion) completion();
        }];
    }
    else {
        scrollView.userInteractionEnabled = YES;
        [_scrollViewListWeb scrollRectToVisible:rcVisible animated:NO];
    }
}

- (void)topGesture:(UITapGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:recognizer.view];
    UIViewTaskPage *currentTaskView = [_arrayWebPage objectAtIndex:_selectAtIndex];
    CGRect rect = [_scrollViewListWeb convertRect:currentTaskView.frame toView:self];
    BOOL isInCurrentView = CGRectContainsPoint(rect, point);
    if (isInCurrentView) {
        if (_isMoved) {
            [self animationDidEndWithCompletion:^{
                [self viewBackToBrowserForCurrentView:currentTaskView];
            }];
        }
        else
        {
            [self viewBackToBrowserForCurrentView:currentTaskView];
        }
        
        return;
    }
    if (!isInCurrentView) {
        if (_selectAtIndex-1>=0) {
            UIViewTaskPage *lastTaskView = [_arrayWebPage objectAtIndex:_selectAtIndex-1];
            CGRect rect = [_scrollViewListWeb convertRect:lastTaskView.frame toView:self];
            BOOL isInLastTaskView = CGRectContainsPoint(rect, point);
            if (isInLastTaskView) {
                [UIView animateWithDuration:0.22 animations:^{
                    CGPoint listPoint = _scrollViewListWeb.contentOffset;
                    listPoint.x -= _scrollViewListWeb.bounds.size.width;
                    _scrollViewListWeb.contentOffset = listPoint;
                } completion:^(BOOL finished) {
                    
                }];
                return;
            }
        }

        if (_selectAtIndex+1<[_arrayWebPage count]) {
            UIViewTaskPage *nextTaskView = [_arrayWebPage objectAtIndex:_selectAtIndex+1];
            CGRect rect = [_scrollViewListWeb convertRect:nextTaskView.frame toView:self];
            BOOL isInNextTaskView = CGRectContainsPoint(rect, point);
            if (isInNextTaskView) {
                [UIView animateWithDuration:0.22 animations:^{
                    CGPoint listPoint = _scrollViewListWeb.contentOffset;
                    listPoint.x += _scrollViewListWeb.bounds.size.width;
                    _scrollViewListWeb.contentOffset = listPoint;
                } completion:^(BOOL finished) {
                }];
            }
        }
    }
}

- (void)scrollViewSubViewsRemoved
{
    [self.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if([obj isKindOfClass:[UIScrollView class]]){
            //删除掉
            [obj.subviews enumerateObjectsUsingBlock:^(UIView *om, NSUInteger idx, BOOL *stop) {
                [om removeFromSuperview];
            }];
        }
        
    }];
}

- (void)viewBackToBrowserForCurrentView:(UIViewTaskPage *)currentTaskView
{
    [UIView animateWithDuration:0.22 animations:^{
        CGPoint center = CGPointZero;
        if (_selectAtIndex-1>=0) {
            UIViewTaskPage *lastWebPage = _arrayWebPage[_selectAtIndex-1];
            center = lastWebPage.center;
            center.x = center.x - lastWebPage.bounds.size.width;
            lastWebPage.center = center;
        }
        if (_selectAtIndex+1<[_arrayWebPage count]) {
            UIViewTaskPage *nextWebPage = _arrayWebPage[_selectAtIndex+1];
            center = nextWebPage.center;
            center.x = center.x + nextWebPage.bounds.size.width;
            nextWebPage.center = center;
        }
    } completion:^(BOOL finished) {
        
    }];
    CGPoint point = [_scrollViewListWeb convertPoint:currentTaskView.center toView:self];
    CGPoint currentPoint = [self convertPoint:point toView:self.superview];
    currentTaskView.center = currentPoint;
    [self.superview insertSubview:currentTaskView aboveSubview:_scrollViewListWeb];
    [UIView animateWithDuration:0.2 animations:^{
        [self setAlphaZeroForSubviews];
        CGPoint point = currentTaskView.center;
        point.y += _heightSpace;
        currentTaskView.center = point;
        
        [currentTaskView.imgvIcon removeFromSuperview];
        [currentTaskView.forntGrayView removeFromSuperview];
        [currentTaskView.labTitle removeFromSuperview];
        [currentTaskView setTransform:CGAffineTransformIdentity];
        [currentTaskView.gestureRecognizers enumerateObjectsUsingBlock:^(UIGestureRecognizer *obj, NSUInteger idx, BOOL *stop) {
            [currentTaskView removeGestureRecognizer:obj];
        }];
    } completion:^(BOOL finished) {
        if ([_delegate respondsToSelector:@selector(viewTaskManage:didTaskViewSelected:)]) {
            [_delegate viewTaskManage:self didTaskViewSelected:_selectAtIndex];
        }
        [currentTaskView removeFromSuperview];
        [self removeFromSuperview];
        [_taskManagePages currentSelectIndexForSet:_selectAtIndex];
        [[[UITaskPageManage sharedManage] nowArrayTask] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
            obj.transform = CGAffineTransformIdentity;
            [obj removeFromSuperview];
        }];
    }];
}

- (void)viewBackToHomeWith:(void (^)(UIView *, NSInteger))currentTaskView completion:(void (^)(void))completion
{
    [self setAlphaZeroForSubviews];
    [_taskManagePages currentSelectIndexForSet:-1];
    UIViewTaskPage *webPage = _arrayWebPage[_selectAtIndex];
    CGPoint point = [_scrollViewListWeb convertPoint:webPage.center toView:self];
    point.y += _heightSpace;
    webPage.center = point;
    [self.superview insertSubview:webPage aboveSubview:_scrollViewListWeb];
    
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint center = CGPointZero;
        if (_selectAtIndex-1>=0) {
            UIViewTaskPage *lastWebPage = _arrayWebPage[_selectAtIndex-1];
            center = lastWebPage.center;
            center.x = center.x - lastWebPage.bounds.size.width;
            lastWebPage.center = center;
        }
        if (_selectAtIndex+1<[_arrayWebPage count]) {
            UIViewTaskPage *nextWebPage = _arrayWebPage[_selectAtIndex+1];
            center = nextWebPage.center;
            center.x = center.x + nextWebPage.bounds.size.width;
            nextWebPage.center = center;
        }
        //回调
        currentTaskView(webPage,_selectAtIndex);
        _isDismiss = YES;
        
    } completion:^(BOOL finished) {
        [self setAlpha:0.];
        if (completion) completion();
        
        [UIView animateWithDuration:0.1 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _controlPageView.center = CGPointMake(self.center.x, self.bounds.size.height-22);
            _scrollViewHelp.contentSize =
            _scrollViewListWeb.contentSize = CGSizeZero;
            _scrollViewHelp.contentOffset =
            _scrollViewListWeb.contentOffset = CGPointZero;
            
        } completion:^(BOOL finished) {
            [_arrayWebPage removeObjectAtIndex:_selectAtIndex];
            [[UITaskPageManage sharedManage] removeTaskViewAtIndex:_selectAtIndex];
            [self scrollViewSubViewsRemoved];
            [[[UITaskPageManage sharedManage] nowArrayTask] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
                obj.transform = CGAffineTransformIdentity;
                [obj removeFromSuperview];
            }];
            
        }];
    }];
}

#pragma mark - UIWebPageDelegate
- (void)webPagePanBegin:(UIViewTaskPage *)pageWeb withDirectionX:(BOOL)isDirection
{
    if (!isDirection) {
        [UIView animateWithDuration:0.1 animations:^{
            _btnShare.alpha = 0.;
        }];
    }
}

- (void)webPagePanEnd:(UIViewTaskPage *)pageWeb withDirectionX:(BOOL)isDirection
{    if (!isDirection) {
        [UIView animateWithDuration:0.22 animations:^{
            _btnShare.alpha = 1.;
        }];
    }
}

- (void)webPageRemoved:(UIViewTaskPage *)pageWeb
{
    _isRemoved = YES;
    if ([_arrayWebPage containsObject:pageWeb]) {
        NSInteger idx = [_arrayWebPage indexOfObject:pageWeb];
        if (_arrayWebPage.count == 1) {
            if ([_delegate respondsToSelector:@selector(viewTaskManageEmpty:isAfterOfAnimate:)]) {
                [_delegate viewTaskManageEmpty:self isAfterOfAnimate:NO];
            }
            if ([_delegate respondsToSelector:@selector(viewTaskManageDidRemoved:atIndex:)]) {
                [_delegate viewTaskManageDidRemoved:self atIndex:idx];
            }
            [self removePartSubviews];
            [self setAlphaZeroForSubviews];
            [self removeFromSuperview];
            return;
        }
        
        [UIView animateWithDuration:0.22 animations:^{
            
            for (NSInteger i = [_arrayWebPage count]-1; i>idx; i--) {
                UIViewTaskPage *pageWebNow = [_arrayWebPage objectAtIndex:i];
                UIViewTaskPage *pageWebLast = [_arrayWebPage objectAtIndex:i-1];
                pageWebNow.center = pageWebLast.center;
            }

            CGPoint point = _scrollViewListWeb.contentOffset;
            point.x -= _scrollViewListWeb.bounds.size.width;
            _scrollViewListWeb.contentOffset =point;
            
            CGSize size = _scrollViewListWeb.contentSize;
            size.width -= _scrollViewListWeb.bounds.size.width;
            _scrollViewListWeb.contentSize = size;
            
            CGPoint pointHelp = _scrollViewHelp.contentOffset;
            pointHelp.x -= _scrollViewHelp.bounds.size.width;
            _scrollViewHelp.contentOffset = pointHelp;
            
            CGSize sizeHelp = _scrollViewHelp.contentSize;
            sizeHelp.width -= _scrollViewHelp.bounds.size.width;
            _scrollViewHelp.contentSize = sizeHelp;
            
            _btnShare.alpha = 0.;
        } completion:^(BOOL finished) {
            _btnShare.alpha = 1;
            [_arrayWebPage removeObject:pageWeb];
            //从单例类删除
            [[UITaskPageManage sharedManage] removeTaskView:pageWeb];
            _controlPageView.numberOfPages = [_arrayWebPage count];
            _isRemoved = NO;
            
            if (finished) {
                if ([_delegate respondsToSelector:@selector(viewTaskManageDidRemoved:atIndex:)]) {
                    [_delegate viewTaskManageDidRemoved:self atIndex:idx];
                }
            }
        }];
    }
}

#pragma mark - Events

- (void)onTouchWithItems:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(viewTaskManage:didSelectShareButton:ofCurrentWebIndex:)]) {
        [_delegate viewTaskManage:self didSelectShareButton:sender.tag ofCurrentWebIndex:_selectAtIndex];
    }
    [self animationDidEndWithCompletion:^{
        
    }];
}

- (void)onTouchWithShare:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
    if (sender.selected) {
        [self animationWillBegin];
    }
    else
    {
        [self animationDidEndWithCompletion:^{
            
        }];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [UIView animateWithDuration:0.22 animations:^{
            _btnShare.alpha = 1.;
        }];
        [self scroll:scrollView toAnimated:YES completion:nil];
    }
    else {
        [self scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.1 animations:^{
        _btnShare.alpha = 0.;
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:_isDismiss?0.1:0.22 animations:^{
        _btnShare.alpha = _isDismiss?0.:1.;
    }];
    [_taskManagePages currentSelectIndexForSet:_selectAtIndex];
    [self scroll:scrollView toAnimated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat f = floor((scrollView.contentOffset.x - scrollView.bounds.size.width/2)/scrollView.bounds.size.width)+1;
    
    if (f<0) {
        f = 0;
    }
    if (f>=[_arrayWebPage count]) {
        f = [_arrayWebPage count]-1;
    }
    _controlPageView.currentPage = f;
    _selectAtIndex = f;
    
    if (_isRemoved) {
        return;
    }
    float bigX = _scrollViewHelp.bounds.size.width/_scrollViewListWeb.bounds.size.width;
    float littleX = _scrollViewListWeb.bounds.size.width/_scrollViewHelp.bounds.size.width;
    if (scrollView == _scrollViewHelp) {
        _scrollViewListWeb.delegate = nil;
        [_scrollViewListWeb setContentOffset:CGPointMake(_scrollViewHelp.contentOffset.x*littleX, 0)];
        _scrollViewListWeb.delegate = self;
    }
    else
    {
        _scrollViewHelp.delegate = nil;
        [_scrollViewHelp setContentOffset:CGPointMake(_scrollViewListWeb.contentOffset.x*bigX, 0)];
        _scrollViewHelp.delegate = self;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
