//
//  ViewCellControl.h
//  iOrange
//
//  Created by XiangKai Yin on 6/9/15.
//  Copyright (c) 2015 yinxiangkai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewCellControl : UIView

@property (nonatomic,strong) NSArray *arraySite;
@property (nonatomic,strong) void (^touched) (NSString *);

@end
