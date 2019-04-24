//
//  MyInviteViewController.m
//  YJOTC
//
//  Created by l on 2018/9/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "MyInviteViewController.h"
#import "TOActionSheet.h"

@interface MyInviteViewController ()

@end

@implementation MyInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = kLocat(@"k_MyinviteViewController_top_label_0");
    
    self.bgview.layer.cornerRadius = 8; //设置imageView的圆角
    
    self.bgview.userInteractionEnabled = YES;
    
    self.bgview.layer.masksToBounds = YES;
    
     self.bgview.layer.shadowColor = [UIColor blackColor].CGColor;//设置阴影的颜色
    
     self.bgview.layer.shadowOpacity = 0.8;//设置阴影的透明度
    
     self.bgview.layer.shadowOffset = CGSizeMake(1, 1);//设置阴影的偏移量
    
     self.bgview.layer.shadowRadius = 3;//设置阴影的圆角

     self.des.text = kLocat(@"k_MyinviteViewController_top_label_1");
     self.detail.text = kLocat(@"k_MyinviteViewController_top_label_2");
    
    self.invitecode.text = [NSString stringWithFormat:@"%ld",kUserInfo.uid];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.QRcode.width, self.QRcode.height)];
    
    img.userInteractionEnabled = YES;
    
    img.image = [UIImage imageNamed:@"qr_down"];
    
    [self.QRcode addSubview:img];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        TOActionSheet *actionSheet = [[TOActionSheet alloc] init];
        actionSheet.title = kLocat(@"k_MyinviteViewController_top_label_3");
        actionSheet.contentstyle = TOActionSheetContentStyleDefault;
        [actionSheet addButtonWithTitle:kLocat(@"k_meViewcontroler_loginout_sure") icon:nil tappedBlock:^{
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:bcbcom]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:bcbcom]];
            }
        }];
        actionSheet.actionSheetDismissedBlock = ^{
            NSLog(@"dissmiss");
        };
        [actionSheet showFromView:nil inView:self.view];
      
    }];
    [img addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view from its nib.
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
