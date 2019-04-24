//
//  PayMethodTableViewCell.m
//  TestDemo
//
//  Created by mac on 2017/3/17.
//  Copyright © 2017年 shigu. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "PayMethodTableViewCell.h"
#import "Masonry.h"
#import "TBCityIconFont.h"

@implementation PayMethodTableViewCell{
  UIImageView *selectedImageView;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *bottomBorderView = [[UIView alloc] init];
        bottomBorderView.backgroundColor = UIColorFromRGB(0xe5e5e5);
        [self addSubview:bottomBorderView];
        [bottomBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.equalTo(self);
            make.height.equalTo(@0.7);
            make.bottom.equalTo(self);
        }];
        
        self.payImageView = [[UIImageView alloc]init];
        [self addSubview:self.payImageView ];
        [self.payImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.mas_right).multipliedBy(40.0/750);
        }];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel.textColor = UIColorFromRGB(0x333333);
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.payImageView.mas_right).offset(10);
        }];
        
        selectedImageView = [[UIImageView alloc] init];
        selectedImageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e639",28, UIColorFromRGB(0xABABAB))];
        [self addSubview:selectedImageView];
        [selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self.mas_right).multipliedBy(725.0/750);
        }];
        
        self.nameLabel.text = @"支付宝";
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    selectedImageView.image = selected?[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e631",28, UIColorFromRGB(0xf4054e))]:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e639",28, UIColorFromRGB(0xABABAB))];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


@end
