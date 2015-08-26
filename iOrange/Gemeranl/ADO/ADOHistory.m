//
//  ADOHistory.m
//  iOrange
//
//  Created by Yoon on 8/18/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import "ADOHistory.h"
#import "FilePathUtil.h"

@implementation ADOHistory

+ (BOOL)InsertWithModelList:(ModelHistory *)modelHistory {
  BOOL bFlage = NO;
  char * errorMsg;
  sqlite3 *database;
  NSString *insertSql = [NSString stringWithFormat:@"insert into tab_History (h_dateNow,h_title, h_link ,h_number , h_ismark) values (\"%f\", \"%@\", \"%@\", \"%@\", \"%@\");", modelHistory.hDatenow,modelHistory.hTitle?modelHistory.hTitle:@"",modelHistory.hLink?modelHistory.hLink:@"" ,modelHistory.hNumber?modelHistory.hNumber:@"" ,modelHistory.hIsmark?modelHistory.hIsmark:@"" ];
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

+ (BOOL)updateModel:(ModelHistory *)modelHistory atUid:(NSString *)uid {
  BOOL bFlage = NO;
  char * errorMsg;
  sqlite3 *database;
  NSString *insertSql = [NSString stringWithFormat:@"update tab_History set h_dateNow = \"%f\",h_title = \"%@\",h_link = \"%@\",h_number = \"%@\",h_ismark = \"%@\" where h_id = \"%@\";", modelHistory.hDatenow,modelHistory.hTitle?modelHistory.hTitle:@"",modelHistory.hLink?modelHistory.hLink:@"" ,modelHistory.hNumber?modelHistory.hNumber:@"" ,modelHistory.hIsmark?modelHistory.hIsmark:@"" ,uid];
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

+ (NSArray *)queryHistoryFour{
  NSMutableArray *values = [NSMutableArray array];
  sqlite3 *database;
  NSString *querySql = @"select * from tab_History order by h_number desc limit 4";
  if(sqlite3_open([GetDBPath() UTF8String], &database) == SQLITE_OK) {
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(database, [querySql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
      while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
        ModelHistory *modelHistory = [ModelHistory modelHistoryWithStmt:compiledStatement];
        [values addObject:modelHistory];
      }
    }
    sqlite3_finalize(compiledStatement);
    sqlite3_close(database);
  }
  return  values;
}

+ (NSArray *)queryAllHistory{
  NSMutableArray *values = [NSMutableArray array];
  sqlite3 *database;
  NSString *querySql = @"SELECT * FROM tab_History order by h_datenow desc";
  if(sqlite3_open([GetDBPath() UTF8String], &database) == SQLITE_OK) {
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(database, [querySql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
      while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
        ModelHistory *modelHistory = [ModelHistory modelHistoryWithStmt:compiledStatement];
        [values addObject:modelHistory];
      }
    }
    sqlite3_finalize(compiledStatement);
    sqlite3_close(database);
  }
  return  values;
}

+ (ModelHistory *)queryModelWithLink:(NSString *)link {
  ModelHistory *valueModel;
  sqlite3 *database;
  NSString *querySql = [NSString stringWithFormat:@"select * from tab_History where h_link = \"%@\";",[NSString stringWithFormat:@"%@",link]];
  if(sqlite3_open([GetDBPath() UTF8String], &database) == SQLITE_OK) {
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(database, [querySql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
      while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
        ModelHistory *modelHy = [ModelHistory modelHistoryWithStmt:compiledStatement];
        valueModel = modelHy;
      }
    }
    sqlite3_finalize(compiledStatement);
    sqlite3_close(database);
  }
  return  valueModel;
}

+ (BOOL)isExistsWithPostLink:(NSString *)link {
  sqlite3 *database;
  NSString *sql = [NSString stringWithFormat:@"select * from tab_History where h_link = \"%@\";",[NSString stringWithFormat:@"%@",link]];
  
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

+ (BOOL)deleteWithHistroyId:(NSInteger)hid {
  char * errorMsg;
  sqlite3 *database;
  
  if (sqlite3_open([GetDBPath() UTF8String], &database) == SQLITE_OK) {
    NSString *deleteSQL = [NSString stringWithFormat:@"delete from tab_History where h_id=%ld;", hid];
    
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
    NSString *deleteSQL = @"delete from tab_History";
    if (sqlite3_exec (database, [deleteSQL  UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
    }
    sqlite3_close(database);
    return YES;
  }
  
  return NO;
}

@end
