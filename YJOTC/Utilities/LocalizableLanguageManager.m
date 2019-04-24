//
//  LocalizableLanguageManager.m
//  YJOTC
//
//  Created by 周勇 on 2017/12/22.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "LocalizableLanguageManager.h"
#import <objc/runtime.h>
#import "YJTabBarController.h"

@implementation LocalizableLanguageManager


static NSBundle *bundle = nil;

+ ( NSBundle * )bundle{
    return bundle;
}

+(void)initUserLanguage{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *string = [def valueForKey:@"userLanguage"];
    if(string.length == 0){
        //获取系统当前语言版本号
        NSArray* languages = [def objectForKey:@"AppleLanguages"];
//        NSString *current = [languages objectAtIndex:0];
        NSString *current = languages.lastObject;

        if ([current containsString:@"-CN"]) {
            current = [current stringByReplacingOccurrencesOfString:@"-CN" withString:@""];
        }
        
        string = current;
        [def setValue:current forKey:@"userLanguage"];
        [def synchronize];//持久化。不加的话不会保存
    }
    
    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];//生成bundle
}

+(NSString *)userLanguage{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *language = [def valueForKey:@"userLanguage"];
    return language;
}

+(void)setUserlanguage:(NSString *)language{
    
    if ([[self userLanguage] isEqualToString:language]) {
        return;
    }
    
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    //1.第一步改变bundle的值
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
    bundle = [NSBundle bundleWithPath:path];
    
    //2.持久化
    [def setValue:language forKey:@"userLanguage"];
    [def synchronize];
    
    [[self new] resetRootViewController];;
}

-(void)resetRootViewController
{
    
    YJTabBarController *tabbar = [[YJTabBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabbar;
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    
    // 让tabbar选中我的模块
//    tabbar.selectedIndex = 0;
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 发送通知，跳转到设置页面
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLanguageFinished" object:nil];
//    });
    NSArray *languages = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    NSString *currentLanguage = languages.firstObject;
    NSLog(@"模拟器当前语言：%@",currentLanguage);
}


@end
