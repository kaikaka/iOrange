//
//  ModelMark.m
//  iOrange
//
//  Created by Yoon on 8/22/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import "ModelMark.h"

@implementation ModelMark

@synthesize mDatenow = _mDatenow,mHistoryId = _mHistoryId,mIcon = _mIcon,mid = _mid,mLink = _mLink,mTitle = _mTitle;

+ (ModelMark *)modelMark {
  ModelMark *model = [[ModelMark alloc] init];
  return model;
}

+ (ModelMark *)modelMarkWithStmt:(sqlite3_stmt *)stmt {
  ModelMark *model = [[ModelMark alloc] initWithStmt:stmt];
  return model;
}

- (ModelMark *)initWithStmt:(sqlite3_stmt *)stmt {
  self = [self init];
  if (self) {
    char *value = NULL;
    self.mid = sqlite3_column_int(stmt, 0);
    self.mDatenow = sqlite3_column_double(stmt, 1);
    value = (char*)sqlite3_column_text(stmt, 2);
    self.mIcon = value?[NSString stringWithCString:value encoding:NSUTF8StringEncoding]:nil;
    value = (char*)sqlite3_column_text(stmt, 3);
    self.mTitle = value?[NSString stringWithCString:value encoding:NSUTF8StringEncoding]:nil;
    value = (char*)sqlite3_column_text(stmt, 4);
    self.mHistoryId = value?[NSString stringWithCString:value encoding:NSUTF8StringEncoding]:nil;
    value = (char*)sqlite3_column_text(stmt, 5);
    self.mLink = value?[NSString stringWithCString:value encoding:NSUTF8StringEncoding]:nil;
  }
  return self;
  
}

@end
