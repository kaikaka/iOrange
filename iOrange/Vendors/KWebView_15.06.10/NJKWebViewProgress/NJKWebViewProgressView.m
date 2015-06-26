//
//  NJKWebViewProgressView.m
//
//  Created by Satoshi Aasanoon 11/16/13.
//  Copyright (c) 2013 Satoshi Asano. All rights reserved.
//

#import "NJKWebViewProgressView.h"

@implementation NJKWebViewProgressView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configureViews];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self configureViews];
}

-(void)configureViews {
    self.userInteractionEnabled = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _progressBarView = [[UIView alloc] initWithFrame:self.bounds];
    _progressBarView.alpha = 0;
    _progressBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
  _progressBarView.backgroundColor = [UIColor colorWithRed:22.f/255.f green:126.f/255.f blue:251.f/255. alpha:1.];
    [self addSubview:_progressBarView];
    
    _fadeAnimationDuration = 0.5f;
    _fadeOutDelay = 0.3f;
}

-(void)setProgress:(float)progress {
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    BOOL isGrowing = (progress > 0.0);
    CGFloat duration = ((isGrowing&&animated)?_fadeAnimationDuration:0.0);
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = _progressBarView.frame;
        frame.size.width = progress*self.bounds.size.width;
        _progressBarView.frame = frame;
    }];
    
    duration = (animated?_fadeAnimationDuration:0.0);
    [UIView animateWithDuration:duration animations:^{
        _progressBarView.alpha = fminf(1.0, progress+0.38);
    } completion:^(BOOL finished) {
        if (progress >= 1.0) {
            [UIView animateWithDuration:duration delay:_fadeOutDelay options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _progressBarView.alpha = 0.0;
            } completion:^(BOOL completed){
                CGRect frame = _progressBarView.frame;
                frame.size.width = 0;
                _progressBarView.frame = frame;
            }];
        }
    }];
}

@end
