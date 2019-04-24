//
//  AuthViewController.m
//  YJOTC
//
//  Created by l on 2018/10/9.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "AuthViewController.h"
#import "WSCameraAndAlbum.h"
#import "UIImage+ZXCompress.h"
@interface AuthViewController ()
@property (nonatomic,strong)NSString *picBase1;
@property (nonatomic,strong)NSString *picBase2;
@property (nonatomic,strong)NSString *picBase3;

@end

@implementation AuthViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getIsAuth];
}

- (void)getIsAuth{
    
    self.title = kLocat(@"k_AuthViewController_title");
    self.nameLabel.text = kLocat(@"k_AuthViewController_name");
    self.nameTextField.placeholder = kLocat(@"k_AuthViewController_placehoder");
    self.firstLabel.text = kLocat(@"k_AuthViewController_pc1");
    self.secondLabel.text = kLocat(@"k_AuthViewController_pc2");
    self.thirdLabel.text = kLocat(@"k_AuthViewController_pc3");
    [self.commitBtn setTitle:kLocat(@"k_AuthViewController_comit") forState:UIControlStateNormal];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"sign"] = [Utilities handleParamsWithDic:param];
    param[@"uuid"] = [Utilities randomUUID];
    NSLog(@"%@",param);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/set/get_verify"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        NSLog(@"%@",responseObj);
        if (success) {
            NSString *verify_satate = [responseObj ksObjectForKey:kResult][@"verify_state"];
            YJUserInfo *userInfo = kUserInfo;
            userInfo.verify_state = verify_satate;
            [userInfo saveUserInfo];
            if ([[responseObj ksObjectForKey:kResult][@"verify_state"] isEqualToString:@"0"] || [[responseObj ksObjectForKey:kResult][@"verify_state"] isEqualToString:@""]) {
//                self.pc1.image = [UIImage imageNamed:@"auth_place"];
//                self.pc2.image = [UIImage imageNamed:@"auth_place"];
//                self.pc3.image = [UIImage imageNamed:@"auth_place"];

            }else if ([[responseObj ksObjectForKey:kResult][@"verify_state"] isEqualToString:@"1"]){
                self.nameTextField.userInteractionEnabled = NO;
                self.pc1.userInteractionEnabled = NO;
                NSString *pc1url = [NSString stringWithFormat:@"%@",[responseObj ksObjectForKey:kResult][@"pic1"]];
                NSString *pc2url = [NSString stringWithFormat:@"%@",[responseObj ksObjectForKey:kResult][@"pic2"]];
                NSString *pc3url = [NSString stringWithFormat:@"%@",[responseObj ksObjectForKey:kResult][@"pic3"]];
                [self.pc1 setImageURL:[NSURL URLWithString:pc1url]];
                self.pc2.userInteractionEnabled = NO;
                [self.pc2 setImageURL:[NSURL URLWithString:pc2url]];
                self.pc3.userInteractionEnabled = NO;
                [self.pc3 setImageURL:[NSURL URLWithString:pc3url]];
                self.nameTextField.text = [responseObj ksObjectForKey:kResult][@"name"];
                [self.commitBtn setTitle:@"已通过" forState:UIControlStateNormal];
                self.commitBtn.userInteractionEnabled = NO;
            }else{
                self.nameTextField.userInteractionEnabled = NO;
                self.pc1.userInteractionEnabled = NO;
                NSString *pc1url = [NSString stringWithFormat:@"%@",[responseObj ksObjectForKey:kResult][@"pic1"]];
                 NSString *pc2url = [NSString stringWithFormat:@"%@",[responseObj ksObjectForKey:kResult][@"pic2"]];
                 NSString *pc3url = [NSString stringWithFormat:@"%@",[responseObj ksObjectForKey:kResult][@"pic3"]];
                [self.pc1 setImageURL:[NSURL URLWithString:pc1url]];
                self.pc2.userInteractionEnabled = NO;
                [self.pc2 setImageURL:[NSURL URLWithString:pc2url]];
                self.pc3.userInteractionEnabled = NO;
                [self.pc3 setImageURL:[NSURL URLWithString:pc3url]];
                self.nameTextField.text = [responseObj ksObjectForKey:kResult][@"name"];
                [self.commitBtn setTitle:@"审核中" forState:UIControlStateNormal];
                self.commitBtn.userInteractionEnabled = NO;
            }
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
//            self.pc1.image = [UIImage imageNamed:@"auth_place"];
//            self.pc2.image = [UIImage imageNamed:@"auth_place"];
//            self.pc3.image = [UIImage imageNamed:@"auth_place"];
        }
    }];
}

