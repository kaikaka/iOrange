//
//  TextFieldInputView.m
//  iOrange
//
//  Created by XiangKai Yin on 9/12/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import "TextFieldInputView.h"

@interface TextFieldInputView() {
  
  __weak IBOutlet UIButton *_btnwww;
  __weak IBOutlet UIButton *_btnDian;
  __weak IBOutlet UIButton *_btnXie;
  __weak IBOutlet UIButton *_btnCn;
  __weak IBOutlet UIButton *_btnCom;
  
}
-(IBAction) onTouchKey:(UIButton *) sender;

@end

static TextFieldInputView *textFieldInputView;

@implementation TextFieldInputView

+(void)attachToInputView:(UITextField *)textField {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    textFieldInputView = [[[NSBundle mainBundle] loadNibNamed:@"TextFieldInputView" owner:nil options:nil] lastObject];
  });
  textField.inputAccessoryView = textFieldInputView;
  
  textFieldInputView.inputView = textField;
}

-(void)awakeFromNib {
  [super awakeFromNib];
  [self setViewCorner:_btnwww];
  [self setViewCorner:_btnDian];
  [self setViewCorner:_btnCom];
  [self setViewCorner:_btnXie];
  [self setViewCorner:_btnCn];
  
}

#pragma mark - events

- (void)setViewCorner :(UIView *)view {
  view.layer.cornerRadius = 3.;
  view.layer.borderColor = [UIColor grayColor].CGColor;
}

-(void)onTouchKey:(UIButton *)sender {
  if (sender == _btnwww) {
    [_inputView insertText:@"www."];
  }
  if (sender == _btnXie) {
    [_inputView insertText:@"/"];
  }
  if (sender == _btnDian) {
    [_inputView insertText:@"."];
  }
  if (sender == _btnCom) {
    [_inputView insertText:@".com"];
  }
  if (sender == _btnCn) {
    [_inputView insertText:@".cn"];
  }
}


-(void) textPosition:(NSInteger) offset
{
  NSInteger indexCurr = [_inputView offsetFromPosition:_inputView.beginningOfDocument toPosition:_inputView.selectedTextRange.start];
  NSInteger toIndex = indexCurr+offset;
  NSInteger indexStart = [_inputView offsetFromPosition:_inputView.beginningOfDocument toPosition:_inputView.beginningOfDocument];
  NSInteger indexEnd = [_inputView offsetFromPosition:_inputView.beginningOfDocument toPosition:_inputView.endOfDocument];
  if (toIndex<indexStart) {
    [_inputView setSelectedTextRange:[_inputView textRangeFromPosition:_inputView.endOfDocument toPosition:_inputView.endOfDocument]];
  }
  else if (toIndex>indexEnd) {
    [_inputView setSelectedTextRange:[_inputView textRangeFromPosition:_inputView.beginningOfDocument toPosition:_inputView.beginningOfDocument]];
  }
  else {
    UITextPosition *start = [_inputView positionFromPosition:[_inputView beginningOfDocument]
                                                      offset:toIndex];
    UITextPosition *end = [_inputView positionFromPosition:start
                                                    offset:0];
    [_inputView setSelectedTextRange:[_inputView textRangeFromPosition:start
                                                            toPosition:end]];
  }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
