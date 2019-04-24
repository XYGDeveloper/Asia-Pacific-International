//
//  C2CViewController.m
//  YJOTC
//
//  Created by l on 2018/9/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "C2CViewController.h"
#import "DVSwitch.h"
#import "C2CHeaderTableViewCell.h"
#import "BCBitemTableViewCell.h"
#import "UILabel+HeightLabel.h"
#import "YBPopupMenu.h"
#import "C2CPaymodeViewController.h"
#import "AddPayViewController.h"
#import "C2cModel.h"
#import "TOActionSheet.h"
#import "PayModel.h"
#import "Masonry.h"
#import "PayMethodViewController.h"
#import "STPopupController.h"
#import "HClActionSheet.h"
#import "HMSegmentedControl+HB.h"
#import "NSObject+SVProgressHUD.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface C2CViewController ()<UITableViewDelegate,UITableViewDataSource,YBPopupMenuDelegate,PayMethodSelectionViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) DVSwitch *switcher;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel *TypeLabel;
@property (strong, nonatomic) UITextField *sellInpriceField;
@property (strong, nonatomic) UITextField *sellIncountField;
@property (strong, nonatomic) UIView *caculateView;
@property (strong, nonatomic) UILabel *caculatedes;
@property (strong, nonatomic) UILabel *caculateCount;
@property (strong, nonatomic) UIView *caculateButtonView;
@property (strong, nonatomic) UIButton *caculateButton;
@property (strong, nonatomic) C2CHeaderTableViewCell *head;
@property (strong, nonatomic) UILabel *footer;
@property (strong, nonatomic) UILabel *leftLabelView;
@property (strong, nonatomic) UILabel *leftCountLabelView;
@property (strong, nonatomic) NSArray *buyModels;
@property (strong, nonatomic) NSArray *sellModels;
@property (strong, nonatomic) C2cModel *model;
@property (nonatomic,assign)NSUInteger indexs;
@property (nonatomic)UILabel *payWayLabel;
@property (nonatomic, strong) HClActionSheet *selectbank;
@property (nonatomic, strong) PayModel *models;
@property (nonatomic, strong) NSString *payment;
@property (nonatomic, strong) NSString *pay_type;

@property (nonatomic, strong) NSArray *pays;

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (nonatomic,strong)NSArray<c2c_configModel *> *c2cConfigModels;
@property (nonatomic, strong) c2c_configModel *selectedConfigModel;

@property (nonatomic, strong) UILabel *introductionLabel;
@property (nonatomic, strong) UIView *footView;

@end

@implementation C2CViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self toGetPays];
}

- (void)loaddata{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"key"] = kUserInfo.token;
    param[@"sign"] = [Utilities handleParamsWithDic:param];
    param[@"uuid"] = [Utilities randomUUID];
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Entrust/Ctrade"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        if (error) {
            [self showInfoWithMessage:error.localizedDescription];
            return ;
        }
        kHideHud;
        if (success) {
            self.model = [C2cModel mj_objectWithKeyValues:[responseObj ksObjectForKey:kData]];
            self.c2cConfigModels = self.model.c2c_config_all;
//            self.sellInpriceField.text = self.model.c2c_config.buy_price;
            [self.tableview reloadData];
        }else{
            [self showInfoWithMessage:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loaddata];
    self.indexs = 0;
    self.title = kLocat(@"k_meViewcontroler_s2_2");
    [self addRightBarButtonWithFirstImage:[UIImage imageNamed:@"accounter_more"] action:@selector(menuPop:)];
    [self layOutsubs];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    self.tableview.backgroundColor = kRGBA(244, 244, 244, 1);
    self.view.backgroundColor = kRGBA(244, 244, 244, 1);
    self.tableview.separatorColor = kRGBA(244, 244, 244, 1);
//    [self.Tableview registerNib:[UINib nibWithNibName:@"MyAsetTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyAsetTableViewCell class])];
    self.tableview.showsVerticalScrollIndicator = NO;
    [self.tableview registerNib:[UINib nibWithNibName:@"BCBitemTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([BCBitemTableViewCell class])];
    UIView *footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 300)];
    footview.backgroundColor = kRGBA(244, 244, 244, 1);
    self.tableview.tableFooterView = footview;

    UILabel *label =  [[UILabel alloc]init];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:12];
