//
//  ModelHistory.h
//  iOrange
//
//  Created by Yoon on 8/18/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface ModelHistory : NSObject

/**
* id
*/
@property (nonatomic,assign)NSInteger hid;

/**
 *  访问时间
 */
@property (nonatomic,assign)NSTimeInterval hDatenow;

/**
 *  标题
 */
@property (nonatomic,strong)NSString *hTitle;

/**
 *  访问网址
 */
@property (nonatomic,strong)NSString *hLink;

/**
 *  访问次数
 */
@property (nonatomic,strong)NSString *hNumber;

/**
 *  是否是书签
 */
@property (nonatomic,strong)NSString *hIsmark;

+ (ModelHistory *)modelHistory;

+ (ModelHistory *)modelHistoryWithStmt:(sqlite3_stmt *)stmt;

- (ModelHistory *)initWithStmt:(sqlite3_stmt *)stmt;

@end
