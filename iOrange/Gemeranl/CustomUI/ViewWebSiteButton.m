//
//  ViewWebSiteButton.m
//  iOrange
//
//  Created by XiangKai Yin on 5/20/15.
//  Copyright (c) 2015 yinxiangkai. All rights reserved.
//

#import "ViewWebSiteButton.h"

@interface ViewWebSiteButton () {
  NSDictionary *_dictConent;
}

@end

@implementation ViewWebSiteButton

- (id)initWithFrame:(CGRect)frame WithImgDict:(NSDictionary *)imgDict {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = RGBA(234., 234., 234., 1.);
    _dictConent = imgDict;
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0;
    
    NSString *imgName = [imgDict objectForKey:@"icon"];
    UIImage *img = [UIImage imageNamed:imgName];
    UIButton *buttonImg = [UIButton buttonWithType:1];
    [buttonImg setFrame:self.bounds];
    [self addSubview:buttonImg];
    [buttonImg addTarget:self action:@selector(onTouchWithSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:
                          CGRectMake((CGRectGetWidth(frame) - img.size.width/2)/2,
                                     (CGRectGetHeight(frame) - img.size.height/2)/2,
                                     img.size.width/2, img.size.height/2)];
    [image setImage:img];
    [buttonImg addSubview:image];
  }
  return self;

}

- (void)onTouchWithSelect:(UIButton *)sender {
  NSString *link = [_dictConent objectForKey:@"link"];
  
  if (_touched) {
    _touched(link);
  }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
