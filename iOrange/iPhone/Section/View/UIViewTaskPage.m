//
//  UIViewTaskPage.m
//  Browser-Touch
//
//  Created by xiangkai yin on 14-8-19.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewTaskPage.h"

@interface UIViewTaskPage()<UIWebViewDelegate,UIGestureRecognizerDelegate>
{
    UIPanGestureRecognizer *_panWebGesture;
    UIView                 *_viewTransformRotate;
    UIView                 *_viewTransformScale;
}
@end
@implementation UIViewTaskPage
@synthesize imgvIcon = _imgvIcon,labTitle = _labTitle;
@synthesize webViewPage = _webViewPage,forntGrayView = _forntGrayView;
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
    [self awakeFromNib];
}

#pragma mark - public methods

#pragma mark - private methods

- (void)setBegin
{
    //三个view 一个用来旋转(Rotate) 一个用来变换大小(Scale) 当前self 负责移动
    if (!_viewTransformRotate) {
        _viewTransformRotate = [[UIView alloc] initWithFrame:self.bounds];
        _viewTransformRotate.backgroundColor = [UIColor clearColor];
        _viewTransformRotate.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self addSubview:_viewTransformRotate];
    }
    if (!_viewTransformScale) {
        _viewTransformScale = [[UIView alloc] initWithFrame:self.bounds];
        _viewTransformScale.backgroundColor = [UIColor clearColor];
        _viewTransformScale.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [_viewTransformRotate addSubview:_viewTransformScale];
    }
    if (!_webViewPage) {
        _webViewPage = [[UIView alloc] initWithFrame:self.bounds];
        _webViewPage.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _webViewPage.backgroundColor = [UIColor whiteColor];
        [_viewTransformScale addSubview:_webViewPage];
    }
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    if (!_forntGrayView) {
        UIView *webFrontView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _viewTransformScale.bounds.size.width, _viewTransformScale.bounds.size.height)];
        webFrontView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.5];
        webFrontView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        webFrontView.transform = CGAffineTransformIdentity;
        [_viewTransformScale addSubview:webFrontView];
        _forntGrayView = webFrontView;
    }
    
    CGRect rect = _viewTransformScale.frame;
    rect.origin.x = 5;
    rect.origin.y = rect.size.height+5;
    rect.size.width = 20;
    rect.size.height = 20;
    UIImageView *imgvLeft = [[UIImageView alloc] initWithFrame:rect];
    _imgvIcon = imgvLeft;
    [_forntGrayView addSubview:imgvLeft];
    
    rect = imgvLeft.frame;
    rect.origin.x = 35;
    rect.size.width = 270;
    UILabel *labRight = [[UILabel alloc] initWithFrame:rect];
    [labRight setBackgroundColor:[UIColor clearColor]];
    [labRight setTextAlignment:NSTextAlignmentLeft];
    [labRight setTextColor:[UIColor whiteColor]];
    [labRight setFont:[UIFont systemFontOfSize:15.]];
    _labTitle = labRight;
    labRight.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_forntGrayView addSubview:labRight];
    
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    panGesture.delegate = self;
    _panWebGesture = panGesture;
    [self addGestureRecognizer:panGesture];
}

- (void)panGesture:(UIPanGestureRecognizer *)panGesture
{
    static BOOL isDirectionX = NO;
    static CGFloat beginF;
    CGAffineTransform transformOrigin = panGesture.view.transform;
    UIScrollView *superScrollView = (UIScrollView *)panGesture.view.superview;
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        CGPoint velocity = [panGesture velocityInView:panGesture.view];
        isDirectionX = fabs(velocity.x)>fabs(velocity.y);
        superScrollView.scrollEnabled = isDirectionX;
        beginF = [panGesture locationInView:panGesture.view].y;
        if ([_delegate respondsToSelector:@selector(webPagePanBegin:withDirectionX:)]) {
            [_delegate webPagePanBegin:self withDirectionX:isDirectionX];
        }
    }
    else if(panGesture.state == UIGestureRecognizerStateChanged)
    {
        if (!isDirectionX && transformOrigin.ty<=10) {
            CGFloat f = [panGesture locationInView:panGesture.view].y;
            CGAffineTransform translate = CGAffineTransformTranslate(transformOrigin,0,f-beginF);
            panGesture.view.transform = translate;
            
            if(transformOrigin.ty<0)
            {
                CATransform3D transform = CATransform3DIdentity;
                float distance = [[UIScreen mainScreen] bounds].size.height;
                float ratio    = 1;
                transform.m34 = - ratio / distance;
                float  angle = isPad?-translate.ty/6.:-translate.ty/3.;
                CATransform3D rotate = CATransform3DRotate(transform, angle * M_PI / 180.0f, 1.f,0.f,0.f);
                _viewTransformRotate.layer.transform = rotate;
                
                CGFloat scale = -translate.ty/900;
                _viewTransformScale.transform = CGAffineTransformMakeScale(1-scale, 1-scale);
                
            }
        }
    }
    else if(panGesture.state == UIGestureRecognizerStateEnded)
    {
        superScrollView.scrollEnabled = YES;
        CGFloat translate = panGesture.view.transform.ty;
        
        CGFloat panY = -self.bounds.size.height*0.4;
        if (translate >=10||translate >= panY) {
            [UIView animateWithDuration:0.2 animations:^{
                CGAffineTransform tf = transformOrigin;
                tf.ty = 0;
                panGesture.view.transform = tf;
                _viewTransformRotate.layer.transform = CATransform3DRotate(CATransform3DIdentity, (0) * M_PI / 180.0f, 1.f,0.f,0.f);
                _viewTransformScale.transform = CGAffineTransformMakeScale(1., 1.);
            } completion:^(BOOL finished) {
            }];
        }
        else if(translate < panY)
        {
            [UIView animateWithDuration:0.2 animations:^{
                CGAffineTransform scale = CGAffineTransformMake(0.6, 0., 0., 0.6, 0, 0);
                CGAffineTransform translate = CGAffineTransformMake(0.6, 0., 0., 0.6, 0, -self.bounds.size.height);
                _viewTransformScale.transform = scale;
                panGesture.view.transform = translate;
            } completion:^(BOOL finished) {
                if ([_delegate respondsToSelector:@selector(webPageRemoved:)]) {
                    [_delegate webPageRemoved:self];
                }
            }];
        }
        if ([_delegate respondsToSelector:@selector(webPagePanEnd:withDirectionX:)]) {
            [_delegate webPagePanEnd:self withDirectionX:isDirectionX];
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
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
