//
//  UITaskPageManage.m
//  Browser-Touch
//
//  Created by xiangkai yin on 14-8-19.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UITaskPageManage.h"

@interface UITaskPageManage ()
@end

@implementation UITaskPageManage

static NSInteger      _selectIndex  =  -1;
static NSMutableArray *_arrayTaskPage;

static UITaskPageManage *taskShareManage = nil;

+ (UITaskPageManage *)sharedManage
{
    //单例
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (taskShareManage == nil) {
            taskShareManage = [[UITaskPageManage alloc] init];
            _arrayTaskPage = [NSMutableArray arrayWithCapacity:0];
        }
    });
    return taskShareManage;
}

- (void)addTaskView:(UIView *)view
{
    [_arrayTaskPage addObject:view];
}

- (void)insertTaskView:(UIView *)view atIndex:(NSInteger)index
{
    [_arrayTaskPage insertObject:view atIndex:index];
}

- (void)removeTaskView:(UIView *)view
{
    if ([_arrayTaskPage containsObject:view]) {
        [_arrayTaskPage removeObject:view];
    }
}

- (void)removeTaskViewAtIndex:(NSInteger)index
{
    if (index >= 0 && index < [_arrayTaskPage count]) {
        [_arrayTaskPage removeObjectAtIndex:index];
    }
}

- (void)setTaskArrayOfView:(NSArray *)arrView
{
    [_arrayTaskPage removeAllObjects];
    [_arrayTaskPage addObjectsFromArray:arrView];
}

- (UIView *)taskViewAtIndex:(NSInteger)index
{
    if (index >= 0 && index < [_arrayTaskPage count]) {
        UIViewTaskPage *viewPage = [_arrayTaskPage objectAtIndex:index];
        return viewPage;
    }
    return nil;
}

+ (UIImage *)SectionShots:(UIView *)rectView
{
    UIGraphicsBeginImageContext(CGSizeMake(rectView.bounds.size.width, rectView.bounds.size.height));
    [rectView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}

- (NSMutableArray *)nowArrayTask
{
    return _arrayTaskPage;
}

- (NSInteger)currentSelectIndexForGet
{
    if (_selectIndex == -1) {
        return [_arrayTaskPage count]-1;
    }
    return _selectIndex;
}
- (void)currentSelectIndexForSet:(NSInteger)idx
{
    _selectIndex = idx;
}

- (NSInteger)indexOfTaskView:(UIView *)taskView
{
    if ([_arrayTaskPage containsObject:taskView]) {
        return  [_arrayTaskPage indexOfObject:taskView];
    }
    return -1;
}

@end
