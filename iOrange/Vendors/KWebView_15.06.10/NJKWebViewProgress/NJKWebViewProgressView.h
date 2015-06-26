//
//  NJKWebViewProgressView.h
// iOS 7 Style WebView Progress Bar
//
//  Created by Satoshi Aasano on 11/16/13.
//  Copyright (c) 2013 Satoshi Asano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NJKWebViewProgressView : UIView

@property (nonatomic) float progress;

@property (nonatomic) UIView *progressBarView; 
@property (nonatomic) NSTimeInterval fadeAnimationDuration;
@property (nonatomic) NSTimeInterval fadeOutDelay; 

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
