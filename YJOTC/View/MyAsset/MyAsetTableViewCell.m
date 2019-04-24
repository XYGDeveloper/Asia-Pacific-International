//
//  MyAsetTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "MyAsetTableViewCell.h"
#import "MyAssetModel.h"
@implementation MyAsetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgview.layer.cornerRadius = 8;
    self.bgview.layer.masksToBounds = YES;
    self.mlabelBottom.text = kLocat(@"k_MyassetViewController_tableview_list_cell_middle_label");
//    self.rightBottomLabel.text = kLocat(@"k_MyassetViewController_tableview_list_cell_right_label");
    // Initialization code
}

- (void)refreshWithModel:(current_userModel *)model{
    self.coinType.text = model.currency_name;
//    self.rightTopLabel.text = model.sum_award;
    self.mLabelTop.text = model.sum;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
