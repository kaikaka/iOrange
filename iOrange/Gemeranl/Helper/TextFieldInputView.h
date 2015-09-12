//
//  TextFieldInputView.h
//  iOrange
//
//  Created by XiangKai Yin on 9/12/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldInputView : UIView

@property(nonatomic, weak) UITextField *inputView;


+(void) attachToInputView:(UITextField *) textField;

@end
