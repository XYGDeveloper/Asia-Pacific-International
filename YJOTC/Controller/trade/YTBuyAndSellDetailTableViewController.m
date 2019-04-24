//
//  YTBuyAndSellDetailTableViewController.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTBuyAndSellDetailTableViewController.h"
#import "YTTradeRequest.h"
#import "YTData_listModel.h"
#import "YTTradeModel.h"
#import "YTTradeIndexModel.h"
#import "YTSellTrendingContaineeViewController.h"
#import "YTLatestDealContaineeTableViewController.h"
#import "YTTradeIndexModel.h"
#import "NSString+RemoveZero.h"

@interface YTBuyAndSellDetailTableViewController ()

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *calculateContainerViews;
@property (weak, nonatomic) IBOutlet UIButton *buyOrSellButton;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UILabel *currencyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *availableNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *availabeNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *forzenNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *forzenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *latestDealLabel;
@property (weak, nonatomic) IBOutlet UIView *circleView;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIStackView *loginStackView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;


@property (nonatomic, assign) BOOL isTypeOfBuy;

@property (nonatomic, strong) YTSellTrendingContaineeViewController *sellTrendingContaineeVC;
@property (nonatomic, strong) YTSellTrendingContaineeViewController *buyTrendingContaineeVC;
@property (nonatomic, strong) YTLatestDealContaineeTableViewController *latestDealContaineeVC;

@end

@implementation YTBuyAndSellDetailTableViewController

+ (instancetype)buyDetailTableViewController {
    YTBuyAndSellDetailTableViewController *vc = [self fromStoryboard];
    vc.isTypeOfBuy = YES;
    return vc;
}

+ (instancetype)sellDetailTableViewController {
    YTBuyAndSellDetailTableViewController *vc = [self fromStoryboard];
    vc.isTypeOfBuy = NO;
    return vc;
}

+ (instancetype)fromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Trade" bundle:nil] instantiateViewControllerWithIdentifier:@"YTBuyAndSellDetailTableViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setupUI];
    [self _updateUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self _updateOperateButton];
}


#pragma mark - UITableDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        return [YTLatestDealContaineeTableViewController getHeightWithModels:self.tradeIndexs.trade_list];
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

#pragma mark - Public

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
}

#pragma mark - Private

- (void)_updateOperateButton {
    BOOL isExpired = [Utilities isExpired];
    self.loginStackView.hidden = !isExpired;
    self.buyOrSellButton.hidden = isExpired;
}

- (void)_setupUI {
    [self.calculateContainerViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.layer.borderWidth = 1.;
        obj.layer.borderColor = kColorFromStr(@"#CCCCCC").CGColor;
    }];
    
    self.buyOrSellButton.layer.cornerRadius = 8.;
    
    NSString *buttonTitle = self.isTypeOfBuy ? kLocat(@"Buy_immediately") : kLocat(@"Sell_immediately");
    [self.buyOrSellButton setTitle:buttonTitle forState:UIControlStateNormal];
    
    UIColor *themeColor = self.isTypeOfBuy ? kGreenColor : kOrangeColor;
    
    self.buyOrSellButton.backgroundColor = themeColor;
    self.priceTextField.textColor = themeColor;
    self.numberTextField.textColor = themeColor;
    self.circleView.backgroundColor = themeColor;
    
    self.currencyNameLabel.text = @"BTC";
    
    self.totalNameLabel.text = kLocat(@"k_YTBuyAndSellDetailTableViewController_total_prouct");
    self.availabeNameLabel.text = kLocat(@"k_YTBuyAndSellDetailTableViewController_integral_amount");
    self.forzenNameLabel.text = kLocat(@"k_YTBuyAndSellDetailTableViewController_integral_freezing");
    self.latestDealLabel.text = kLocat(@"k_YTBuyAndSellDetailTableViewController_latest_deal");
    
    self.numberTextField.placeholder = kLocat(@"Number");
    self.passwordTextField.placeholder = kLocat(@"Trade_code");
    self.priceTextField.placeholder = self.isTypeOfBuy ? kLocat(@"Buy_price") : kLocat(@"Sell_price");
    
    self.timeLabel.text = kLocat(@"Time");
    self.typeLabel.text = kLocat(@"Type");
    self.tradePriceLabel.text = kLocat(@"Trade_price");
    self.tradeNumberLabel.text = kLocat(@"Trade_volume");
    self.totalLabel.text = kLocat(@"Total");
    [self.loginButton setTitle:kLocat(@"LLogin") forState:UIControlStateNormal];
    [self.registerButton setTitle:kLocat(@"LRegister") forState:UIControlStateNormal];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.operateDoneBlock) {
            weakSelf.operateDoneBlock();
        }
    }];
    
    
}

- (void)_updateUI {
    self.totalNumberLabel.text = [_tradeModel.user_total _removeZeroOfDoubleString];
    self.availableNumberLabel.text = [_tradeModel.num _removeZeroOfDoubleString];
    self.forzenNumberLabel.text = [_tradeModel.forzen_num _removeZeroOfDoubleString];
}

#pragma mark - Actions

- (IBAction)loginAction:(id)sender {
    [self _gotoLoginVC];
}
- (IBAction)registerAction:(id)sender {
    [self _gotoRegisterVC];
}


