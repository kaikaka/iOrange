//
//  ViewCellControl.m
//  iOrange
//
//  Created by XiangKai Yin on 6/9/15.
//  Copyright (c) 2015 yinxiangkai. All rights reserved.
//

#import "ViewCellControl.h"

@interface ViewCellControl () {
  UIButton *_buttonAo;
  UIButton *_buttonBo;
  UIButton *_buttonCo;
  UIButton *_buttonDo;
  
  NSDictionary *_dictAr;
  NSDictionary *_dictBr;
  NSDictionary *_dictCr;
  NSDictionary *_dictDr;
}

@end

@implementation ViewCellControl

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    CGFloat wid = frame.size.width;
    CGFloat hig = frame.size.height;
    
    CGFloat fontSite = 12.;
    
    UIButton *button1 = [UIButton buttonWithType:0];
    [button1 setFrame:CGRectMake(0, 0, wid/4, hig)];
    [button1 setBackgroundImage:[UIImage imageNamed:@"home_webSite_Line"] forState:0];
    [button1.titleLabel setFont:Font_Size(fontSite)];
    [self addSubview:button1];
    _buttonAo = button1;
    
    UIButton *button2 = [UIButton buttonWithType:0];
    [button2 setFrame:CGRectMake(wid/4, 0, wid/4, hig)];
    [button2 setBackgroundImage:[UIImage imageNamed:@"home_webSite_Line"] forState:0];
    [button2.titleLabel setFont:Font_Size(fontSite)];
    [self addSubview:button2];
    _buttonBo = button2;
    
    UIButton *button3 = [UIButton buttonWithType:0];
    [button3 setFrame:CGRectMake(wid/4*2, 0, wid/4, hig)];
    [button3 setBackgroundImage:[UIImage imageNamed:@"home_webSite_Line"] forState:0];
    [button3.titleLabel setFont:Font_Size(fontSite)];
    [self addSubview:button3];
    _buttonCo = button3;
    
    UIButton *button4 = [UIButton buttonWithType:0];
    [button4 setFrame:CGRectMake(wid/4*3, 0, wid/4, hig)];
    [button4 setBackgroundImage:[UIImage imageNamed:@"home_webSite_LightLine"] forState:0];
    [button4.titleLabel setFont:Font_Size(fontSite)];
    [self addSubview:button4];
    [button4 setTitleColor:RGBA(0., 0., 0., 0.5) forState:0];
    [button3 setTitleColor:RGBA(0., 0., 0., 0.5) forState:0];
    [button2 setTitleColor:RGBA(0., 0., 0., 0.5) forState:0];
    [button1 setTitleColor:RGBA(0., 0., 0., 0.5) forState:0];
    
    [button1 setTag:10];
    [button2 setTag:11];
    [button3 setTag:12];
    [button4 setTag:13];
    
    [button1 addTarget:self action:@selector(onTouchWithLink:) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(onTouchWithLink:) forControlEvents:UIControlEventTouchUpInside];
    [button3 addTarget:self action:@selector(onTouchWithLink:) forControlEvents:UIControlEventTouchUpInside];
    [button4 addTarget:self action:@selector(onTouchWithLink:) forControlEvents:UIControlEventTouchUpInside];
    
    _buttonDo = button4;
  }
  return self;
}

- (void)setArraySite:(NSArray *)arraySite {
  _arraySite = arraySite;
  if (arraySite.count <=0) {
    return;
  }
  NSDictionary *dict1 = [arraySite objectAtIndex:0];
  if (dict1) {
    NSString *string = [dict1 objectForKey:@"title"];
    [_buttonAo setTitle:string forState:0];
    _dictAr = dict1;
  }
  
  if (arraySite.count<=1) {
    _buttonBo.hidden = YES;
    _buttonCo.hidden = YES;
    _buttonDo.hidden = YES;
    return;
  } else {
    _buttonBo.hidden = NO;
    _buttonCo.hidden = NO;
    _buttonDo.hidden = NO;
  }
  
  NSDictionary *dict2 = [arraySite objectAtIndex:1];
  if (dict2) {
    NSString *string = [dict2 objectForKey:@"title"];
    [_buttonBo setTitle:string forState:0];
    _dictBr = dict2;
  }
  if (arraySite.count<=2) {
    _buttonCo.hidden = YES;
    _buttonDo.hidden = YES;
    return;
  } else {
    _buttonCo.hidden = NO;
    _buttonDo.hidden = NO;
  }
  
  NSDictionary *dict3 = [arraySite objectAtIndex:2];
  if (dict3) {
    NSString *string = [dict3 objectForKey:@"title"];
    [_buttonCo setTitle:string forState:0];
    _dictCr = dict3;
  }
  if (arraySite.count<=3) {
    _buttonDo.hidden = YES;
    return;
  } else {
    _buttonDo.hidden = NO;
  }
  
  NSDictionary *dict4 = [arraySite objectAtIndex:3];
  if (dict4) {
    NSString *string = [dict4 objectForKey:@"title"];
    [_buttonDo setTitle:string forState:0];
    _dictDr = dict4;
  }
}

- (void)onTouchWithLink:(UIButton *)sender {
  switch (sender.tag) {
    case 10: {
      NSString *link = [_dictAr objectForKey:@"link"];
      DLog(@"link1 = %@",link);
    }
      break;
    case 11: {
      NSString *link = [_dictBr objectForKey:@"link"];
      DLog(@"link2 = %@",link);
    }
      break;
    case 12: {
      NSString *link = [_dictCr objectForKey:@"link"];
      DLog(@"link3 = %@",link);
    }
      break;
    case 13: {
      NSString *link = [_dictDr objectForKey:@"link"];
      DLog(@"link4 = %@",link);
    }
      break;
      
    default:
      break;
  }
}


@end
