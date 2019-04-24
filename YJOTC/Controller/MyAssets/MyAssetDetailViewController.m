//
//  MyAssetDetailViewController.m
//  YJOTC
//
//  Created by l on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "MyAssetDetailViewController.h"
#import "MyassetDetailTableViewCell.h"
#import "MyassetDetailItemTableViewCell.h"
#import "ExchangeRecordViewController.h"
#import "HistoryRecordViewController.h"
#import "MyBCBViewController.h"
#import "sellOuterViewController.h"
#import "GetAssetDetailApi.h"
#import "YTMyassetDetailModel.h"
#import "JPSalertView.h"
#import "YTExAlertView.h"
#import "HBMyAssetReleaseRecordController.h"
#import "HBMyAssetExchangeController.h"

@interface MyAssetDetailViewController ()<UITableViewDataSource,UITableViewDelegate,ApiRequestDelegate,SWTableViewCellDelegate,JPSalertViewdelegate>
@property (nonatomic,strong)MyassetDetailTableViewCell *head;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *sellInBtn;
@property (weak, nonatomic) IBOutlet UIButton *sellOutBtn;
@property (weak, nonatomic) IBOutlet UIButton *exchangeButton;
@property (nonatomic,strong)YTMyassetDetailModel *model;
@property (nonatomic,strong)GetAssetDetailApi *api;
@property (nonatomic,strong)NSMutableArray *list;
@property (nonatomic,assign)NSInteger index;
@property(nonatomic,strong)JPSalertView *alertView;
@property(nonatomic,strong)NSString *free;
@property(nonatomic,strong)NSString *ATfree;

@end

@implementation MyAssetDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.type;
    self.api  = [[GetAssetDetailApi alloc]initWithKey:kUserInfo.token lanage:[Utilities gadgeLanguage:@""] token_id:[NSString stringWithFormat:@"%ld",kUserInfo.uid] currency_id:self.current_id];
    self.api.delegate = self;
    __weak typeof(self) wself = self;
    self.tableview.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself.api refresh];
    }];

    self.tableview.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself.api loadNextPage];
    }];
    [self.tableview.mj_header beginRefreshing];
    [self layOutsubviews];
    [self actions];
    // Do any additional setup after loading the view from its nib.
}

- (void)recordList{
    HBMyAssetReleaseRecordController *asset = [HBMyAssetReleaseRecordController new];
    asset.currencyID = self.model.currency.currency_id;
    kNavPush(asset);
}

