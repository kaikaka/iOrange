//
//  SlurImageView.m
//  iOrange
//
//  Created by XiangKai Yin on 7/1/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import "SlurImageView.h"

@interface SlurImageView ()
@property (nonatomic, strong) UINavigationBar *slurNavigationbar;
@end

@implementation SlurImageView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    
    [self setup];
    
  }
  return self;
}

-(void)awakeFromNib {
  [self setup];
}

- (void)setup {
  // If we don't clip to bounds the toolbar draws a thin shadow on top
  [self setClipsToBounds:YES];
  
  if (!self.slurNavigationbar) {
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:[self bounds]];
    self.slurNavigationbar = navigationBar;
    [self.layer insertSublayer:self.slurNavigationbar.layer atIndex:0];
  }
}


- (void)layoutSubviews {
  [super layoutSubviews];
  
  [self.slurNavigationbar setFrame:[self bounds]];
}


@end
