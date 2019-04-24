//
//  MyassetDetailItemTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "MyassetDetailItemTableViewCell.h"
#import "YTMyassetDetailModel.h"
@implementation MyassetDetailItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.leftLabel.text = kLocat(@"k_MyassetDetailViewController_tableview_cell_label");
    self.rightLabel.text = kLocat(@"k_MyassetDetailViewController_tableview_cell_label1");
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)refreshWithModel:(user_order *)model{
    self.rightLabel.text = model.type_name;
    self.leftBottomLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"k_MyassetDetailViewController_wt_price"),model.price];
    float count = [model.num floatValue]- [model.trade_num floatValue];
    self.rightBottomLabel.text = [NSString stringWithFormat:@"%@%f",kLocat(@"k_MyassetDetailViewController_wt_count"),count];
//    self.rightBottomLabel.text = [NSString stringWithFormat:@"%f",model.num,model.trade_num];
}

@end