//    label.text = kLocat(@"k_bcbViewController_des");
    label.textColor = kColorFromStr(@"#AAAAAA");
    [footview addSubview:label];
    self.introductionLabel = label;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
}

-(void)menuPop:(UIButton *)button{
    
    CGPoint point = CGPointMake(button.superview.superview.superview.right-button.width/2, kNavigationBarHeight);
    
    [YBPopupMenu showAtPoint:point titles:[NSMutableArray arrayWithObjects:kLocat(@"k_popview_1"),kLocat(@"k_popview_2"),kLocat(@"k_popview_3"),kLocat(@"k_popview_4"), nil] icons:[NSMutableArray arrayWithObjects:@"accounter_paymode.png",@"accounter_addpaymode.png",@"accounter_card.png",@"accounter_desc.png", nil] menuWidth:185 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.fontSize = 14;
        popupMenu.textColor = kWhiteColor;
        popupMenu.delegate = self;
        popupMenu.backColor = [kBlackColor colorWithAlphaComponent:0.8];
//        popupMenu.tag = button.tag;
        popupMenu.itemHeight = 42;
        popupMenu.borderWidth = 0;
    }];
    
}




-(void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    if (index == 0) {
        kNavPush([C2CPaymodeViewController new]);
    }else if (index == 1){
        kNavPush([AddPayViewController new]);
    }else if (index == 2){
        BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@?ts=%@",kBasePath,exchange_record,[Utilities dataChangeUTC]]];
        kNavPush(vc);
    }else{
         BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@?ts=%@",kBasePath,operation_des,[Utilities dataChangeUTC]]];
        kNavPush(vc);
    }
    
}

- (void)layOutsubs{
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 197+45+91)];
    self.tableview.tableHeaderView = self.contentView;
    
    
    [self.contentView addSubview:self.segmentedControl];
    self.segmentedControl.frame = CGRectMake(0, 0, kScreenW, 45);
    self.segmentedControl.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 46., kScreenW, 1.)];
    lineView.backgroundColor = kColorFromStr(@"#F4F4F4");
    [self.contentView addSubview:lineView];
    
    UIView *switcherContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.segmentedControl.bottom + 1, kScreenW, 50)];
    switcherContainerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:switcherContainerView];
    self.switcher = [[DVSwitch alloc] initWithStringsArray:@[kLocat(@"k_bcbViewController_sellin"), kLocat(@"k_bcbViewController_sellout")]];
    self.switcher.backgroundColor = [UIColor whiteColor];
    self.switcher.sliderColor = kColorFromStr(@"#896FED");
    self.switcher.labelTextColorInsideSlider = [UIColor whiteColor];
    self.switcher.labelTextColorOutsideSlider = kColorFromStr(@"#999999");
    self.switcher.layer.cornerRadius = 26/2;
    self.switcher.layer.masksToBounds = YES;
    self.switcher.layer.borderWidth = 1;
    self.switcher.layer.borderColor = kColorFromStr(@"#896FED").CGColor;
    self.switcher.frame = CGRectMake(100, 12,kScreenW - 100*2, 25);
    [switcherContainerView addSubview:self.switcher];
    [self.switcher selectIndex:0 animated:YES];
    
    __weak typeof(self) weakSelf = self;
    [self.switcher setPressedHandler:^(NSUInteger index) {
        NSLog(@"--------%lu",(unsigned long)index);
        if (index == 0) {
            weakSelf.indexs = index;
            weakSelf.sellInpriceField.text = weakSelf.selectedConfigModel.buy_price;
            weakSelf.sellIncountField.placeholder = kLocat(@"k_c2c_buycount");
            [weakSelf.caculateButton setTitle:kLocat(@"k_c2c_now_startbuy") forState:UIControlStateNormal];
//            self.caculateButton.titleLabel.text = kLocat(@"k_c2c_now_startbuy");
            weakSelf.leftLabelView.text = kLocat(@"k_c2c_buyp");
            weakSelf.leftCountLabelView.text  = [NSString stringWithFormat:@"%@(%@)", kLocat(@"k_c2c_buycount"), weakSelf.selectedConfigModel.currency_mark ?: @""];
            weakSelf.sellIncountField.text = @"";
            [weakSelf.tableview reloadData];
            weakSelf.caculatedes.text = kLocat(@"k_c2c_needt");
            
        }else{
            
            weakSelf.caculatedes.text = kLocat(@"k_c2c_acquire");
            weakSelf.indexs = index;
            weakSelf.sellInpriceField.text = weakSelf.selectedConfigModel.sell_price;
            weakSelf.sellIncountField.placeholder =kLocat(@"k_c2c_sellcount");
            [weakSelf.caculateButton setTitle:kLocat(@"k_c2c_now_startsell") forState:UIControlStateNormal];

//            self.caculateButton.titleLabel.text = kLocat(@"k_c2c_now_startsell");
            weakSelf.leftLabelView.text = kLocat(@"k_c2c_sellp");
            weakSelf.leftCountLabelView.text  = [NSString stringWithFormat:@"%@(%@)", kLocat(@"k_c2c_sellcount"), weakSelf.selectedConfigModel.currency_mark ?: @""];
            weakSelf.sellIncountField.text = @"";
            [weakSelf.tableview reloadData];
        
        }
        NSLog(@"Did press position on first switch at index: %lu", (unsigned long)index);
    }];
    
