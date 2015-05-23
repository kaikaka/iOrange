//
//  UIImage+Bundle.h
//  KTBrowser
//
//  Created by David on 14-2-14.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Bundle)

/**
 *  绝对路径图片
 *
 *  @param file 文件路径
 *
 *  @return UIImage
 */
+ (UIImage *)imageWithFile:(NSString *)file;

+ (UIImage *)imageFromView:(UIView *)view;

+ (UIImage *)imageFromView:(UIView *)view rect:(CGRect)rect;

@end
