//
//  UIViewTaskPage.h
//  Browser-Touch
//
//  Created by xiangkai yin on 14-8-19.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * UIViewTaskPage 标签页
 */
@class UIViewTaskPage;
@protocol UIViewTaskPageDelegate <NSObject>
@required
- (void)webPagePanBegin:(UIViewTaskPage *)pageWeb withDirectionX:(BOOL)isDirection;
- (void)webPagePanEnd:(UIViewTaskPage *)pageWeb withDirectionX:(BOOL)isDirection;
@optional
- (void)webPageRemoved:(UIViewTaskPage *)pageWeb;

@end

@interface UIViewTaskPage : UIView

@property (nonatomic,strong)UIImageView *imgvIcon;
@property (nonatomic,strong)UILabel *labTitle;
@property (nonatomic,strong)UIView *forntGrayView;
@property (nonatomic,strong)UIView *webViewPage;
@property (nonatomic,assign) id<UIViewTaskPageDelegate> delegate;

@end