//    self.TypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.switcher.frame)+15, kScreenW, 40) text:[NSString stringWithFormat:@"AT%@",kLocat(@"k_c2c_now_trade")] font:[UIFont systemFontOfSize:14.0F] textColor:kColorFromStr(@"#896FED") textAlignment:NSTextAlignmentCenter adjustsFont:YES];
//    self.TypeLabel.backgroundColor = [UIColor whiteColor];
//    [self.contentView addSubview:self.TypeLabel];
    
    self.sellInpriceField = [[UITextField alloc]initWithFrame:CGRectMake(20, switcherContainerView.bottom + 5, kScreenW-40, 45)];
    self.sellInpriceField.textAlignment = NSTextAlignmentRight;
    self.sellInpriceField.userInteractionEnabled = NO;
    self.sellInpriceField.leftViewMode=UITextFieldViewModeAlways;
    self.sellInpriceField.textColor = kColorFromStr(@"#999999");
    self.sellInpriceField.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.sellInpriceField];
    self.leftLabelView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    self.leftLabelView .text  =kLocat(@"k_c2c_buyp");
    self.leftLabelView.font = [UIFont systemFontOfSize:14];
    self.leftLabelView.textColor = kColorFromStr(@"#666666");
    self.sellInpriceField.leftView = self.leftLabelView;
    UIView *textFieldSeparateLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.sellInpriceField.bottom, kScreenW, 5)];
    textFieldSeparateLineView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:textFieldSeparateLineView];
    self.sellIncountField = [[UITextField alloc]initWithFrame:CGRectMake(20, textFieldSeparateLineView.bottom, kScreenW-40, 45)];
    self.sellIncountField.placeholder = kLocat(@"k_c2c_buycount");
    self.sellIncountField.keyboardType = UIKeyboardTypeNumberPad;

    [self.sellIncountField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.sellIncountField.leftViewMode=UITextFieldViewModeAlways;
    self.leftCountLabelView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    self.leftCountLabelView.text  =kLocat(@"k_c2c_buycount");
    self.leftCountLabelView.font = [UIFont systemFontOfSize:14];
    self.leftCountLabelView.textColor = kColorFromStr(@"#666666");
    self.leftCountLabelView.textAlignment = NSTextAlignmentLeft;
    self.sellIncountField.leftView = self.leftCountLabelView;
    self.sellIncountField.textAlignment = NSTextAlignmentRight;
    self.sellIncountField.textColor = kColorFromStr(@"#999999");
    self.sellIncountField.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.sellIncountField];
    
    self.caculateView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.sellIncountField.frame)+5, kScreenW, 45)];
    self.caculateView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.caculateView];
    
    self.caculatedes = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, (kScreenW-40)/2, 45) text:kLocat(@"k_c2c_needt") font:[UIFont systemFontOfSize:14.0f] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft adjustsFont:YES];
    [self.caculateView addSubview:self.caculatedes];
    self.caculateCount = [[UILabel alloc]initWithFrame:CGRectMake(20+(kScreenW-40)/2, 0, (kScreenW-40)/2, 45) text:@"       CNY" font:[UIFont systemFontOfSize:14.0f] textColor:[UIColor redColor] textAlignment:NSTextAlignmentRight adjustsFont:YES];
    self.caculateCount.textColor = [UIColor redColor];
    [self.caculateView addSubview:self.caculateCount];
    
    self.caculateButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, self.caculateView.bottom, kScreenW, 69)];
    self.caculateButtonView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.caculateButtonView];
    self.caculateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.caculateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (self.indexs == 0) {
        [self.caculateButton setTitle:kLocat(@"k_c2c_now_startbuy") forState:UIControlStateNormal];
    }else{
        [self.caculateButton setTitle:kLocat(@"k_c2c_now_startbuy") forState:UIControlStateNormal];
    }
    
    [self.caculateButton addTarget:self action:@selector(tobuy) forControlEvents:UIControlEventTouchUpInside];
    [self.caculateButtonView addSubview:self.caculateButton];
    self.caculateButton.frame = CGRectMake(12, 12, kScreenW - 12 * 2, 45);
    self.caculateButton.layer.cornerRadius = 8;
    self.caculateButton.backgroundColor = kColorFromStr(@"#896FED");
    
    self.head =  [[[NSBundle mainBundle] loadNibNamed:@"C2CHeaderTableViewCell" owner:nil options:nil] lastObject];
    self.head.frame = CGRectMake(0, CGRectGetMaxY(self.caculateButtonView.frame) + 5, kScreenW, 35);
    [self.contentView addSubview:self.head];
    self.contentView.height = self.head.bottom;
}

