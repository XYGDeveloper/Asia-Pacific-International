//
//  BindTeleViewController.m
//  YJOTC
//
//  Created by l on 2018/10/9.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "BindTeleViewController.h"

@interface BindTeleViewController ()
@property (weak, nonatomic) IBOutlet UILabel *stepleft;
@property (weak, nonatomic) IBOutlet UILabel *stepright;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightlabel;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *valcode;
@property (weak, nonatomic) IBOutlet UIButton *valbtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation BindTeleViewController


- (IBAction)getValcode:(id)sender {
    
    if (self.phone.text.length <= 0) {
        [self showTips:@"请输入手机号"];
        return;
    }
    [self startTimer];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone"] = self.phone.text;
    param[@"sign"] = [Utilities handleParamsWithDic:param];
    param[@"uuid"] = [Utilities randomUUID];
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kSenderSMS] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            kLOG(@"验证码：%@",[responseObj ksObjectForKey:kData]);
            [self showTips:LocalizedString(@"LCodeSendSuccess")];
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
    
}

- (void)startTimer{
    __block int timeout=59;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.valbtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                self.valbtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.valbtn setTitle:[NSString stringWithFormat:@"重新获取%@秒",strTime] forState:UIControlStateNormal];
                self.valbtn.titleLabel.font = HiraginoSans(12);
                self.valbtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


- (IBAction)commitAction:(id)sender {
    
    //提交
    if (self.phone.text.length <= 0) {
        [self showTips:@"请输入手机号"];
        return;
    }
    if (self.valcode.text.length <= 0) {
        [self showTips:@"请输入验证码"];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"phone"] = self.phone.text;
    param[@"phone_code"] = self.valcode.text;
    param[@"sign"] = [Utilities handleParamsWithDic:param];
    param[@"uuid"] = [Utilities randomUUID];
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Set/phoneBinding"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            [self showTips:@"绑定手机号成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                kNavPop;
            });
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = kLocat(@"k_BindphonesetViewController_title");
    self.stepleft.layer.cornerRadius = 15/2;
    self.stepleft.layer.masksToBounds = YES;
    self.stepright.layer.cornerRadius = 15/2;
    self.stepright.layer.masksToBounds = YES;

    self.phone.placeholder = kLocat(@"k_BindphonesetViewController_t1");
    self.valcode.placeholder = kLocat(@"k_BindphoneViewController_t2");
    self.leftLabel.text = kLocat(@"k_BindphoneViewController_t3");
    self.rightlabel.text = kLocat(@"k_BindphoneViewController_t4");
    self.commitBtn.layer.cornerRadius = 8;
    self.commitBtn.layer.masksToBounds = YES;
    [self.commitBtn setTitle:kLocat(@"k_ModifysetViewController_b1") forState:UIControlStateNormal];
    [self.valbtn setTitle:kLocat(@"k_BindphoneViewController_b0") forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view from its nib.
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
