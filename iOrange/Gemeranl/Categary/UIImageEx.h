//
//  UIImageEx.h
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface UIImage (Ex)

/// 截图
+ (UIImage *)imageFromView:(UIView *)view;

/// 截图 (指定区域)
+ (UIImage *)imageFromView:(UIView *)view rect:(CGRect)rect;

//等比例放大然后裁剪尺寸
+ (UIImage *)compressImageWith:(UIImage *)image width:(float)width height:(float)height;

//等比例缩放
+ (UIImage*)scaleToSize:(CGSize)size image:(UIImage *)picture;

/// 生成模糊图片
- (UIImage *)blurImageWithFactor:(CGFloat)factor;

//图片选择器选择的ALAsset对象 转换成UIImage
+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset;
@end
