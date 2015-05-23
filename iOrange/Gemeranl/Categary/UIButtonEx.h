//
//  UIButton+Ex.h 
//

#import <UIKit/UIKit.h>

@interface UIButton (UIButtonEx)

- (void)setImageWithFile:(NSString *)file;
- (void)setHighlightedImageWithFile:(NSString *)file;
- (void)setSelectedImageWithFile:(NSString *)file;
- (void)setDisabledImageWithFile:(NSString *)file;

- (void)setBgImageWithFile:(NSString *)file;
- (void)setHighlightedBgImageWithFile:(NSString *)file;
- (void)setSelectedBgImageWithFile:(NSString *)file;
- (void)setDisabledBgImageWithFile:(NSString *)file;

@end
