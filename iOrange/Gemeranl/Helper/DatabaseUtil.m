//
//  DatabaseUtil.m
//  FengShang
//
//  Created by David on 12-7-24.
//  Copyright (c) 2012年 com.veryapps. All rights reserved.
//

#import "DatabaseUtil.h"
#import <sqlite3.h>
#import "FilePathUtil.h"

@implementation DatabaseUtil

+(void)createDatabase {
  if ([[NSFileManager defaultManager] fileExistsAtPath:GetDBPath() isDirectory:nil]) return;
  char * errorMsg;
  sqlite3 *database;
  
  char *sqlMark = "create table if not exists tab_Mark ("
  "m_id integer not null primary key autoincrement, "
  "m_dateNow DATE,"
  "m_icon text,"
  "m_title text,"
  "m_historyId integer,"
  "m_link text);";
  
  char *sqlSite = "create table if not exists tab_Site ("
  "s_id integer not null primary key autoincrement, "
  "s_dateNow DATE,"
  "s_icon text,"
  "s_title text,"
  "s_isInternal text,"//备用字段
  "s_link text);";
  
  char *sqlHistory = "create table if not exists tab_History ("
  "h_id integer not null primary key autoincrement,"
  "h_dateNow DATE,"
  "h_title text,"
  "h_link text,"
  "h_number text,"
  "h_ismark text);";
  
  do {
    if (SQLITE_OK != sqlite3_open([GetDBPath() UTF8String], &database))
      break;
    if (SQLITE_OK != sqlite3_exec(database, sqlMark, NULL, NULL, &errorMsg))
      break;
    if (SQLITE_OK != sqlite3_exec(database, sqlSite, NULL, NULL, &errorMsg))
      break;
    if (SQLITE_OK != sqlite3_exec(database, sqlHistory, NULL, NULL, &errorMsg))
      break;
  } while (NO);
  
  sqlite3_close(database);
}

@end
