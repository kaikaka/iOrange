//
//  UIImageView+UIImageViewEx.m
//  TaobaoFair
//
//  Created by Glex on 13-7-19.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import "UIImageViewEx.h"

@implementation UIImageView (UIImageViewEx)

- (void)setImageWithName:(NSString *)imgName {
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:imgName ofType:@"png"];
    self.image = [UIImage imageWithContentsOfFile:imgPath];
}

@end
