//
//  ViewGuideSiteButton.m
//  iOrange
//
//  Created by XiangKai Yin on 5/26/15.
//  Copyright (c) 2015 yinxiangkai. All rights reserved.
//

#import "ViewGuideSiteButton.h"

@implementation ViewGuideSiteButton

- (id)initWithFrame:(CGRect)frame withIconName:(NSString *)imgName withSiteName:(NSString *)siteName {
  self = [super initWithFrame:frame];
  if (self) {
    UIButton *buttomImg = [UIButton buttonWithType:0];
    buttomImg.frame = CGRectMake(0, 0, 62, 62);
    [buttomImg setImage:[UIImage imageNamed:imgName] forState:0];
    [self addSubview:buttomImg];
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(buttomImg.frame), self.width, 28)];
    [labelTitle setText:siteName];
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    [labelTitle setFont:Font_Size(13.)];
    [self addSubview:labelTitle];
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
