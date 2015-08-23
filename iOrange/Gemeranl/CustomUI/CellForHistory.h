//
//  CellForHistory.h
//  iOrange
//
//  Created by Yoon on 8/23/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellForHistory : UITableViewCell

@property (nonatomic,strong) UIImageView *imgvDefault;
@property (nonatomic,strong) UILabel *labelLinkTitle;
@property (nonatomic,strong) UILabel *labelLinkLink;
@property (nonatomic,strong) UIButton *btnRight;

/**
 *  获取icon
 *
 *  @param urlLink 网址
 */
- (void)setIconAtUrl:(NSString *)urlLink;

@end
