//
//  ADOMark.m
//  iOrange
//
//  Created by Yoon on 8/22/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import "ADOMark.h"
#import "FilePathUtil.h"

@implementation ADOMark

+ (NSArray *)queryAllMark{
  NSMutableArray *values = [NSMutableArray array];
  sqlite3 *database;
  NSString *querySql = @"SELECT * FROM tab_Mark order by m_datenow desc";
  if(sqlite3_open([GetDBPath() UTF8String], &database) == SQLITE_OK) {
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(database, [querySql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
      while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
        ModelMark *modelMark = [ModelMark modelMarkWithStmt:compiledStatement];
        [values addObject:modelMark];
      }
    }
    sqlite3_finalize(compiledStatement);
    sqlite3_close(database);
  }
  return  values;
}

@end
