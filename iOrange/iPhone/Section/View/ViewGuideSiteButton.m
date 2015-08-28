//
//  ViewGuideSiteButton.m
//  iOrange
//
//  Created by XiangKai Yin on 5/26/15.
//  Copyright (c) 2015 yinxiangkai. All rights reserved.
//

#import "ModelSite.h"
#import "UIButton+WebCache.h"
#import "ViewGuideSiteButton.h"

@interface ViewGuideSiteButton () {
  NSDictionary *_dictConent;
  NSString  *_stringContent;
}

@end

@implementation ViewGuideSiteButton

- (id)initWithFrame:(CGRect)frame withIconName:(NSString *)imgName withSiteName:(NSString *)siteName {
  self = [super initWithFrame:frame];
  if (self) {
    UIButton *buttomImg = [UIButton buttonWithType:0];
    buttomImg.frame = CGRectMake(0, 0, 62, 62);
    [buttomImg setImage:[UIImage imageNamed:imgName] forState:0];
    [self addSubview:buttomImg];
    [buttomImg addTarget:self action:@selector(onTouchWithSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(buttomImg.frame), self.width, 28)];
    [labelTitle setText:siteName];
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    [labelTitle setFont:Font_Size(13.)];
    [self addSubview:labelTitle];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame withDict:(id)theSite {
  self = [super initWithFrame:frame];
  if (self) {
    _dictConent = theSite;
    
    NSString *nameString; NSString *iconString;
    
    UIButton *buttomImg = [UIButton buttonWithType:0];
    buttomImg.frame = CGRectMake(0, 0, 62, 62);
    [self addSubview:buttomImg];
    [buttomImg addTarget:self action:@selector(onTouchWithSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([theSite isKindOfClass:[NSDictionary class]]) {
      NSDictionary *siteDict = (NSDictionary *)theSite;
      _stringContent = [siteDict objectForKey:@"sLink"];
      iconString = [siteDict objectForKey:@"sIcon"];
      nameString = [siteDict objectForKey:@"sTitle"];
      [buttomImg setImage:[UIImage imageNamed:iconString] forState:0];
    } else if ([theSite isKindOfClass:[ModelSite class]]) {
      ModelSite *siteModel = (ModelSite *)theSite;
      _stringContent = siteModel.s_link;
      iconString = siteModel.s_icon;
      nameString = siteModel.s_title;
      [buttomImg sd_setBackgroundImageWithURL:[NSURL URLWithString:iconString] forState:0];
    }
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(buttomImg.frame), self.width, 28)];
    [labelTitle setText:nameString];
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    [labelTitle setFont:Font_Size(13.)];
    [self addSubview:labelTitle];
  }
  return self;
}

- (void)onTouchWithSelect:(UIButton *)sender {
  if (_dictConent) {
    if (_touched) {
      _touched(_stringContent);
    }
  } else {
    if (_touched) {
      _touched(@"");
    }
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
