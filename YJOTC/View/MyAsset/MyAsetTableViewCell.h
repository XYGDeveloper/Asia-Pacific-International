//
//  MyAsetTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@class current_userModel;

@interface MyAsetTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgview;

@property (weak, nonatomic) IBOutlet UILabel *coinType;
@property (weak, nonatomic) IBOutlet UILabel *mLabelTop;

@property (weak, nonatomic) IBOutlet UILabel *mlabelBottom;
@property (weak, nonatomic) IBOutlet UILabel *rightTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightBottomLabel;

- (void)refreshWithModel:(current_userModel *)model;

@end

