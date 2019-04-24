//
//  YTLatestDealContaineeTableViewController.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTLatestDealContaineeTableViewController.h"
#import "YTLatestDealContaineeCell.h"

@interface YTLatestDealContaineeTableViewController ()

@end

@implementation YTLatestDealContaineeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.models.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YTLatestDealContaineeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YTLatestDealContaineeCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.model = self.models[indexPath.row];
    return cell;
}

#pragma mark - Setters

- (void)setModels:(NSArray<Trade_list *> *)models {
    _models = models;
    
    [self.tableView reloadData];
}


#pragma mark - Public
static CGFloat const kCellHeight = 24.;
+ (CGFloat)getHeightWithModels:(NSArray<Trade_list *> *)models {
    return models.count * kCellHeight;
}

@end
