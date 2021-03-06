//
//  YTSellTrendingContaineeViewController.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTSellTrendingContaineeViewController.h"
#import "YTSellTrendingContaineeCell.h"
#import "YTTradeIndexModel.h"

@interface YTSellTrendingContaineeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *enturstLabel;

@end

@implementation YTSellTrendingContaineeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _updateUI];
    
}

#pragma mark - Private

- (void)_updateUI {
    NSString *typeKey = self.isTypeOfBuy ? @"buy" : @"sell";
    
    self.typeLabel.text = kLocat(typeKey);
    self.priceLabel.text = kLocat(@"Price");
    self.enturstLabel.text = kLocat(@"Entrust");
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YTSellTrendingContaineeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YTSellTrendingContaineeCell" forIndexPath:indexPath];
    Buy_list *model = self.models[indexPath.row];
    NSInteger index = self.models.count - indexPath.row;
    UIColor *color = self.isTypeOfBuy ? kGreenColor : kOrangeColor;
    [cell configureWithModel:model index:index color:color];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.didSelectCellBlock) {
        Buy_list *model = self.models[indexPath.row];
        self.didSelectCellBlock(model.price);
    }
}

#pragma mark - Setters

- (void)setDidSelectCellBlock:(YTSellTrendingContaineeViewControllerCellDidSelectBlock)didSelectCellBlock {
    _didSelectCellBlock = didSelectCellBlock;
    self.tableView.allowsSelection = _didSelectCellBlock != nil;
}

- (void)setIsTypeOfBuy:(BOOL)isTypeOfBuy {
    _isTypeOfBuy = isTypeOfBuy;
    
    [self _updateUI];
}

- (void)setModels:(NSArray<Buy_list *> *)models {
    _models = models;
    
    [self.tableView reloadData];
}

@end
