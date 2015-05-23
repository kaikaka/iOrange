//
//  UIImageEx.m
//

#import "UIImageEx.h"

#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED>__IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault|kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif

@implementation UIImage (Ex)

/// 截图
+ (UIImage *)imageFromView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/// 截图 (指定区域)
+ (UIImage *)imageFromView:(UIView *)view rect:(CGRect)rect {
    UIImage *imageOrigent = [UIImage imageFromView:view];
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(imageOrigent.CGImage, CGRectApplyAffineTransform(rect, CGAffineTransformMakeScale([UIScreen mainScreen].scale, [UIScreen mainScreen].scale)));
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return image;
}

/// 生成模糊图片
- (UIImage *)blurImageWithFactor:(CGFloat)factor {
    NSData  *imageData = UIImageJPEGRepresentation(self, 1); // convert to jpeg
    UIImage *destImage = [UIImage imageWithData:imageData];
    
    if (factor < 0.f || factor > 1.f) {
        factor = 0.5f;
    }
    int boxSize = (int)(factor * 40);
    boxSize = boxSize-(boxSize % 2) + 1;
    
    CGImageRef img = destImage.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    
    vImage_Error error;
    
    void *pixelBuffer;
    
    // create vImage_Buffer with data from CGImageRef
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width    = CGImageGetWidth(img);
    inBuffer.height   = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data     = (void*)CFDataGetBytePtr(inBitmapData);
    
    // create vImage_Buffer for output
    pixelBuffer = malloc(CGImageGetBytesPerRow(img)*CGImageGetHeight(img));
    if (pixelBuffer == NULL) {
        DLog(@"No pixelbuffer");
    }
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // Create a third buffer for intermediate processing
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    // perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        DLog(@"error from convolution %ld", error);
    }
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        DLog(@"error from convolution %ld", error);
    }
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        DLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, bitmapInfo);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    
    UIImage *blurImage = [UIImage imageWithCGImage:imageRef];
    
    // clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return blurImage;
}

//等比例缩放
+ (UIImage*)scaleToSize:(CGSize)size image:(UIImage *)picture {
  CGFloat width = CGImageGetWidth(picture.CGImage);
  CGFloat height = CGImageGetHeight(picture.CGImage);
  
  float verticalRadio = size.height*1.0/height;
  float horizontalRadio = size.width*1.0/width;
  
  float radio = 1;
  if(verticalRadio>1 && horizontalRadio>1)
  {
    radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
  }
  else
  {
    radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
  }
  
  width = width*radio;
  height = height*radio;
  
  int xPos = (size.width - width)/2;
  int yPos = (size.height-height)/2;
  
  // 创建一个bitmap的context
  // 并把它设置成为当前正在使用的context
  UIGraphicsBeginImageContext(size);
  
  // 绘制改变大小的图片
  [picture drawInRect:CGRectMake(xPos, yPos, width, height)];
  
  // 从当前context中创建一个改变大小后的图片
  UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
  
  // 使当前的context出堆栈
  UIGraphicsEndImageContext();
  
  // 返回新的改变大小后的图片
  return scaledImage;
}

//等比例放大然后裁剪尺寸
+ (UIImage *)compressImageWith:(UIImage *)image width:(float)width height:(float)height {
  float imageWidth = image.size.width;
  float imageHeight = image.size.height;
  
  float widthScale = imageWidth /width;
  float heightScale = imageHeight /height;
  
  // 创建一个bitmap的context
  // 并把它设置成为当前正在使用的context
  UIGraphicsBeginImageContext(CGSizeMake(width, height));
  
  if (widthScale > heightScale) {
    [image drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
  }
  else {
    [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
  }
  
  // 从当前context中创建一个改变大小后的图片
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  // 使当前的context出堆栈
  UIGraphicsEndImageContext();
  
  return newImage;
  
}

+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset
{
  ALAssetRepresentation *assetRep = [asset defaultRepresentation];
  CGImageRef imgRef = [assetRep fullResolutionImage];
  UIImage *img = [UIImage imageWithCGImage:imgRef
                                     scale:assetRep.scale
                               orientation:(UIImageOrientation)assetRep.orientation];
  return img;
}

@end
