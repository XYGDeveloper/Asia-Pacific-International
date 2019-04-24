//
//  LogTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/10/10.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "LogTableViewCell.h"
#import "FinModel.h"
@implementation LogTableViewCell

- (void)refreshWIthModel:(FinModel *)model{
    self.typeLabel.text = kLocat(@"k_FinsetViewController_type");
    self.desLabel.text = kLocat(@"k_FinsetViewController_type1");
    self.bdLabel.text = kLocat(@"k_FinsetViewController_type2");
    self.zrLabel.text =kLocat(@"k_FinsetViewController_type3");
    self.jfLabel.text = kLocat(@"k_FinsetViewController_type4");
    self.timeLabel.text = kLocat(@"k_FinsetViewController_type5");
    self.typeContent.text = model.typename;
    self.desContent.text = model.content;
    self.bdContent.text = model.money;
    if ([model.money_type isEqualToString:@"1"]) {
        self.zrContent.text = @"收入";
    }else{
        self.zrContent.text = @"支出";
    }
    self.jfContent.text = model.currency_mark;
  
    self.timeContent.text = [self timestampSwitchTime:[model.add_time integerValue] andFormatter:@"yyyy-MM-dd HH:mm:ss"];
    
}

-(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
 
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
   
    return confromTimespStr;
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
