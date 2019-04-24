//
//  NTESVerifyCodeManager+HB.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/20.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "NTESVerifyCodeManager+HB.h"

@implementation NTESVerifyCodeManager (HB)

+ (instancetype)getManager {
    
    NTESVerifyCodeManager *manager = [NTESVerifyCodeManager sharedInstance];
    NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
    if ([currentLanguage containsString:@"en"]) {//英文
        manager.lang = NTESVerifyCodeLangEN;
    }else if ([currentLanguage containsString:@"Hant"]){//繁体
        manager.lang = NTESVerifyCodeLangCN;
    }else if ([currentLanguage containsString:Korean]){
        manager.lang = NTESVerifyCodeLangKR;
    }else{
        manager.lang = NTESVerifyCodeLangJP;
    }
    manager.alpha = 0;
    manager.frame = CGRectNull;
    [manager configureVerifyCode:@"71581c82ef3746fdb5b7bf5cdb515dc3" timeout:7];
    return manager;
}

@end
