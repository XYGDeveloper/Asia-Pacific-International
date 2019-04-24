//
//  BindMailViewController.m
//  YJOTC
//
//  Created by l on 2018/10/9.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "BindMailViewController.h"
#import "PooCodeView.h"

@interface BindMailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *stepleft;
@property (weak, nonatomic) IBOutlet UILabel *stepright;

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *vacode;
@property (weak, nonatomic) IBOutlet UIButton *comBtn;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, strong) PooCodeView *pooCodeView;

@end

@implementation BindMailViewController






- (IBAction)commitAction:(id)sender {
    
    if (self.email.text.length <= 0) {
        [self showTips:@"请输入邮箱"];
        return;
    }
    if (self.vacode.text.length <= 0) {
        [self showTips:@"请输入图形验证码"];
        return;
    }
  
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"email"] = self.email.text;
    param[@"email_code"] = self.vacode.text;
    param[@"sign"] = [Utilities handleParamsWithDic:param];
    param[@"uuid"] = [Utilities randomUUID];
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Set/EMvalidation"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            [self showTips:@"绑定邮箱成功"];
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
    self.title = kLocat(@"k_BindsetViewController_title");
    self.stepleft.layer.cornerRadius = 15/2;
    self.stepleft.layer.masksToBounds = YES;
    self.stepright.layer.cornerRadius = 15/2;
    self.stepright.layer.masksToBounds = YES;
    self.email.placeholder = kLocat(@"k_BindsetViewController_t1");
    self.vacode.placeholder = kLocat(@"k_BindsetViewController_t2");
    self.leftLabel.text = kLocat(@"k_BindsetViewController_t3");
    self.rightLabel.text = kLocat(@"k_BindsetViewController_t4");
    self.comBtn.layer.cornerRadius = 8;
    self.comBtn.layer.masksToBounds = YES;
    
    [self.comBtn setTitle:kLocat(@"k_BindsetViewController_b1") forState:UIControlStateNormal];
    
    NSArray *randomArr = @[@"H",@"j",@"q",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    _pooCodeView = [[PooCodeView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.vacode.frame), 0, 115, 39) andChangeArray:randomArr];
    
    //注意:文字高度不能大于poocodeview高度,否则crash
    _pooCodeView.textSize = 25;
    //不设置为blackColor
    _pooCodeView.textColor = kColorFromStr(@"#896FED");
    [self.bgView addSubview:_pooCodeView];
    
    // Do any additional setup after loading the view from its nib.
}





@end
