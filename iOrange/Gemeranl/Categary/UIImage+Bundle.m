//
//  UIImage+Bundle.m
//  KTBrowser
//
//  Created by David on 14-2-14.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIImage+Bundle.h"

#import <QuartzCore/QuartzCore.h>

@implementation UIImage (Bundle)

/**
 *  绝对路径图片
 *
 *  @param file 文件路径
 *
 *  @return UIImage
 */
+ (UIImage *)imageWithFile:(NSString *)file
{
    return [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:file]];
}

+ (UIImage *)imageFromView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageFromView:(UIView *)view rect:(CGRect)rect
{
    UIImage *imageOrigent = [UIImage imageFromView:view];
    CGImageRef imageRef = CGImageCreateWithImageInRect(imageOrigent.CGImage,CGRectApplyAffineTransform(rect, CGAffineTransformMakeScale([UIScreen mainScreen].scale, [UIScreen mainScreen].scale)));
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

@end