- (IBAction)plusPriceAction:(id)sender {
    [self _add:@"1" textField:self.priceTextField];
}

- (IBAction)minusPriceAction:(id)sender {
    [self _add:@"-1" textField:self.priceTextField];
}

- (IBAction)plusNumberAction:(id)sender {
    [self _add:@"1" textField:self.numberTextField];
}

- (IBAction)minusNumberAction:(id)sender {
    [self _add:@"-1" textField:self.numberTextField];
}

- (void)_add:(NSString *)number textField:(UITextField *)textField {
    NSString *text = @"0";
    if (textField.text.length > 0) {
        text = textField.text;
    }
    
    NSDecimalNumber *textNumber = [NSDecimalNumber decimalNumberWithString:text];
    NSDecimalNumber *add = [NSDecimalNumber decimalNumberWithString:number];
    textNumber = [textNumber decimalNumberByAdding:add];
    if (textNumber.doubleValue < 0) {
        return;
    }
//    double value = [textField.text doubleValue];
//    value += number;
//    if (value < 0) {
//        return;
//    }
    
    textField.text = [NSString stringWithFormat:@"%@", textNumber];
}

- (void)_gotoLoginVC {
    ICNLoginViewController*vc = [[ICNLoginViewController alloc]init];
    [self presentViewController:[[YJBaseNavController alloc]initWithRootViewController:vc] animated:YES completion:nil];
}

-(void)_gotoRegisterVC
{
    ICNRegisterViewController *vc = [[ICNRegisterViewController alloc]init];
    [self presentViewController:[[YJBaseNavController alloc]initWithRootViewController:vc] animated:YES completion:nil];
}

- (IBAction)opreateAction:(id)sender {
    
    if ([Utilities isExpired]) {
        [self _gotoLoginVC];
        return;
    }
    
    NSString *price = self.priceTextField.text;
    NSString *number = self.numberTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if (price.length == 0) {
        NSString *msg = self.isTypeOfBuy ? kLocat(@"k_YTBuyAndSellDetailTableViewController_buyPriceCannotBeEmpty") : kLocat(@"k_YTBuyAndSellDetailTableViewController_sellPriceCannotBeEmpty");
        [self.view showWarning:msg];
        return;
    }
    
    if (number.length == 0) {
        NSString *msg = self.isTypeOfBuy ? kLocat(@"k_YTBuyAndSellDetailTableViewController_TheNumberOfBuyingCannotBeEmpty") : kLocat(@"k_YTBuyAndSellDetailTableViewController_TheNumberOfSellingCannotBeEmpty");
        [self.view showWarning:msg];
        return;
    }
    
    if (password.length == 0) {
        NSString *msg = kLocat(@"k_YTBuyAndSellDetailTableViewController_TransactionCannotBeEmpty");
        [self.view showWarning:msg];
        return;
    }
    kShowHud;
    [YTTradeRequest operateTradeWithCurrencyID:self.model.currency_id ?: @"52" isTypeOfBuy:self.isTypeOfBuy price:price number:number password:password success:^(YWNetworkResultModel * _Nonnull obj) {
        kHideHud;
        [self.view showWarning:obj.message];
        if ([obj succeeded]) {
            self.passwordTextField.text = nil;
            if (self.operateDoneBlock) {
                self.operateDoneBlock();
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        kHideHud;
        [self.view showWarning:error.localizedDescription];
    }];
    
}


#pragma mark - Setters & Getters

- (YTSellTrendingContaineeViewController *)sellTrendingContaineeVC {
    YTSellTrendingContaineeViewController *vc = self.childViewControllers[0];
    vc.isTypeOfBuy = NO;
    if (self.isTypeOfBuy) {
        __weak typeof(self) weakSelf = self;
        vc.didSelectCellBlock = ^(NSString *price) {
            weakSelf.priceTextField.text = [price _removeZeroOfDoubleString];
        };
    }
    return vc;
}

- (YTSellTrendingContaineeViewController *)buyTrendingContaineeVC {
    YTSellTrendingContaineeViewController *vc = self.childViewControllers[1];
    vc.isTypeOfBuy = YES;
    if (!self.isTypeOfBuy) {
        __weak typeof(self) weakSelf = self;
        vc.didSelectCellBlock = ^(NSString *price) {
            weakSelf.priceTextField.text = [price _removeZeroOfDoubleString];
        };
    }
    return vc;
}

- (YTLatestDealContaineeTableViewController *)latestDealContaineeVC {
    return self.childViewControllers[2];
}

- (void)setModel:(ListModel *)model {
    _model = model;
    
    self.currencyNameLabel.text = [_model.comcurrencyName stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    self.tradeModel = nil;
}

- (void)setTradeModel:(YTTradeModel *)tradeModel {
    _tradeModel = tradeModel;
    
    [self _updateUI];
}



- (void)setTradeIndexs:(YTTradeIndexModel *)tradeIndexs {
    _tradeIndexs = tradeIndexs;
    
    [self endRefresh];
    
    self.sellTrendingContaineeVC.models = _tradeIndexs.sell_list;
    self.buyTrendingContaineeVC.models = _tradeIndexs.buy_list;
    self.latestDealContaineeVC.models = _tradeIndexs.trade_list;
    
    [self.tableView reloadRow:4 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

@end
