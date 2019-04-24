//
//  QuotationViewController.h
//  YJOTC
//
//  Created by l on 2018/9/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"
#import "QuotationListViewController.h"
//typedef void(^QuotationListViewControllerDidSelectCellBlock)(ListModel *model);

@interface QuotationViewController : YJBaseViewController

@property (nonatomic, copy) QuotationListViewControllerDidSelectCellBlock didSelectCellBlock;

- (instancetype)initWithWidth:(CGFloat)width;

@end