- (void)topc1{
    
    [WSCameraAndAlbum showSelectPicsWithController:self multipleChoice:NO selectDidDo:^(UIViewController *fromViewController, NSArray *selectedImageDatas) {
        {
            if(selectedImageDatas.count > 0){
                AuthViewController *vc = (AuthViewController *)fromViewController;
                UIImage *image = [[UIImage alloc]initWithData:selectedImageDatas[0]];
                vc.pc1.image = image;
                vc.picBase1 = [vc UIImageToBase64Str:image];
            }
        }
    } cancleDidDo:^(UIViewController *fromViewController) {
        NSLog(@"没有选择图片");
        AuthViewController *vc = (AuthViewController *)fromViewController;
        vc.pc1.image = [UIImage imageNamed:@"auth_place"];
        
    }];
    
}

- (void)topc2{
    [WSCameraAndAlbum showSelectPicsWithController:self multipleChoice:NO selectDidDo:^(UIViewController *fromViewController, NSArray *selectedImageDatas) {
        {
            if(selectedImageDatas.count > 0){
                AuthViewController *vc = (AuthViewController *)fromViewController;
                UIImage *image = [[UIImage alloc]initWithData:selectedImageDatas[0]];
                vc.pc2.image = image;
                vc.picBase2 = [vc UIImageToBase64Str:image];
            }
        }
    } cancleDidDo:^(UIViewController *fromViewController) {
        NSLog(@"没有选择图片");
        AuthViewController *vc = (AuthViewController *)fromViewController;
        vc.pc2.image = [UIImage imageNamed:@"auth_place"];
        
    }];
}

- (void)topc3{
    [WSCameraAndAlbum showSelectPicsWithController:self multipleChoice:NO selectDidDo:^(UIViewController *fromViewController, NSArray *selectedImageDatas) {
        {
            if(selectedImageDatas.count > 0){
                AuthViewController *vc = (AuthViewController *)fromViewController;
                UIImage *image = [[UIImage alloc]initWithData:selectedImageDatas[0]];
                vc.pc3.image = image;
                vc.picBase3 = [vc UIImageToBase64Str:image];
            }
        }
    } cancleDidDo:^(UIViewController *fromViewController) {
        NSLog(@"没有选择图片");
        AuthViewController *vc = (AuthViewController *)fromViewController;
        vc.pc3.image = [UIImage imageNamed:@"auth_place"];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topc1)];
    [self.pc1 addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topc2)];
    [self.pc2 addGestureRecognizer:tap2];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topc3)];
    [self.pc3 addGestureRecognizer:tap3];
    
}

-(NSString *)UIImageToBase64Str:(UIImage *)image{
    
    UIImage *tempimage = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.5)];
    //    UIImage *image = _avatar.image;
    CGSize size = [UIImage zx_scaleImage:tempimage length:100.];
    tempimage = [tempimage zx_imageWithNewSize:size];
    NSString *str = [NSString stringWithFormat:@"%@%@",@"data:image/jpeg;base64,",[Utilities encodeToBase64StringWithImage:tempimage]]; 
    return str;
}


- (IBAction)commitAuth:(id)sender {
    //提交
    if (self.nameTextField.text.length <= 0) {
        [self showTips:@"请输入姓名"];
        return;
    }
    if (self.picBase1.length <= 0) {
        [self showTips:@"请选择证件正面照"];
        return;
    }
    if (self.picBase2.length <= 0) {
        [self showTips:@"请选择证件背面照"];
        return;
    }
    if (self.picBase3.length <= 0) {
        [self showTips:@"请选择手持证件照"];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"name"] = self.nameTextField.text;
    param[@"pic1"] = self.picBase1;
    param[@"pic2"] = self.picBase2;
    param[@"pic3"] = self.picBase3;
    param[@"sign"] = [Utilities handleParamsWithDic:param];
    param[@"uuid"] = [Utilities randomUUID];
    NSLog(@"%@",param);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Set/new_name_operation"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        NSLog(@"%@",responseObj);
        if (success) {
            [self showTips:@"上传成功"];
            [self getIsAuth];

        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
    
}

@end
