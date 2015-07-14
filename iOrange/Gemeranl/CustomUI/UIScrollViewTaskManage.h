//
//  UIScrollViewTaskManage.h
//  iStollStore
//
//  Created by xiangkai yin on 14-7-31.
//  Copyright (c) 2014年 VeryApps. All rights reserved.
//
typedef enum : NSUInteger {
    TMShareButtonItemCopy = 10,
    TMShareButtonItemSMS,
    TMShareButtonItemEmail,
    TMShareButtonItemTwitter,
    TMShareButtonItemFaceBook
} TMShareButtonItem;

#define ThumbScale 0.65
#define ShowAnimationTime 0.4

#import <UIKit/UIKit.h>
#import "UIViewTaskPage.h"
#import "UITaskPageManage.h"
#import "UIWebPage.h"
#import "FilePathUtil.h"
#import "UIImage+Bundle.h"
#import "NSStringEx.h"

@class UIScrollViewTaskManage;
@protocol UIScrollViewTaskManageDelegate <NSObject>

/**
 *  空视图的回调
 *
 *  @param view UIScrollViewTaskManage
 */
- (void)viewTaskManageEmpty:(UIScrollViewTaskManage *)view isAfterOfAnimate:(BOOL)animation;

/**
 *  删除视图后的回调
 *
 *  @param view UIScrollViewTaskManage
 */
- (void)viewTaskManageDidRemoved:(UIScrollViewTaskManage *)view atIndex:(NSInteger)idx;

/**
 *  分享按钮的回调
 *
 *  @param view        self
 *  @param shareButton 按钮（10 短信; 11 邮件; 12 微信;13 朋友圈 ;14 新浪）
 */
- (void)viewTaskManage:(UIScrollViewTaskManage *)view didSelectShareButton:(TMShareButtonItem )shareTag ofCurrentWebIndex:(NSInteger)currentIdx;

/**
 *  单击view的回调
 *
 *  @param view         self
 *  @param selectedIdx selectedIdx
 */
- (void)viewTaskManage:(UIScrollViewTaskManage *)view didTaskViewSelected:(NSInteger)selectedIdx;

@end

@interface UIScrollViewTaskManage : UIView
@property (nonatomic,assign)id<UIScrollViewTaskManageDelegate> delegate;
/**
 *  添加view
 *
 *  @param view UIViewTaskPage
 */
- (void)addView:(UIView *)view;

/**
 *  插入到指定索引的位置
 *
 *  @param view  UIViewTaskPage
 *  @param index 索引
 */
- (void)insertView:(UIView *)view atIndex:(NSInteger)index;

/**
 *  删除视图
 *
 *  @param view UIViewTaskPage
 */
- (void)removeView:(UIView *)view;

/**
 *  显示视图
 *
 *  @param view view
 */
- (void)showInView:(UIView *)view completion:(void(^)(void))completion;

/**
 * 移除索引值所在的视图
 *
 *  @param index 索引值
 */
- (void)removeViewAtIndex:(NSInteger)index;

/**
 *  设置一组视图
 *
 *  @param arrView 一组视图数据
 */
- (void)setArrayOfView:(NSArray *)arrView;

/**
 *  得到某个索引的视图
 *
 *  @param index 视图索引
 *
 *  @return view  返回视图
 */
- (UIView *)viewAtIndex:(NSInteger)index;

- (NSInteger)indexForView:(UIView *)view;

/**
 *  视图消失动画
 *
 *  @param currentTaskView 要消失的视图
 *  @param completion      动画完成
 */
- (void)dismissAnimation:(void(^)(UIView *taskView,NSInteger currentIdx))currentTaskView completion:(void(^)(void))completion;

/**
 *  设置alpha值为1.
 */
- (void)setAlphaFullForSubviews;
@end
