//
//  ModelSuper.h
//  YouYou
//
//  Created by xiangkai yin on 15/1/31.
//  Copyright (c) 2015年 VeryApps. All rights reserved.
//

#import <Foundation/Foundation.h>
//runtime
@interface ModelSuper : NSObject <NSCoding>

- (BOOL)reflectDataFromOtherObject:(NSObject*)dataSource;

@end
