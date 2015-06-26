//
//  ViewWebSiteButton.h
//  iOrange
//
//  Created by XiangKai Yin on 5/20/15.
//  Copyright (c) 2015 yinxiangkai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewWebSiteButton : UIView

@property (nonatomic,strong) void (^touched) (NSString *webLink);

- (id)initWithFrame:(CGRect)frame WithImgDict:(NSDictionary *)imgDict;

@end
