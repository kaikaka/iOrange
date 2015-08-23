//
//  CellForHistory.m
//  iOrange
//
//  Created by Yoon on 8/23/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import "CellForHistory.h"
#import "UIImageView+WebCache.h"

@implementation CellForHistory

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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self setup];
  }
  return self;
}

#pragma mark - private methods 

- (void)setup {
  CGFloat fw = 25.;
  
  UIImageView *imageShow = [[UIImageView alloc] initWithFrame:CGRectMake(17, (self.height - fw)/2,fw,fw)];
  [imageShow setImage:[UIImage imageNamed:@"home_setting_history_default@2x"]];
  [self addSubview:imageShow];
  _imgvDefault = imageShow;
  
  UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(imageShow.right+13, 3, self.width - 100, self.height/2.)];
  [labelTitle setFont:Font_Size(14.)];
  [labelTitle setLineBreakMode:NSLineBreakByTruncatingTail];
  [labelTitle setBackgroundColor:[UIColor clearColor]];
  [self addSubview:labelTitle];
  _labelLinkTitle = labelTitle;
  
  UILabel *labelLink = [[UILabel alloc] initWithFrame:CGRectMake(imageShow.right+13, labelTitle.height, self.width - 50, self.height/2.)];
  [labelLink setFont:Font_Size(12.)];
  [labelLink setLineBreakMode:NSLineBreakByTruncatingTail];
  [labelLink setBackgroundColor:[UIColor clearColor]];
  [labelLink setTextColor:[UIColor grayColor]];
  [self addSubview:labelLink];
  _labelLinkLink = labelLink;
  
  UIButton *btnNext = [UIButton buttonWithType:0];
  [btnNext setFrame:CGRectMake(self.width - 40, (self.height-fw)/2., fw-3, fw)];
  [btnNext setImage:[UIImage imageNamed:@"home_setting_history_addbookmakr@2x"]forState:0];
  [btnNext setImage:[UIImage imageNamed:@"home_setting_history_bookmark@2x"] forState:UIControlStateSelected];
  [btnNext setTranslatesAutoresizingMaskIntoConstraints:NO];
  [btnNext setBackgroundColor:[UIColor clearColor]];
  [btnNext addTarget:self action:@selector(onTouchAtSelect:) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:btnNext];
  _btnRight = btnNext;
  
  {
    NSLayoutConstraint *leftCon = [NSLayoutConstraint constraintWithItem:btnNext attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1. constant:-15];
    NSLayoutConstraint *topCon = [NSLayoutConstraint constraintWithItem:btnNext attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1. constant:(self.height-fw)/2.];
    NSLayoutConstraint *widthCon = [NSLayoutConstraint constraintWithItem:btnNext attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:(fw-3)/self.width constant:0];
    NSLayoutConstraint *heightCon = [NSLayoutConstraint constraintWithItem:btnNext attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:fw/self.height constant:0];
    
    [self addConstraints:@[leftCon,heightCon,widthCon,topCon]];
  }
}

- (void)setIconAtUrl:(NSString *)urlLink {
  NSURL *url = [NSURL URLWithString:urlLink];
  NSString *icoLink = [NSString stringWithFormat:@"http://%@/favicon.ico", url.host];
  [_imgvDefault sd_setImageWithURL:[NSURL URLWithString:icoLink] placeholderImage:[UIImage imageNamed:@"home_setting_history_default@2x"]];
}
- (void)onTouchAtSelect:(UIButton *)sender {
  sender.selected = !sender.selected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
