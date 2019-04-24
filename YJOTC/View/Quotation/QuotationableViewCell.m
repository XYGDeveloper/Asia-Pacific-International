//
//  QuotationableViewCell.m
//  YJOTC
//
//  Created by l on 2018/9/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "QuotationableViewCell.h"
#import "YTData_listModel.h"
@implementation QuotationableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headImg.layer.cornerRadius = 15;
    self.headImg.layer.masksToBounds = YES;
    self.endV.layer.cornerRadius = 4;
    self.endV.layer.masksToBounds = YES;
    // Initialization code
}

-(void)refreshWithModel:(ListModel *)model{
    [self.headImg setImageWithURL:[NSURL URLWithString:model.currency_logo] placeholder:[UIImage imageNamed:@""]];
    self.coinType.text = model.currency_name;
    self.topV.text = model.price;
    self.bottomV.text = [NSString stringWithFormat:@"≈%@USD",model.price_usd];
    self.bottomV.textColor = kColorFromStr(@"#999999");
    if ([model.price_status isEqualToString:@"0"]) {
        self.endV.backgroundColor = kRGBA(215, 114, 76, 1);
        self.endV.text = [NSString stringWithFormat:@"%@%%",model.change_24];
    }else if ([model.price_status isEqualToString:@"1"]){
        self.endV.backgroundColor = kRGBA(84, 187, 139, 1);
        self.endV.text = [NSString stringWithFormat:@"+%@%%",model.change_24];
    }else{
        self.endV.backgroundColor = kColorFromStr(@"#896FED");
        self.endV.text = [NSString stringWithFormat:@"%@%%",model.change_24];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
