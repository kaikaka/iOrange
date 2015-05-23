//
//  UIButton+Ex.m 
//

#import "UIButtonEx.h"

@implementation UIButton (UIButtonEx)

- (void)setImageWithFile:(NSString *)fileName forState:(UIControlState)state {
    if (iPhone6Plus) {
        fileName = [fileName stringByAppendingString:@"@3x"];
    }
    else {
        fileName = [fileName stringByAppendingString:@"@2x"];
    }
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"png"];
    [self setImage:[UIImage imageWithContentsOfFile:imgPath] forState:state];
}

- (void)setImageWithFile:(NSString *)fileName {
    [self setImageWithFile:fileName forState:UIControlStateNormal];
}

- (void)setHighlightedImageWithFile:(NSString *)fileName {
    [self setImageWithFile:fileName forState:UIControlStateHighlighted];
}

- (void)setSelectedImageWithFile:(NSString *)fileName {
    [self setImageWithFile:fileName forState:UIControlStateSelected];
}

- (void)setDisabledImageWithFile:(NSString *)fileName {
    [self setImageWithFile:fileName forState:UIControlStateDisabled];
}

#pragma mark - bg image
- (void)setBgImageWithFile:(NSString *)fileName forState:(UIControlState)state {
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"png"];
    [self setBackgroundImage:[UIImage imageWithContentsOfFile:imgPath] forState:state];
}

- (void)setBgImageWithFile:(NSString *)fileName {
    [self setBgImageWithFile:fileName forState:UIControlStateNormal];
}

- (void)setHighlightedBgImageWithFile:(NSString *)fileName {
    [self setBgImageWithFile:fileName forState:UIControlStateHighlighted];
}

- (void)setSelectedBgImageWithFile:(NSString *)fileName {
    [self setBgImageWithFile:fileName forState:UIControlStateSelected];
}

- (void)setDisabledBgImageWithFile:(NSString *)fileName {
    [self setBgImageWithFile:fileName forState:UIControlStateDisabled];
}

@end
