//
//  UpdateVersionManager.m
//  YJOTC
//
//  Created by l on 2018/9/18.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "UpdateVersionManager.h"
@implementation UpdateVersionManager

+ (instancetype)sharedUpdate {
    static UpdateVersionManager *__manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[UpdateVersionManager alloc] init];
    });
    return __manager;
}


- (void)versionControl{
    if ([kBasePath containsString:@"test.yzcet"]) {
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"platform"] = @"ios";
    param[@"sign"] = [Utilities handleParamsWithDic:param];
    param[@"uuid"] = [Utilities randomUUID];
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/District/version"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        if (success) {
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            NSDictionary *dic = [responseObj ksObjectForKey:kResult];
            NSArray *tipsArr = dic[@"mobile_apk_explain"];
            NSMutableString *tipsStr = [NSMutableString new];
            for (NSDictionary *dic in tipsArr) {
                [tipsStr appendString:[NSString stringWithFormat:@"%@\n",dic[@"text"]]];
            }
            NSLog(@"%@",responseObj);
            NSInteger isForceUpdata = [dic[@"versionForce"]integerValue] ;
            NSLog(@"%@",app_Version);
            if (![dic[@"versionName"] isEqualToString:app_Version]) {
                self.url = dic[@"downloadUrl"];
                if (isForceUpdata) {
                    NSString *title                          = @"版本升级说明";
                    NSString *content                     = tipsStr.mutableCopy;
                    NSString  *buttonTitle                =  @"立即更新";
                    UpdateViewMessageObject *messageObject = MakeUpdateViewObject(title,content, buttonTitle,YES);
                    [LYZUpdateView showManualHiddenMessageViewInKeyWindowWithMessageObject:messageObject delegate:self viewTag:99];
                }
            }
        }
    }];
    
}

- (void)baseMessageView:(__kindof BaseMessageView *)messageView event:(id)event {
    NSLog(@"%@, tag:%ld event:%@", NSStringFromClass([messageView class]), (long)messageView.tag, event);
    if (messageView.tag == 99) {
        NSURL *url = [NSURL URLWithString:self.url];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
