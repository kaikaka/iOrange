//
//  ViewHomeSection.m
//  iOrange
//
//  Created by XiangKai Yin on 5/23/15.
//  Copyright (c) 2015 yinxiangkai. All rights reserved.
//

#import "ViewHomeSection.h"

@interface ViewHomeSection() {
}
@property (nonatomic,assign) CGPoint isMarkCenter;

@end

@implementation ViewHomeSection

@synthesize labelDetail = _labelDetail,imgvMark = _imgvMark,isMarkDown = _isMarkDown,isMarkCenter = _isMarkCenter;

- (id)initWithFrame:(CGRect)frame
      withImageName:(NSString *)imageName
      withLableName:(NSString *)cateName{
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = CLEARCOLOR;
    CGFloat margin = 25.;
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(20, (CGRectGetHeight(self.frame)-margin)/2, margin, margin)];
    [imgv setImage:[UIImage imageNamed:imageName]];
    [self addSubview:imgv];
    
    UILabel *lableName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgv.frame)+20, (CGRectGetHeight(self.frame)-margin)/2, 100, margin)];
    [lableName setText:cateName];
    [lableName setBackgroundColor:[UIColor clearColor]];
    [lableName setTextAlignment:NSTextAlignmentLeft];
    [lableName setFont:[UIFont systemFontOfSize:16.]];
    [self addSubview:lableName];
    
    UIImageView *imgvRight = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-35, (CGRectGetHeight(self.frame)-18)/2, 10., 16.)];
    [imgvRight setImage:[UIImage imageNamed:@"home_webSite_right"]];
    [self addSubview:imgvRight];
    _imgvMark = imgvRight;
    _isMarkCenter = imgvRight.center;

    UILabel *labelDet = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(imgvRight.frame) -135, (CGRectGetHeight(self.frame)-margin)/2, 100, margin)];
    [labelDet setBackgroundColor:[UIColor clearColor]];
    [labelDet setTextAlignment:NSTextAlignmentRight];
    [labelDet setFont:Font_Size(12.)];
    [self addSubview:labelDet];
    _labelDetail = labelDet;
    
    UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame)-1, CGRectGetWidth(frame), 1)];
    [labelLine setBackgroundColor:RGBA(182., 182., 182., 1.)];
    [self addSubview:labelLine];
  }
  return self;
}

#pragma mark - private methods

- (void)setIsMarkDown:(BOOL)isMarkDown {
  _isMarkDown = isMarkDown;
  if (isMarkDown) {
    [_imgvMark setImage:[UIImage imageNamed:@"home_webSite_down"]];
    CGRect rect = _imgvMark.frame;
    rect.size = CGSizeMake(CGRectGetHeight(_imgvMark.frame), CGRectGetWidth(_imgvMark.frame));
    _imgvMark.frame = rect;
    _imgvMark.center = _isMarkCenter;
  } else {
    [_imgvMark setImage:[UIImage imageNamed:@"home_webSite_right"]];
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
