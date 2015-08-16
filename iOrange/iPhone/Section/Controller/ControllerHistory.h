//
//  ControllerHistory.h
//  iOrange
//
//  Created by Yoon on 8/16/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import "ControllerBase.h"

@interface ControllerHistory : ControllerBase

@property (weak, nonatomic) IBOutlet UIView *viewHome;
@property (weak, nonatomic) IBOutlet UIView *viewNav;
@property (weak, nonatomic) IBOutlet UITableView *tableBookmark;

@property (weak, nonatomic) IBOutlet UITableView *tableHistory;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentBomkHisy;

@end
