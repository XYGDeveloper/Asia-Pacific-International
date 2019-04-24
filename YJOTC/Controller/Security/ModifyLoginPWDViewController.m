//
//  ModifyLoginPWDViewController.m
//  YJOTC
//
//  Created by l on 2018/10/9.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "ModifyLoginPWDViewController.h"

@interface ModifyLoginPWDViewController ()

@property (weak, nonatomic) IBOutlet UITextField *oldPWD;

@property (weak, nonatomic) IBOutlet UITextField *modiPwd;

@property (weak, nonatomic) IBOutlet UITextField *surePWD;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation ModifyLoginPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"k_ModifyLoginsetViewController_title");

    self.commitBtn.layer.cornerRadius = 8;
    self.commitBtn.layer.masksToBounds = YES;
    self.oldPWD.placeholder = kLocat(@"k_ModifyLoginsetViewController_t1");
    self.modiPwd.placeholder = kLocat(@"k_ModifyLoginViewController_t2");
    self.surePWD.placeholder = kLocat(@"k_ModifyLoginViewController_t3");
    [self.commitBtn setTitle:kLocat(@"k_ModifyLoginViewController_b1") forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)commitAction:(id)sender {
    
    //提交
    if (self.oldPWD.text.length <= 0) {
        [self showTips:@"请输入原始登录密码"];
        return;
    }
    if (self.modiPwd.text.length <= 0) {
        [self showTips:@"请设置新登录密码"];
        return;
    }
    if (self.surePWD.text.length <= 0) {
        [self showTips:@"请输入确认新登录密码"];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"oldpwd"] = self.oldPWD.text;
    param[@"pwd"] = self.modiPwd.text;
    param[@"repwd"] = self.surePWD.text;
    param[@"sign"] = [Utilities handleParamsWithDic:param];
    param[@"uuid"] = [Utilities randomUUID];
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Set/updatePassword"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            [self showTips:@"修改成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                kNavPop;
            });
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
    
    
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
