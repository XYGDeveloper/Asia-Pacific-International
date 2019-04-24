
//
//  HBMyAssetReleaseRecordCell.m
//  HuaBi
//
//  Created by Roy on 2018/11/8.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBMyAssetReleaseRecordCell.h"

@interface HBMyAssetReleaseRecordCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *volume;

@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;

@end



@implementation HBMyAssetReleaseRecordCell

-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    _timeLabel.text = dataDic[@"time"];
    _volumeLabel.text = [NSString stringWithFormat:@"%@%@",dataDic[@"money"],dataDic[@"name"]];
    
    _statusLabel.text = kLocat(@"Assert_detail_releaseSuccess");
        
}



- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kRGBA(244, 244, 244, 1);
    
    kViewBorderRadius(_bgView, 8, 0, kRedColor);
    _bgView.backgroundColor = [UIColor whiteColor];
    
    _volume.textColor = kColorFromStr(@"#999999");
    _volume.font = PFRegularFont(12);
    
    _status.textColor = kColorFromStr(@"#999999");
    _status.font = PFRegularFont(12);
    
    _time.textColor = kColorFromStr(@"#999999");
    _time.font = PFRegularFont(12);
    
    _volumeLabel.textColor = kColorFromStr(@"#333333");
    _volumeLabel.font = PFRegularFont(14);
    
    _statusLabel.textColor = kColorFromStr(@"#333333");
    _statusLabel.font = PFRegularFont(14);
    
    _timeLabel.textColor = kColorFromStr(@"#333333");
    _timeLabel.font = PFRegularFont(14);
    
    _time.text = kLocat(@"Assert_detail_dealtime");
    _status.text = kLocat(@"k_popview_input_branchbank_confirm_orderstatus");
    _volume.text = kLocat(@"Assert_detail_releaseVolume");
    _statusLabel.text = kLocat(@"Assert_detail_releaseSuccess");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
