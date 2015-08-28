//
//  ADOSite.h
//  iOrange
//
//  Created by Yoon on 8/28/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelSite.h"
#import <sqlite3.h>

@interface ADOSite : NSObject

+ (BOOL)InsertWithModelList:(ModelSite *)modelSite;

+ (NSArray *)queryAllSite;

+ (BOOL)deleteWithSiteId:(NSInteger)sid;

@end
