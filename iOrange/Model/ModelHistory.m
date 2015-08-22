//
//  ModelHistory.m
//  iOrange
//
//  Created by Yoon on 8/18/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import "ModelHistory.h"

@implementation ModelHistory
@synthesize hid = _hid,hDatenow = _hDatenow,hIsmark = _hIsmark,hLink = _hLink,hNumber = _hNumber,hTitle = _hTitle;

+ (ModelHistory *)modelHistory {
  ModelHistory *model = [[ModelHistory alloc] init];
  return model;
}

+ (ModelHistory *)modelHistoryWithStmt:(sqlite3_stmt *)stmt {
  ModelHistory *model = [[ModelHistory alloc] initWithStmt:stmt];
  return model;
}

- (ModelHistory *)initWithStmt:(sqlite3_stmt *)stmt {
  self = [self init];
  if (self) {
    char *value = NULL;
    self.hid = sqlite3_column_int(stmt, 0);
    self.hDatenow = sqlite3_column_double(stmt, 1);
    value = (char*)sqlite3_column_text(stmt, 2);
    self.hTitle = value?[NSString stringWithCString:value encoding:NSUTF8StringEncoding]:nil;
    value = (char*)sqlite3_column_text(stmt, 3);
    self.hLink = value?[NSString stringWithCString:value encoding:NSUTF8StringEncoding]:nil;
    value = (char*)sqlite3_column_text(stmt, 4);
    self.hNumber = value?[NSString stringWithCString:value encoding:NSUTF8StringEncoding]:nil;
    value = (char*)sqlite3_column_text(stmt, 5);
    self.hIsmark = value?[NSString stringWithCString:value encoding:NSUTF8StringEncoding]:nil;
  }
  return self;

}

@end