- (NSMutableArray *)list{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

#pragma mark- layoutSubviews

- (void)layOutsubviews{
    self.tableview.backgroundColor = kRGBA(244, 244, 244, 1);
    self.view.backgroundColor = kRGBA(244, 244, 244, 1);
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerNib:[UINib nibWithNibName:@"MyassetDetailItemTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyassetDetailItemTableViewCell class])];
    MyassetDetailTableViewCell *head =  [[[NSBundle mainBundle] loadNibNamed:@"MyassetDetailTableViewCell" owner:nil options:nil] lastObject];
    head.userInteractionEnabled = YES;
    head.leftBtn.hidden = YES;
    self.head = head;
    self.tableview.tableHeaderView = self.head;
    self.tableview.showsVerticalScrollIndicator = NO;
    self.sellInBtn.layer.cornerRadius = 8;
    self.sellInBtn.layer.masksToBounds = YES;
    self.sellOutBtn.layer.cornerRadius = 8;
    self.sellOutBtn.layer.masksToBounds = YES;
    self.exchangeButton.layer.cornerRadius = 8;
    [self.sellInBtn setTitle:kLocat(@"k_MyassetDetailViewController_tableview_cell_label2") forState:UIControlStateNormal];
    [self.sellOutBtn setTitle:kLocat(@"k_MyassetDetailViewController_tableview_cell_label3") forState:UIControlStateNormal];
    [self.exchangeButton setTitle:kLocat(@"Assert_detail_exchange") forState:UIControlStateNormal];
    self.exchangeButton.hidden = YES;
}

#pragma mark- actions

- (void)actions{
    [self.head.leftBtn addTarget:self action:@selector(exchangeAT) forControlEvents:UIControlEventTouchUpInside];
    [self.head.rightBtn addTarget:self action:@selector(exchangeRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.head.moreButton addTarget:self action:@selector(moreRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.sellInBtn addTarget:self action:@selector(sellIn) forControlEvents:UIControlEventTouchUpInside];
    [self.sellOutBtn addTarget:self action:@selector(sellOut) forControlEvents:UIControlEventTouchUpInside];
}

/**
 兑换AT
 */
- (void)exchangeAT{
    //
    if ([self.model.currency.currency_name isEqualToString:@"AT"]) {
        [self showTips:@"AT不能兑换自己哦"];
        return;
    }
  
    if ([self.model.currency_user.num floatValue] <= 0) {
        [self showTips:[NSString stringWithFormat:@"%@余额不足,不能兑换哦",self.model.currency.currency_mark]];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"language"] = [Utilities gadgeLanguage:@""];
    //    param[@"sign"] = [Utilities handleParamsWithDic:param];
    param[@"uuid"] = [Utilities randomUUID];
    param[@"token_id"] = [NSString stringWithFormat:@"%ld",kUserInfo.uid];
    param[@"key"] = kUserInfo.token;
    param[@"currency_name"] = self.model.currency.currency_mark;
    NSLog(@"------------%@",param);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:mine_myasset_getscale] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        NSLog(@"%@",responseObj);
        [self showTips:[responseObj ksObjectForKey:kMessage]];
        if (success) {
            NSDictionary *dic = [responseObj ksObjectForKey:kData];
            self.free = dic[@"fee"];
            self.ATfree = dic[@"Atfee"];
            [YTExAlertView alertControllerAppearIn:self BTCtitle:[NSString stringWithFormat:@"%@%@",self.model.currency.currency_mark,kLocat(@"k_MyassetDetailViewController_alert_lin1")] BTCcontent:self.model.currency_user.num EXScale:kLocat(@"k_MyassetDetailViewController_alert_lin2") EXContent:[NSString stringWithFormat:@"≈%@:%@",self.ATfree,self.free] EXAT:kLocat(@"k_MyassetDetailViewController_alert_lin3") EXATMul:[NSString stringWithFormat:@"%@%@",kLocat(@"k_MyassetDetailViewController_alert_lin4"),self.model.currency.currency_mark] EXATMulcontent:@"" EXATPWD:kLocat(@"k_MyassetDetailViewController_alert_lin5") leftTitle:kLocat(@"k_MyassetDetailViewController_alert_left_btn") leftEvent:^(NSString *btcCount, NSString *scaleContent, NSString *atCount, NSString *mulCount, NSString *pwd) {
                //
                
                [self toExchangeWithPwd:pwd currency_mark:self.model.currency.currency_mark to_currency_mark:@"AT" actual_num:atCount];
                
            } middleTitle:kLocat(@"k_MyassetDetailViewController_alert_middle_btn") middleEvent:^{
                //
            } rightTitle:kLocat(@"k_MyassetDetailViewController_alert_right_btn") rightEvent:^{
                //
            } free:self.free atFree:self.ATfree Max:self.model.currency_user.num];
        }
    }];
    
}

- (void)toExchangeWithPwd:(NSString *)pwd
            currency_mark:(NSString *)currency_mark
         to_currency_mark:(NSString *)to_currency_mark
               actual_num:(NSString *)actual_num{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
 
    param[@"language"] = [Utilities gadgeLanguage:@""];
    //    param[@"sign"] = [Utilities handleParamsWithDic:param];
    param[@"uuid"] = [Utilities randomUUID];
    param[@"token_id"] = [NSString stringWithFormat:@"%ld",kUserInfo.uid];
    param[@"key"] = kUserInfo.token;
    param[@"currency_mark"] = currency_mark;
    param[@"to_currency_mark"] = @"AT";
    param[@"pwd"] = pwd;
    param[@"actual_num"] = actual_num;
    NSLog(@"------------%@",param);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:mine_myasset_bi_to_bi] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [self showTips:[responseObj ksObjectForKey:kMessage]];
        [self.tableview.mj_header beginRefreshing];
        kHideHud;
    }];
    
}

/**
 兑换记录
 */
- (void)exchangeRecord{
    BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@/currency_id/%@?ts=%@",kBasePath,icon_exchange_record,self.current_id,[Utilities dataChangeUTC]]];
    kNavPush(vc);
}

- (void)moreRecord{
    BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@/currency_id/%@?ts=%@",kBasePath,icon_history_record,self.current_id,[Utilities dataChangeUTC]]];
    kNavPush(vc);
}

- (IBAction)exchangeAction:(id)sender {
    HBMyAssetExchangeController *vc = [HBMyAssetExchangeController new];
    vc.model = self.model;
    kNavPush(vc);
}

- (void)sellIn{
    BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@/currency_id/%@?ts=%@",kBasePath,icon_history_in,self.current_id,[Utilities dataChangeUTC]]];
    kNavPush(vc);
}

- (void)sellOut{
    BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@/currency_id/%@?ts=%@",kBasePath,icon_history_out,self.current_id,[Utilities dataChangeUTC]]];
    kNavPush(vc);
}

