//
//  QuotationListViewController.m
//  YJOTC
//
//  Created by l on 2018/9/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "QuotationListViewController.h"
#import "GetListApi.h"
#import "QuotationableViewCell.h"
#import "EmptyManager.h"
#import "YTData_listModel.h"
#import "TPCurrencyInfoController.h"
@interface QuotationListViewController ()<ApiRequestDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)GetListApi *api;
@property (nonatomic,strong)NSMutableArray *infoList;

@end

@implementation QuotationListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (NSMutableArray *)infoList{
    if (!_infoList) {
        _infoList = [NSMutableArray array];
    }
    return _infoList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"QuotationableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([QuotationableViewCell class])];
    self.tableview.showsVerticalScrollIndicator = NO;
    [self.tableview reloadData];
//    self.api  = [[GetListApi alloc]initWithType:self.tag lanage:lang];
//    self.api.delegate = self;
//    __weak typeof(self) wself = self;
//    self.tableview.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
//        kShowHud;
//        __strong typeof(wself) sself = wself;
//        [sself.api refresh];
//    }];
//
//    self.tableview.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
//        __strong typeof(wself) sself = wself;
//        [sself.api loadNextPage];
//    }];
//    [self.tableview.mj_header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QuotationableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QuotationableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    ListModel *model = [self.list objectAtIndex:indexPath.row];
//    NSLog(@"---------%@",model.mj_keyValues);
    [cell refreshWithModel:model];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 30;
    }else{
        return 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 0.01;
    }else{
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        if (section == 0) {
            UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 30)];
            headerView.backgroundColor  = kRGBA(244, 244, 244, 1);
            
            UIButton *content = [UIButton buttonWithType:UIButtonTypeCustom];
            content.frame = CGRectMake(0, 5, kScreenW, 25);
            content.backgroundColor = [UIColor whiteColor];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, kScreenW/3, 24)];
            label.font = [UIFont systemFontOfSize:12.0f];
            label.text = kLocat(@"k_QuotationListViewController_top_label_1");
            [content addSubview:label];
            UIImageView *img = [[UIImageView alloc]init];
            img.image = [UIImage imageNamed:@""];
            [content addSubview:img];
            img.userInteractionEnabled = YES;
            [img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-15);
                make.centerY.mas_equalTo(content.mas_centerY);
                make.width.mas_equalTo(24);
                make.height.mas_equalTo(5);
            }];
//            UIView *lineView =[[UIView alloc]init];
//            lineView.backgroundColor = kColorFromStr(@"#F4F4F4");
//            [content addSubview:lineView];
//            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.bottom.mas_equalTo(0);
//                make.height.mas_equalTo(1);
//            }];
            [headerView addSubview:content];
            
            return headerView;
        }else{
            return nil;
        }
        
    }else{
        if (section == 0) {
            UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 30)];
            headerView.backgroundColor  = kRGBA(244, 244, 244, 1);
            
            UIButton *content = [UIButton buttonWithType:UIButtonTypeCustom];
            content.frame = CGRectMake(0, 5, kScreenW, 25);
            content.backgroundColor = [UIColor whiteColor];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, kScreenW/3, 24)];
            label.font = [UIFont systemFontOfSize:12.0f];
            label.text = kLocat(@"k_QuotationListViewController_top_label_1");
            [content addSubview:label];
            UIImageView *img = [[UIImageView alloc]init];
            img.image = [UIImage imageNamed:@""];
            [content addSubview:img];
            img.userInteractionEnabled = YES;
            [img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-15);
                make.centerY.mas_equalTo(content.mas_centerY);
                make.width.mas_equalTo(24);
                make.height.mas_equalTo(5);
            }];
//            UIView *lineView =[[UIView alloc]init];
//            lineView.backgroundColor = kColorFromStr(@"#F4F4F4");
//            [content addSubview:lineView];
//            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.bottom.mas_equalTo(0);
//                make.height.mas_equalTo(1);
//            }];
            [headerView addSubview:content];
            return headerView;
        }else{
            return nil;
        }
    }
}

//- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
////    [self showTips:command.response.msg];
//    kHideHud;
//    [self.tableview.mj_footer resetNoMoreData];
//    [self.tableview.mj_header endRefreshing];
//    [[EmptyManager sharedManager] removeEmptyFromView:self.view];
//    NSArray *array = (NSArray *)responsObject;
//    NSLog(@"xxxxxxxxx%@",responsObject);
//    NSLog(@"--------------%@",array);
//    if (array.count <= 0) {
//        [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"empty"] explain:kLocat(@"empty_msg") operationText:@"" operationBlock:^{
//            [self.tableview.mj_header beginRefreshing];
//        }];
//    } else {
//        [self.infoList removeAllObjects];
//        [self.infoList addObjectsFromArray:array];
//        [self.tableview reloadData];
//    }
//}
//
//- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
//
//    [self.tableview.mj_header endRefreshing];
//    kHideHud;
//
////    [self showTips:command.response.msg];
//    [self.tableview.mj_header endRefreshing];
//    [[EmptyManager sharedManager] removeEmptyFromView:self.view];
//    if (self.infoList.count <= 0) {
//        [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"empty"] explain:kLocat(@"empty_msg") operationText:kLocat(@"") operationBlock:^{
//            [self.tableview.mj_header beginRefreshing];
//        }];
//    }
//}
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ListModel *model = [self.list objectAtIndex:indexPath.row];
    kHideHud;

    if (self.didSelectCellBlock) {
        self.didSelectCellBlock(model);
        return;
    }
    TPCurrencyInfoController *info = [TPCurrencyInfoController new];
    info.model = model;
    kNavPush(info);

}
//
//- (void)api:(BaseApi *)api loadMoreSuccessWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
//    [self showTips:command.response.msg];
//    kHideHud;
//    [self.tableview.mj_footer endRefreshing];
//    [self.infoList addObjectsFromArray:responsObject];
//    [self.tableview reloadData];
//}
//
//- (void)api:(BaseApi *)api loadMoreFailedWithCommand:(ApiCommand *)command error:(NSError *)error {
//    [self.tableview.mj_footer endRefreshing];
//    kHideHud;
//    [self showTips:command.response.msg];
//}
//
//- (void)api:(BaseApi *)api loadMoreEndWithCommand:(ApiCommand *)command {
//    kHideHud;
//    [self.tableview.mj_footer endRefreshingWithNoMoreData];
//}


@end
