//
//  ModelSite.h
//  iOrange
//
//  Created by Yoon on 8/28/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ModelSuper.h"

@interface ModelSite : ModelSuper

@property (nonatomic,assign)NSInteger s_id;
@property (nonatomic,assign)NSTimeInterval s_dateNow;
@property (nonatomic,strong)NSString *s_icon;
@property (nonatomic,strong)NSString *s_title;
@property (nonatomic,strong)NSString *s_isInternal;
@property (nonatomic,strong)NSString *s_link;

+ (ModelSite *)modelSite;

+ (ModelSite *)modelSiteWithStmt:(sqlite3_stmt *)stmt;

@end
