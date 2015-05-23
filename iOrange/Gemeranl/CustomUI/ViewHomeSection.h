//
//  ViewHomeSection.h
//  iOrange
//
//  Created by XiangKai Yin on 5/23/15.
//  Copyright (c) 2015 yinxiangkai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewHomeSection : UIView

@property (nonatomic,strong) UILabel *labelDetail;
@property (nonatomic,readonly) UIImageView *imgvMark;
@property (nonatomic,assign) BOOL isMarkDown;


- (id)initWithFrame:(CGRect)frame
      withImageName:(NSString *)imageName
      withLableName:(NSString *)cateName;


@end
