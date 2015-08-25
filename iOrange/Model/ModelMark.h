//
//  ModelMark.h
//  iOrange
//
//  Created by Yoon on 8/22/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface ModelMark : NSObject

/**
 * id
 */
@property (nonatomic,assign)NSInteger mid;

/**
 *  访问时间
 */
@property (nonatomic,assign)NSTimeInterval mDatenow;

/**
 *  网址图标
 */
@property (nonatomic,strong)NSString *mIcon;

/**
 *  标题
 */
@property (nonatomic,strong)NSString *mTitle;

/**
 *  历史表id
 */
@property (nonatomic,assign)NSInteger mHistoryId;

/**
 *  网址
 */
@property (nonatomic,strong)NSString *mLink;

+ (ModelMark *)modelMark;

+ (ModelMark *)modelMarkWithStmt:(sqlite3_stmt *)stmt;

- (ModelMark *)initWithStmt:(sqlite3_stmt *)stmt;

@end
