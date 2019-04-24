//
//  MyassetDetailItemTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@class user_order;
@interface MyassetDetailItemTableViewCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightBottomLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftBottomLabel;

- (void)refreshWithModel:(user_order *)model;

@end