- (void)tobuy{
    
    [self.sellIncountField resignFirstResponder];
    [self toGetPays];
    [self addpaymode];
   
}

- (void)toGetPays{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"key"] = kUserInfo.token;
    param[@"sign"] = [Utilities handleParamsWithDic:param];
    param[@"uuid"] = [Utilities randomUUID];
    __weak typeof(self)weakSelf = self;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Entrust/get_bank"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        NSLog(@"%@",responseObj);
        if (success) {
            PayModel *model = [PayModel mj_objectWithKeyValues:[responseObj ksObjectForKey:kData]];
            self.models = model;
            if (model.member_bank.count <= 0 && model.member_alipay.count <= 0 && model.member_wechat.count <= 0) {
//                TOActionSheet *actionSheet = [[TOActionSheet alloc] init];
//                actionSheet.title = kLocat(@"k_c2c_now_sel_pay");
//                actionSheet.contentstyle = TOActionSheetContentStyleDefault;
//                [actionSheet addButtonWithTitle:kLocat(@"k_c2c_now_sel_add") icon:nil tappedBlock:^{
//                    kNavPush([AddPayViewController new]);
//                }];
//                actionSheet.actionSheetDismissedBlock = ^{
//                    NSLog(@"dissmiss");
//                };
//                [actionSheet showFromView:nil inView:self.view];
                
                [self showTips:@"请添加支付方式"];
                
            }else{
                
                NSMutableArray *arr = [NSMutableArray array];
                if (model.member_wechat.count >0) {
                    
                    [arr addObject:@"微信"];
                }
                
                if (model.member_alipay.count >0) {
                    [arr addObject:@"支付宝"];
                }
                
                if (model.member_bank.count >0) {
                    [arr addObject:@"银行卡"];
                }
                [arr addObject:kLocat(@"k_c2c_now_sel_add")];

//                self.selectbank = [[HClActionSheet alloc] initWithTitle:kLocat(@"k_c2c_now_sel_pay") style:HClSheetStyleWeiChat itemTitles:arr];
//                self.selectbank.delegate = self;
//                self.selectbank.tag = 50;
//                self.selectbank.titleTextColor = [UIColor blackColor];
//                self.selectbank.titleTextFont = [UIFont systemFontOfSize:14.0f];
//                self.selectbank.itemTextFont = [UIFont systemFontOfSize:16];
//                self.selectbank.itemTextColor = [UIColor grayColor];
//                self.selectbank.cancleTextFont = [UIFont systemFontOfSize:16];
//                self.selectbank.cancleTextColor = [UIColor grayColor];
//                
//                [self.selectbank didFinishSelectIndex:^(NSInteger index, NSString *title) {
//                    if([title isEqualToString:kLocat(@"k_c2c_now_sel_add")]){
//                        kNavPush([AddPayViewController new]);
//                    }else if ([title isEqualToString:@"微信"]) {
//                        WechatModel *wmodel = [model.member_wechat firstObject];
//                        self.payment = wmodel.id;
//                        self.pay_type = @"3";
////                        [self toPay];
//                    }else if([title isEqualToString:@"支付宝"]){
//                        AlipayModel *amodel = [model.member_alipay firstObject];
//                        self.payment = amodel.id;
//                        self.pay_type = @"2";
////                        [self toPay];
//                    }else{
//                        bankModel *bmodel = [model.member_bank firstObject];
//                        self.payment = bmodel.id;
//                        self.pay_type = @"1";
////                        [self toPay];
//                    }
//                }];
                
            }

            
        }else{
            [weakSelf showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}

- (void)addpaymode{
    if (self.sellIncountField.text.length <= 0) {
        [self showTips:@"请输入买入或卖出量"];
        return;
    }

    if (self.models.member_bank.count <= 0 && self.models.member_alipay.count <= 0 && self.models.member_wechat.count <= 0) {
        TOActionSheet *actionSheet = [[TOActionSheet alloc] init];
        actionSheet.title = kLocat(@"k_c2c_now_sel_pay");
        actionSheet.contentstyle = TOActionSheetContentStyleDefault;
        [actionSheet addButtonWithTitle:kLocat(@"k_c2c_now_sel_add") icon:nil tappedBlock:^{
            kNavPush([AddPayViewController new]);
        }];
        actionSheet.actionSheetDismissedBlock = ^{
            NSLog(@"dissmiss");
        };
        [actionSheet showFromView:nil inView:self.view];
        
    }else{
        
        NSMutableArray *arr = [NSMutableArray array];
        if (self.models.member_wechat.count >0) {
            [arr addObject:@"微信"];
        }
        
        if (self.models.member_alipay.count >0) {
            [arr addObject:@"支付宝"];
        }
        
        if (self.models.member_bank.count >0) {
            [arr addObject:@"银行卡"];
        }
        [arr addObject:kLocat(@"k_c2c_now_sel_add")];
        
        self.pays = arr;
        self.selectbank = [[HClActionSheet alloc] initWithTitle:kLocat(@"k_c2c_now_sel_pay") style:HClSheetStyleWeiChat itemTitles:arr];
        self.selectbank.delegate = self;
        self.selectbank.tag = 50;
        self.selectbank.titleTextColor = [UIColor blackColor];
        self.selectbank.titleTextFont = [UIFont systemFontOfSize:14.0f];
        self.selectbank.itemTextFont = [UIFont systemFontOfSize:16];
        self.selectbank.itemTextColor = [UIColor grayColor];
        self.selectbank.cancleTextFont = [UIFont systemFontOfSize:16];
        self.selectbank.cancleTextColor = [UIColor grayColor];
        
        [self.selectbank didFinishSelectIndex:^(NSInteger index, NSString *title) {
            if([title isEqualToString:kLocat(@"k_c2c_now_sel_add")]){
                kNavPush([AddPayViewController new]);
            }else if ([title isEqualToString:@"微信"]) {
                WechatModel *wmodel = [self.models.member_wechat firstObject];
                self.payment = wmodel.id;
                self.pay_type = @"3";
                [self toPay];
            }else if([title isEqualToString:@"支付宝"]){
                AlipayModel *wmodel = [self.models.member_alipay firstObject];
                self.payment = wmodel.id;
                self.pay_type = @"2";
                [self toPay];
                
            }else{
                bankModel *wmodel = [self.models.member_bank firstObject];
                self.payment = wmodel.id;
                self.pay_type = @"1";
                [self toPay];
            }
        }];
        
    }
  
}

- (void)toPay{
    if (self.indexs == 0) {
        kShowHud;
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"token_id"] = @(kUserInfo.uid);
        param[@"key"] = kUserInfo.token;
        param[@"sign"] = [Utilities handleParamsWithDic:param];
        param[@"uuid"] = [Utilities randomUUID];
        param[@"buyUnitPrice"] = self.selectedConfigModel.buy_price;
        param[@"buyNumber"] = self.sellIncountField.text;
        param[@"cuid"] = self.selectedConfigModel.currency_id;
        param[@"payment"] = self.payment;
        param[@"pay_type"] = self.pay_type;
        
        __weak typeof(self)weakSelf = self;
        NSLog(@"%@",param);
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Api/Entrust/addOrderBuy"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            NSLog(@"%@",responseObj);
            kHideHud;
            if (success) {
                self.sellIncountField.text = nil;
                [weakSelf showTips:[responseObj ksObjectForKey:kMessage]];

            }else{
                [weakSelf showTips:[responseObj ksObjectForKey:kMessage]];
            }
        }];
    }else{
        kShowHud;
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"token_id"] = @(kUserInfo.uid);
        param[@"key"] = kUserInfo.token;
        param[@"sign"] = [Utilities handleParamsWithDic:param];
        param[@"uuid"] = [Utilities randomUUID];
        param[@"sellUnitPrice"] = self.selectedConfigModel.buy_price;
        param[@"sellNumber"] = self.sellIncountField.text;
        param[@"cuid"] = self.selectedConfigModel.currency_id;
        param[@"payment"] = self.payment;
        param[@"pay_type"] = self.pay_type ?: @"";
        NSLog(@"%@",param);
        __weak typeof(self)weakSelf = self;
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Entrust/addOrderSell"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            if (error) {
                [weakSelf showTips:error.localizedDescription];
                return ;
            }
            NSLog(@"%@",responseObj);
            kHideHud;
            if (success) {
                [weakSelf showTips:[responseObj ksObjectForKey:kMessage]];
            }else{
                [weakSelf showTips:[responseObj ksObjectForKey:kMessage]];
            }
        }];
    }
}


