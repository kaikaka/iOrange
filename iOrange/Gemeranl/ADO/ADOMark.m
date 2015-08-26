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

+ (BOOL)InsertWithModelList:(ModelMark *)modelMark {
  BOOL bFlage = NO;
  char * errorMsg;
  sqlite3 *database;
  NSString *insertSql = [NSString stringWithFormat:@"insert into tab_Mark (m_dateNow,m_icon, m_title,m_historyId,m_link) values (\"%f\", \"%@\", \"%@\", \"%ld\", \"%@\");", modelMark.mDatenow,modelMark.mIcon?modelMark.mIcon:@"",modelMark.mTitle?modelMark.mTitle:@"" ,modelMark.mHistoryId ,modelMark.mLink?modelMark.mLink:@"" ];
  do {
    if (SQLITE_OK != sqlite3_open([GetDBPath() UTF8String], &database))
      break;
    if (SQLITE_OK != sqlite3_exec (database, [insertSql  UTF8String], NULL, NULL, &errorMsg))
      break;
    bFlage = YES;
  } while (NO);
  sqlite3_close(database);
  return bFlage;
}

+ (BOOL)updateModel:(ModelMark *)modelMark{
  BOOL bFlage = NO;
  char * errorMsg;
  sqlite3 *database;
  NSString *insertSql = [NSString stringWithFormat:@"update tab_Mark set m_dateNow = \"%f\",m_icon = \"%@\",m_title = \"%@\",m_historyId = \"%ld\",m_link = \"%@\";", modelMark.mDatenow,modelMark.mIcon?modelMark.mIcon:@"",modelMark.mTitle?modelMark.mTitle:@"" ,(long)modelMark.mHistoryId,modelMark.mLink?modelMark.mLink:@"" ];
  do {
    if (SQLITE_OK != sqlite3_open([GetDBPath() UTF8String], &database))
      break;
    if (SQLITE_OK != sqlite3_exec (database, [insertSql  UTF8String], NULL, NULL, &errorMsg))
      break;
    bFlage = YES;
  } while (NO);
  sqlite3_close(database);
  return bFlage;
}

+ (BOOL)deleteWithHistroyId:(NSInteger)hid {
  char * errorMsg;
  sqlite3 *database;
  
  if (sqlite3_open([GetDBPath() UTF8String], &database) == SQLITE_OK) {
    NSString *deleteSQL = [NSString stringWithFormat:@"delete from tab_Mark where m_historyId=%ld;", hid];
    
    if (sqlite3_exec (database, [deleteSQL  UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
    }
    sqlite3_close(database);
    return YES;
  }
  
  return NO;
}

+ (BOOL)deleteWithMid:(NSInteger)mid {
  char * errorMsg;
  sqlite3 *database;
  
  if (sqlite3_open([GetDBPath() UTF8String], &database) == SQLITE_OK) {
    NSString *deleteSQL = [NSString stringWithFormat:@"delete from tab_Mark where m_id=%ld;", mid];
    
    if (sqlite3_exec (database, [deleteSQL  UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
    }
    sqlite3_close(database);
    return YES;
  }
  
  return NO;
}

+ (BOOL)deleteAllRecord {
  char * errorMsg;
  sqlite3 *database;
  
  if (sqlite3_open([GetDBPath() UTF8String], &database) == SQLITE_OK) {
    NSString *deleteSQL = @"delete from tab_Mark";
    
    if (sqlite3_exec (database, [deleteSQL  UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
    }
    sqlite3_close(database);
    return YES;
  }
  
  return NO;
}

+ (BOOL)isExistsWithPostLink:(NSString *)link {
  sqlite3 *database;
  NSString *sql = [NSString stringWithFormat:@"select * from tab_Mark where h_link = \"%@\";",[NSString stringWithFormat:@"%@",link]];
  
  if (sqlite3_open([GetDBPath() UTF8String], &database) == SQLITE_OK) {
    int count = 0;
    sqlite3_stmt *compiledStatement;
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
      if (sqlite3_step(compiledStatement) == SQLITE_ROW)
        count = sqlite3_column_int(compiledStatement, 0);
    }
    sqlite3_finalize(compiledStatement);
    if (count <= 0) {
      sqlite3_close(database);
      return NO;
    }
    sqlite3_close(database);
    return YES;
  }
  
  return NO;
}

+ (BOOL)isExistsWithHid:(NSInteger)hid {
  sqlite3 *database;
  NSString *sql = [NSString stringWithFormat:@"select * from tab_mark where m_historyId = \"%ld\";",hid];
  
  if (sqlite3_open([GetDBPath() UTF8String], &database) == SQLITE_OK) {
    int count = 0;
    sqlite3_stmt *compiledStatement;
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
      if (sqlite3_step(compiledStatement) == SQLITE_ROW)
        count = sqlite3_column_int(compiledStatement, 0);
    }
    sqlite3_finalize(compiledStatement);
    if (count <= 0) {
      sqlite3_close(database);
      return NO;
    }
    sqlite3_close(database);
    return YES;
  }
  
  return NO;
}

@end
