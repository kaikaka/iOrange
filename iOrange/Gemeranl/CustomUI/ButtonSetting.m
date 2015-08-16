//
//  ButtonSetting.m
//  iOrange
//
//  Created by Yoon on 8/15/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import "ButtonSetting.h"

@implementation ButtonSetting


- (void)setHighlighted:(BOOL)highlighted {
  [super setHighlighted:highlighted];
  if (highlighted) {
    self.superview.backgroundColor = RGBA(190., 190., 190., 1.);
  }else{
    self.superview.backgroundColor = [UIColor clearColor];
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
