//
//  YTNewDetailTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/10/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTNewDetailTableViewCell.h"
#import "YTDetailModel.h"
#import "GetListApi.h"
#import "QuotationableViewCell.h"
#import "EmptyManager.h"
#import "TPCurrencyInfoController.h"
@implementation YTNewDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.rimg.layer.cornerRadius = 8;
    self.rimg.layer.masksToBounds = YES;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSLog(@"1296035591  = %@",confromTimesp);
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    //NSLog(@"&&&&&&&confromTimespStr = : %@",confromTimespStr);
    
    return confromTimespStr;
    
}

-(NSString *)filterHTML:(NSString *)html
{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"[ _`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]|\n|\r|\t"];
    NSString *newname = [[html componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
    
    return newname;
}

- (void)refreshWithModel:(YTDetailModel *)model{
    self.lbael1.text = [self filterHTML:model.title];
    self.des.text = [self filterHTML:model.content];
    [self.rimg setImageWithURL:[NSURL URLWithString:model.art_pic] placeholder:[UIImage imageNamed:@"zhanweitu"]];
    self.timeLabel.text = [self timestampSwitchTime:[model.add_time intValue] andFormatter:@"yyyy/MM/dd HH:mm:ss"];
}

@end
