//
//  PayMethodViewController.m
//  TestDemo
//
//  Created by mac on 2017/3/17.
//  Copyright © 2017年 shigu. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "PayMethodViewController.h"
#import "STPopupController.h"
#import "UIViewController+STPopup.h"
#import "Masonry.h"
#import "TBCityIconFont.h"
#import "PayMethodTableViewCell.h"

@interface PayMethodViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic)NSString *getPayNameString;
@property(nonatomic)UITableView *tableView;
@property(nonatomic)NSArray *payTitle;
@property(nonatomic)NSArray *payImage;

@end

@implementation PayMethodViewController

- (instancetype)init
{
    self = [super init];
    if(self) {
        CGFloat h = [UIScreen mainScreen].bounds.size.height *0.65;
        self.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].bounds.size.width, h);
        self.landscapeContentSizeInPopup = CGSizeMake([UIScreen mainScreen].bounds.size.height, h);
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.payTitle = @[@"支付宝支付",@"微信支付",@"其他宝支付"];
    self.payImage = @[[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e638", 50,UIColorFromRGB(0x0799e2))],[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e636", 50,UIColorFromRGB(0x02c802))],[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e637", 50,UIColorFromRGB(0xff4400))]];
    for(NSInteger i = 0; i < self.payTitle.count; ++i) {
        if([self.hasSelectPay isEqualToString:self.payTitle[i]]) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            self.getPayNameString = self.payTitle[i];
            break;
        }
    }
    [self initView];
}

- (void)initView{
    
    UIView *superview = self.view;
    self.tableView = [[UITableView alloc] init];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 81.0f;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [superview addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superview);
    }];
    
    //
    CGRect tableHeaderFrame = self.tableView.tableHeaderView.frame;
    tableHeaderFrame.size.height = 64;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:tableHeaderFrame];
    self.tableView.tableHeaderView.backgroundColor = UIColorFromRGB(0xffffff);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"选择支付方式";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = UIColorFromRGB(0x000000);
    [self.tableView.tableHeaderView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView.tableHeaderView);
    }];
    
    UIButton *closeButton = [[UIButton alloc] init];
    [closeButton setTitle:@"确定" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [closeButton setTitleColor:UIColorFromRGB(0xf4054e) forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(didClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView.tableHeaderView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tableView.tableHeaderView);
        make.right.equalTo(self.tableView.tableHeaderView.mas_right).offset(-13);
    }];
    
    UIView * tableHeaderBottomView = [[UIView alloc]init];
    tableHeaderBottomView.backgroundColor = UIColorFromRGB(0xABABAB);
    [self.tableView.tableHeaderView addSubview:tableHeaderBottomView];
    [tableHeaderBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.tableHeaderView.mas_bottom).offset(1);
        make.width.equalTo(self.tableView.tableHeaderView);
        make.left.right.equalTo(self.tableView.tableHeaderView);
        make.height.mas_offset(@0.7);
    }];
    
}

- (void)didClose:(UIButton *)btn {
    if(self.popupController) [self.popupController dismiss];
    if(self.delegate && [self.delegate conformsToProtocol:@protocol(PayMethodSelectionViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(PayMethodSelectionViewControllerBackWithpayName:)]) {
        [self.delegate PayMethodSelectionViewControllerBackWithpayName:self.getPayNameString];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"XZCPayMethodSelectionViewController";
    PayMethodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell) {
        cell = [[PayMethodTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.nameLabel.text = self.payTitle[indexPath.row];
    cell.payImageView.image = self.payImage[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.getPayNameString = self.payTitle[indexPath.row];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
