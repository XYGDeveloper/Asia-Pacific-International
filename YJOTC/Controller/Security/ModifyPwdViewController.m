//
//  ModifyPwdViewController.m
//  YJOTC
//
//  Created by l on 2018/10/9.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "ModifyPwdViewController.h"

@interface ModifyPwdViewController ()

@property (weak, nonatomic) IBOutlet UITextField *oldPwd;

@property (weak, nonatomic) IBOutlet UITextField *cuPwd;

@property (weak, nonatomic) IBOutlet UITextField *conPwd;

@property (weak, nonatomic) IBOutlet UIButton *comBtn;

@end

@implementation ModifyPwdViewController


- (IBAction)commitAction:(id)sender {
    //提交
    if (self.oldPwd.text.length <= 0) {
        [self showTips:@"请输入原始密码"];
        return;
    }
    if (self.cuPwd.text.length <= 0) {
        [self showTips:@"请输入新密码"];
        return;
    }
    if (self.conPwd.text.length <= 0) {
        [self showTips:@"请输入确认密码"];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"oldpwd_b"] = self.oldPwd.text;
    param[@"pwdtrade"] = self.cuPwd.text;
    param[@"repwdtrade"] = self.conPwd.text;
    param[@"sign"] = [Utilities handleParamsWithDic:param];
    param[@"uuid"] = [Utilities randomUUID];
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Set/updatePwdtrade"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            [self showTips:@"修改交易密码已提交，正在审核中"];
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
    self.title = kLocat(@"k_ModifysetViewController_title");
    self.comBtn.layer.cornerRadius = 8;
    self.comBtn.layer.masksToBounds = YES;
    self.oldPwd.placeholder = kLocat(@"k_ModifysetViewController_t1");
    self.cuPwd.placeholder = kLocat(@"k_ModifysetViewController_t2");
    self.conPwd.placeholder = kLocat(@"k_ModifysetViewController_t3");
    [self.comBtn setTitle:kLocat(@"k_ModifysetViewController_b1") forState:UIControlStateNormal];
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
