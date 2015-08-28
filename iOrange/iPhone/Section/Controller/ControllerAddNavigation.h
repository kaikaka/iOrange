//
//  ControllerAddNavigation.h
//  iOrange
//
//  Created by Yoon on 8/28/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import "ControllerBase.h"

@interface ControllerAddNavigation : ControllerBase
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIView *viewLink;
@property (weak, nonatomic) IBOutlet UIView *viewTitle;
@property (weak, nonatomic) IBOutlet UITextField *textFileLink;
@property (weak, nonatomic) IBOutlet UITextField *texFieldName;
@property (weak, nonatomic) IBOutlet UITableView *tableNow;

@end
