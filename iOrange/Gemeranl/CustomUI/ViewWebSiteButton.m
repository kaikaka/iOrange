//
//  ViewWebSiteButton.m
//  iOrange
//
//  Created by XiangKai Yin on 5/20/15.
//  Copyright (c) 2015 yinxiangkai. All rights reserved.
//

#import "ViewWebSiteButton.h"

@implementation ViewWebSiteButton

- (id)initWithFrame:(CGRect)frame WithImgName:(NSString *)imgName {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = RGBA(234., 234., 234., 1.);
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0;
    
    UIImage *image = [UIImage imageNamed:imgName];
    UIButton *buttonImg = [UIButton buttonWithType:0];
    [buttonImg setFrame:CGRectMake((CGRectGetWidth(frame) - image.size.width/2)/2,
                                   (CGRectGetHeight(frame) - image.size.height/2)/2,
                                   image.size.width/2, image.size.height/2)];
    [buttonImg setImage:image forState:0];
    [self addSubview:buttonImg];
  }
  return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
