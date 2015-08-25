//
//  ADOMark.h
//  iOrange
//
//  Created by Yoon on 8/22/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelMark.h"

@interface ADOMark : NSObject

/**
 *  插入书签
 *
 *  @param modelMark 书签实体
 *
 *  @return 是否成功
 */
+ (BOOL)InsertWithModelList:(ModelMark *)modelMark;

/**
 *  网址是否存在
 *
 *  @param link 网址
 *
 *  @return 是否存在
 */
+ (BOOL)isExistsWithPostLink:(NSString *)link;

/**
 *  是否是书签
 *
 *  @param hid 书签id
 *
 *  @return 是or否
 */
+ (BOOL)isExistsWithHid:(NSInteger)hid;

/**
 *  更新书签纪录
 *
 *  @param modelMark model
 *
 *  @return 是否成功
 */
+ (BOOL)updateModel:(ModelMark *)modelMark;

/**
 *  根据历史id 删除书签
 *
 *  @param hid 历史书签
 *
 *  @return 删除结果
 */
+ (BOOL)deleteWithHistroyId:(NSInteger)hid;

/**
 *  获取所有书签
 *
 *  @return 数组
 */
+ (NSArray *)queryAllMark;

/**
 *  删除书签（根据id）
 *
 *  @param mid id
 *
 *  @return 删除结果
 */
+ (BOOL)deleteWithMid:(NSInteger)mid;

@end
