//
//  ModelSuper.h
//  YouYou
//
//  Created by xiangkai yin on 15/1/31.
//  Copyright (c) 2015年 VeryApps. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 利用反射实现NSCoding。
/// 子类必须重新声明一遍父类的属性。
/// 如：ModelUser继承自ModelSuper, ModelAdmin继承自ModelUser。
/// 那么ModelAdmin.h中要将ModelUser的所有属性重新声明一遍。
@interface ModelSuper : NSObject <NSCoding>

- (BOOL)reflectDataFromOtherObject:(NSObject*)dataSource;

@end
