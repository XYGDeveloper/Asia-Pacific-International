//
//  YTNewsViewController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/9.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTNewsViewController.h"

@interface YTNewsViewController ()

@end

@implementation YTNewsViewController

- (void)viewDidLoad {
//    self.urlStr = [NSString stringWithFormat:@"%@/Mobile/Trade/quotation.html",kBasePath];
    
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