-(void)textFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    if ([theTextField.text isEqualToString:@""]) {
        self.caculateCount.text = @"CNY";
    }else{
      NSString *str0 = [NSString stringWithFormat:@"%fCNY",[self.sellInpriceField.text floatValue]*[self.sellIncountField.text floatValue]];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:str0];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(str0.length-3,3)];
        self.caculateCount.attributedText = str;
    }
}

#pragma mark- layOutsubviews


#pragma mark- TableviewDelegateAndDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.indexs == 1) {
        return self.model.order_sell.count;
    }else{
        return self.model.order_buy.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BCBitemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCBitemTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.indexs == 1) {
        order_sellModel *model = [self.model.order_sell objectAtIndex:indexPath.row];
        [cell refreshWithModel:model];
    }else{
        order_buyModel *model = [self.model.order_buy objectAtIndex:indexPath.row];
        [cell refreshWithModel1:model];
    }
    return cell;
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

#pragma mark - Setters && Getters

- (void)setC2cConfigModels:(NSArray<c2c_configModel *> *)c2cConfigModels {
    _c2cConfigModels = c2cConfigModels;
    
    if (!self.selectedConfigModel) {
        self.selectedConfigModel = c2cConfigModels.firstObject;
    }
    NSMutableArray<NSString *> *titles = @[].mutableCopy;
    [c2cConfigModels enumerateObjectsUsingBlock:^(c2c_configModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [titles addObject:obj.currency_mark ?:@""];
    }];
    
    self.segmentedControl.sectionTitles = titles.copy;
    
}

