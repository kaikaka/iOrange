//
//  ModelSuper.m
//  YouYou
//
//  Created by xiangkai yin on 15/1/31.
//  Copyright (c) 2015年 VeryApps. All rights reserved.
//

#import "ModelSuper.h"
#import <objc/runtime.h>

@implementation ModelSuper

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super init]) {
    if (!aDecoder) {
      return self;
    }
    //类名称
    Class clazz = [self class];
    u_int count;
    //class_copyPropertyList 获取class的属性数组
    objc_property_t *properties    = class_copyPropertyList(clazz, &count);
    NSMutableArray  *propertyArray = [NSMutableArray arrayWithCapacity:count];
    for (int i=0; i<count; i++) {
      //property_getName 根据字符名称获取属性引用
      const char* propertyName = property_getName(properties[i]);
      [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    //释放内存
    free(properties);
    
    for (NSString *name in propertyArray) {
      id value = [aDecoder decodeObjectForKey:name];
      [self setValue:value forKey:name];
    }
  }
  
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  Class clazz = [self class];
  u_int count;
  
  objc_property_t *properties     = class_copyPropertyList(clazz, &count);
  NSMutableArray  *propertyArray  = [NSMutableArray arrayWithCapacity:count];
  for (int i=0; i<count; i++) {
    const char* propertyName = property_getName(properties[i]);
    [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
  }
  free(properties);
  
  for (NSString *name in propertyArray) {
    id value = [self valueForKey:name];
    [aCoder encodeObject:value forKey:name];
  }
}


- (NSArray*)propertyKeys {
  unsigned int outCount, i;
  objc_property_t *properties = class_copyPropertyList([self class], &outCount);
  NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
  for (i = 0; i < outCount; i++) {
    objc_property_t property = properties[i];
    NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
    [keys addObject:propertyName];
  }
  free(properties);
  return keys;
}

- (BOOL)reflectDataFromOtherObject:(NSObject*)dataSource {
  BOOL ret = NO;
  for (NSString *key in [self propertyKeys]) {
    if ([dataSource isKindOfClass:[NSDictionary class]]) {
      ret = ([dataSource valueForKey:key]==nil)?NO:YES;
    } else {
      ret = [dataSource respondsToSelector:NSSelectorFromString(key)];
    }
    if (ret) {
      id propertyValue = [dataSource valueForKey:key];
      //该值不为NSNULL，并且也不为nil
      if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue!=nil) {
        [self setValue:propertyValue forKey:key];
      }
    }
  }
  return ret;
}
@end
