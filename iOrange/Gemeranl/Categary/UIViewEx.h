//
//  UIView+EX.h
//
//  Created by Glex on 13-7-19.
//  Copyright (c) 2013年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIViewEx)

@property (nonatomic, weak) id userData;

@property (nonatomic, assign, readonly) CGFloat left;
@property (nonatomic, assign, readonly) CGFloat right;
@property (nonatomic, assign, readonly) CGFloat top;
@property (nonatomic, assign, readonly) CGFloat bottom;

@property (nonatomic, assign, readonly) CGFloat width;
@property (nonatomic, assign, readonly) CGFloat height;

/**
 *  可能为nil
 */
@property (nonatomic, weak, readonly) UIImageView *bgImageView;

/**
 *  设置背景，创建一个图片控件 bgImageView，[image stretch];
 *
 *  @param image
 */
- (void)setBgImageWithStretchImage:(UIImage *)image;

/**
 *  设置背景，创建一个图片控件 bgImageView，bgImageView.viewContentMode = ScaleAspectFill
 *
 *  @param image
 */
- (void)setBgImageWithScaleAspectFillImage:(UIImage *)image;

/**
 *  使用图片pattern模式 设置背景颜色
 *
 *  @param image
 */
- (void)setBgColorWithImage:(UIImage *)image;

/**
 *  递归设置子视图的背景颜色(随机颜色)，通常在用测试时使用
 */
- (void)setSubViewBgColor;

/**
 *  让当前view产生一个两倍的放大效果
 *
 *  @param view  要放大的view
 *  @param image 背景图片 不可为空
 */
- (void)setTwoBigNiceAnimate:(UIView *)view  image:(UIImage *)image completion:(void(^)(BOOL finished))completion;

@end