- (void)setSelectedConfigModel:(c2c_configModel *)selectedConfigModel {
    _selectedConfigModel = selectedConfigModel;
    [self.switcher selectIndex:0 animated:NO];
    self.sellInpriceField.text = self.selectedConfigModel.buy_price;
//    self.tipsLabel.attributedText = [self getFormatteStringWithPathy:self.selectedConfigModel.c2c_introduc];
    
    self.TypeLabel.text = [NSString stringWithFormat:@"%@%@",self.selectedConfigModel.currency_mark,kLocat(@"k_c2c_now_trade")];
    if (selectedConfigModel.currency_mark) {
        self.leftCountLabelView.text = [NSString stringWithFormat:@"%@(%@)", kLocat(@"k_c2c_buycount"), selectedConfigModel.currency_mark];
    }
    [self _updateIntroductionLabel];
}


- (void)_updateIntroductionLabel {
    self.introductionLabel.text = self.selectedConfigModel.c2c_introduc;
    [UILabel changeLineSpaceForLabel:self.introductionLabel WithSpace:8];
    self.tableview.tableFooterView.height = self.introductionLabel.height + 40;
}


- (HMSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [HMSegmentedControl createSegmentedControl];
        _segmentedControl.backgroundColor = [UIColor clearColor];
        __weak typeof(self) weakSelf = self;
        _segmentedControl.indexChangeBlock = ^(NSInteger index) {
            if (index < weakSelf.c2cConfigModels.count) {
                weakSelf.selectedConfigModel = weakSelf.c2cConfigModels[index];
            }
//            [weakSelf _hideSelectPayModeView];
        };
    }
    
    return _segmentedControl;
}

@end
