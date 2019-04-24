//
//  QuotationableViewCell.h
//  YJOTC
//
//  Created by l on 2018/9/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ListModel;

@interface QuotationableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *coinType;
@property (weak, nonatomic) IBOutlet UILabel *topV;
@property (weak, nonatomic) IBOutlet UILabel *bottomV;
@property (weak, nonatomic) IBOutlet UILabel *endV;

- (void)refreshWithModel:(ListModel *)model;

@end
