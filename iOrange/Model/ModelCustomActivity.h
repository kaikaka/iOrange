//
//  ModelCustomActivity.h
//  iOrange
//
//  Created by XiangKai Yin on 2018/11/12.
//  Copyright © 2018 yinxiangkai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ModelCustomActivity : UIActivity

@property (nonatomic) UIImage *shareImage;
@property (nonatomic, copy) NSString *URL;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray *shareContentArray;
-(instancetype)initWithImage:(UIImage *)shareImage atURL:(NSString *)URL atTitle:(NSString *)title atShareContentArray:(NSArray *)shareContentArray;

@end

NS_ASSUME_NONNULL_END