#pragma mark- tableviewDelegateAndDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyassetDetailItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyassetDetailItemTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:60.0f];
    cell.delegate = self;
    user_order *model = [self.list objectAtIndex:indexPath.row];
    [cell refreshWithModel:model];
    cell.contentView.tag = indexPath.row;
    return cell;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:kColorFromStr(@"#E43041") title:@"删除"];
    return rightUtilityButtons;
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    kLOG(@"删除动作");
    _index = cell.contentView.tag;
    user_order *model = [self.list objectAtIndex:_index];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"sign"] = [Utilities handleParamsWithDic:param];
    param[@"uuid"] = [Utilities randomUUID];
    param[@"token_id"] = [NSString stringWithFormat:@"%ld",kUserInfo.uid];
    param[@"token"] = kUserInfo.token;
    param[@"order_id"] = model.orders_id;
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:mine_myasset_cancel] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            [self showTips:@"删除成功"];
            NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
            NSString *lang = nil;
            if ([currentLanguage containsString:@"en"]) {//英文
                lang = @"en-us";
            }else if ([currentLanguage containsString:@"Hant"]){//繁体
                lang = @"zh-tw";
            }else{//简体
                lang = @"cn";
            }
            self.api  = [[GetAssetDetailApi alloc]initWithKey:kUserInfo.token lanage:lang token_id:[NSString stringWithFormat:@"%ld",kUserInfo.uid] currency_id:self.current_id];
            self.api.delegate = self;
            [self.api refresh];
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 0.01;
    }else{
        return 0.01;
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
        return nil;
    }else{
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return nil;
    }else{
        return nil;
    }
}


- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    //    [self showTips:command.response.msg];
    [self.tableview.mj_footer resetNoMoreData];
    [self.tableview.mj_header endRefreshing];
    [self.view hideToastActivity];
    self.model = responsObject;
    [UIView animateWithDuration:0.2 animations:^{
        self.exchangeButton.hidden = (self.model.currency.exchange_switch != 1);
    }];
    
    NSLog(@"------------%@",responsObject);
    
    NSLog(@"------%@",self.model.currency);
//    self.head.tradeCount.text = self.model.allmoneys;
//    NSLog(@"%@",self.model.sum);
    //    sumModel *model = [sumModel mj_objectWithKeyValues:self.model.sum];
//    NSLog(@"%@",self.model.sum.usd);
//    self.head.tradeDetail.text = [NSString stringWithFormat:@"≈%@USD",self.model.sum.usd];
    self.head.typeLabel.text = self.model.currency.currency_name;
    self.head.p1label.text = self.model.currency_user.num;
    self.head.p3label.text = self.model.currency_user.forzen_num;
    self.head.rblabel.text = self.model.currency_user.lock_num;
    NSArray *array = self.model.user_orders;
    NSLog(@"%@",self.list);
    [self.list removeAllObjects];
    [self.list addObjectsFromArray:array];
    NSLog(@"%@",self.list);
    //        self.header.label2.text =[NSString stringWithFormat:@"(%@)%@",self.model.count,kLocat(@"k_MyrecommendViewController_top_label_5")];
    if ([self.model.currency.release_switch isEqualToString:@"1"]) {
        [self addRightBarButtonItemWithTitle1:kLocat(@"kcurrentuantity_release_record") action:@selector(recordList)];
    }
    [self.tableview reloadData];
    //    }
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    
    [self.tableview.mj_header endRefreshing];
    [self.view hideToastActivity];
    [self.tableview.mj_header endRefreshing];
    if (self.list.count <= 0) {
        //        [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"empty"] explain:kLocat(@"empty_msg") operationText:kLocat(@"empty_refre") operationBlock:^{
        //            [self.tableview.mj_header beginRefreshing];
        //        }];
    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    ListModel *model = [self.infoList objectAtIndex:indexPath.row];
//    BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@/%@",kBasePath,icon_info_currency,model.currency_id]];
//    //                vc.showNaviBar = YES;
//    kNavPush(vc);
//}

- (void)api:(BaseApi *)api loadMoreSuccessWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [self showTips:command.response.msg];
    [self.view hideToastActivity];
    [self.tableview.mj_footer endRefreshing];
    YTMyassetDetailModel *model = responsObject;
    NSArray *arr = [user_order mj_objectArrayWithKeyValuesArray:model.user_orders];
    [self.list addObjectsFromArray:arr];
    [self.tableview reloadData];
}

- (void)api:(BaseApi *)api loadMoreFailedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [self.tableview.mj_footer endRefreshing];
    [self.view hideToastActivity];
    [self showTips:command.response.msg];
}

- (void)api:(BaseApi *)api loadMoreEndWithCommand:(ApiCommand *)command {
    [self.view hideToastActivity];
    //    [self.tableview.mj_footer endRefreshingWithNoMoreData];
}

@end
