//
//  ViewGuideSiteButton.h
//  iOrange
//
//  Created by XiangKai Yin on 5/26/15.
//  Copyright (c) 2015 yinxiangkai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewGuideSiteButton : UIView

@property (nonatomic,strong) void (^touched) (NSString *webLink);

- (id)initWithFrame:(CGRect)frame withIconName:(NSString *)imgName withSiteName:(NSString *)siteName;

- (id)initWithFrame:(CGRect)frame withDict:(id)theSite;

@end
