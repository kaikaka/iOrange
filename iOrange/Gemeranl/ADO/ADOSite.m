//
//  ADOSite.m
//  iOrange
//
//  Created by Yoon on 8/28/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import "ADOSite.h"
#import "FilePathUtil.h"

@implementation ADOSite

+ (BOOL)InsertWithModelList:(ModelSite *)modelSite {
  if ([self isExistsWithPostLink:modelSite.s_link]) {
    [self deleteWithLink:modelSite.s_link];
  }
  BOOL bFlage = NO;
  char * errorMsg;
  sqlite3 *database;
  NSString *insertSql = [NSString stringWithFormat:@"insert into tab_Site (s_dateNow,s_icon, s_title,s_isInternal,s_link) values (\"%f\", \"%@\", \"%@\", \"%@\", \"%@\");", modelSite.s_dateNow,modelSite.s_icon?modelSite.s_icon:@"",modelSite.s_title?modelSite.s_title:@"" ,modelSite.s_isInternal?modelSite.s_isInternal:@"" ,modelSite.s_link?modelSite.s_link:@"" ];
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

+ (BOOL)isExistsWithPostLink:(NSString *)link {
  sqlite3 *database;
  NSString *sql = [NSString stringWithFormat:@"select * from tab_Site where s_link = \"%@\";",[NSString stringWithFormat:@"%@",link]];
  
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

+ (BOOL)deleteWithLink:(NSString *)link {
  char * errorMsg;
  sqlite3 *database;
  
  if (sqlite3_open([GetDBPath() UTF8String], &database) == SQLITE_OK) {
    NSString *deleteSQL = [NSString stringWithFormat:@"delete from tab_Site where s_link = \"%@\";", link];
    if (sqlite3_exec (database, [deleteSQL  UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
    }
    sqlite3_close(database);
    return YES;
  }
  
  return NO;
}

+ (NSArray *)queryAllSite{
  NSMutableArray *values = [NSMutableArray array];
  sqlite3 *database;
  NSString *querySql = @"SELECT * FROM tab_Site order by s_dateNow desc";
  if(sqlite3_open([GetDBPath() UTF8String], &database) == SQLITE_OK) {
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(database, [querySql UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
      while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
        ModelSite *modelSite = [ModelSite modelSiteWithStmt:compiledStatement];
        [values addObject:modelSite];
      }
    }
    sqlite3_finalize(compiledStatement);
    sqlite3_close(database);
  }
  return  values;
}

@end
