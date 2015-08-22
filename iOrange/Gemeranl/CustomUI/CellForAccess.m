//
//  CellForAccess.m
//  iOrange
//
//  Created by Yoon on 8/22/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import "CellForAccess.h"
@interface CellForAccess () {
  UILabel *_labelBottonLine;
  UILabel *_labelLinkTitle;
  UIImageView *_imgvDefault;
  UIImageView *_imgvRight;
}

@end

@implementation CellForAccess

- (void)awakeFromNib {
    // Initialization code
  [self setup];
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setup];
  }
  return self;
}

#pragma mark - public methods 

- (void)setLabelHidden:(BOOL)ishidden {
  _labelBottonLine.hidden = ishidden;
}

- (void)setTitleString:(NSString *)titleString {
  [_labelLinkTitle setText:titleString];
}

- (void)setImgvHidden:(BOOL)isHidden {
  _labelBottonLine.hidden = isHidden;
  _imgvRight.hidden = isHidden;
  _imgvDefault.hidden = isHidden;
}

#pragma mark - private methods

- (void)setup {
  [self setBackgroundColor:RGBA(207., 207., 207.,.6)];
  
  CGFloat fw = 30.;
  
  UIImageView *imageShow = [[UIImageView alloc] initWithFrame:CGRectMake(17, (self.height - fw)/2,fw,fw)];
  [imageShow setImage:[UIImage imageNamed:@"home_image_often@2x"]];
  [self addSubview:imageShow];
  _imgvDefault = imageShow;
  
  UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(imageShow.right+20, imageShow.top, self.width - 100, fw)];
  [labelTitle setFont:Font_Size(15.)];
  [labelTitle setLineBreakMode:NSLineBreakByTruncatingTail];
  [labelTitle setBackgroundColor:[UIColor clearColor]];
  [self addSubview:labelTitle];
  _labelLinkTitle = labelTitle;
  
  UIImageView *imageNext = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 30, imageShow.top+5, 20, 20)];
  [imageNext setImage:[UIImage imageNamed:@"home_setting_next"]];
  [imageNext setTranslatesAutoresizingMaskIntoConstraints:NO];
  [imageNext setBackgroundColor:[UIColor clearColor]];
  [self addSubview:imageNext];
  _imgvRight = imageNext;
  
  {
    NSLayoutConstraint *leftCon = [NSLayoutConstraint constraintWithItem:imageNext attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1. constant:-20];
    NSLayoutConstraint *topCon = [NSLayoutConstraint constraintWithItem:imageNext attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1. constant:imageShow.top+5];
    NSLayoutConstraint *widthCon = [NSLayoutConstraint constraintWithItem:imageNext attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:15./self.width constant:0];
    //multiplier 相对于toItem的宽度多比例
    //constant ???
    NSLayoutConstraint *heightCon = [NSLayoutConstraint constraintWithItem:imageNext attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:labelTitle attribute:NSLayoutAttributeHeight multiplier:20./30 constant:0];
    
    [self addConstraints:@[leftCon,heightCon,widthCon,topCon]];
  }
  
  UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height-1, self.width, 1)];
  [labelLine setBackgroundColor:RGBA(182., 182., 182., 0.6)];
  [self addSubview:labelLine];
  [labelLine setTranslatesAutoresizingMaskIntoConstraints:NO];
  _labelBottonLine = labelLine;
  
  {
    NSLayoutConstraint *leftCon = [NSLayoutConstraint constraintWithItem:labelLine attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1. constant:0];
    NSLayoutConstraint *bottomCon = [NSLayoutConstraint constraintWithItem:labelLine attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1. constant:0.];
    NSLayoutConstraint *rightCon = [NSLayoutConstraint constraintWithItem:labelLine attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1. constant:0];
    NSLayoutConstraint *topCon = [NSLayoutConstraint constraintWithItem:labelLine attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1. constant:self.height - 1];
    [self addConstraints:@[leftCon,bottomCon,rightCon,topCon]];
  }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
