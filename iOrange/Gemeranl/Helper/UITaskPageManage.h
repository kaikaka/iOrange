//
//  UITaskPageManage.h
//  Browser-Touch
//
//  Created by xiangkai yin on 14-8-19.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewTaskPage.h"
/**
 *  UITaskPageManage 管理标签页
 */
@interface UITaskPageManage : NSObject

+ (UITaskPageManage *)sharedManage;
+ (UIImage *)SectionShots:(UIView *)rectView;
- (void)addTaskView:(UIView *)view;
- (void)insertTaskView:(UIView *)view atIndex:(NSInteger)index;
- (void)removeTaskView:(UIView *)view;
- (void)removeTaskViewAtIndex:(NSInteger)index;
- (void)setTaskArrayOfView:(NSArray *)arrView;
- (NSMutableArray *)nowArrayTask;
- (NSInteger)currentSelectIndexForGet;
- (void)currentSelectIndexForSet:(NSInteger)idx;
- (UIView *)taskViewAtIndex:(NSInteger)index;
- (NSInteger)indexOfTaskView:(UIView *)taskView;
@end