//
//  ModelSite.m
//  iOrange
//
//  Created by Yoon on 8/28/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import "ModelSite.h"

@implementation ModelSite

+ (ModelSite *)modelSite {
  return [[ModelSite alloc] init];
}

+ (ModelSite *)modelSiteWithStmt:(sqlite3_stmt *)stmt {
  ModelSite *model = [[ModelSite alloc] initWithStmt:stmt];
  return model;
}

- (ModelSite *)initWithStmt:(sqlite3_stmt *)stmt {
  self = [self init];
  if (self) {
    char *value = NULL;
    self.s_id = sqlite3_column_int(stmt, 0);
    self.s_dateNow = sqlite3_column_double(stmt, 1);
    value = (char*)sqlite3_column_text(stmt, 2);
    self.s_icon = value?[NSString stringWithCString:value encoding:NSUTF8StringEncoding]:nil;
    value = (char*)sqlite3_column_text(stmt, 3);
    self.s_title = value?[NSString stringWithCString:value encoding:NSUTF8StringEncoding]:nil;
    value = (char*)sqlite3_column_text(stmt, 4);
    self.s_isInternal = value?[NSString stringWithCString:value encoding:NSUTF8StringEncoding]:nil;
    value = (char*)sqlite3_column_text(stmt, 5);
    self.s_link = value?[NSString stringWithCString:value encoding:NSUTF8StringEncoding]:nil;
  }
  return self;
  
}

@end
