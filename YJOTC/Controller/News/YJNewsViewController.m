//
//  YJNewsViewController.m
//  YJOTC
//
//  Created by 周勇 on 2017/12/22.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YJNewsViewController.h"


@interface YJNewsViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)WKWebView * webView;

@property(nonatomic,copy)NSString *currentUrl;

@property(nonatomic,assign)BOOL firstLoad;

@property(nonatomic,assign)NSInteger count;

@end

@implementation YJNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin) name:kLoginSuccessKey object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidlogout) name:kLoginOutKey object:nil];
    
    [self setupWebView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;

}

-(void)setupWebView
{
    
    _webView = [[WKWebView alloc] initWithFrame:kRectMake(0, kStatusBarHeight, kScreenW, kScreenH - kStatusBarHeight - kTabbarItemHeight) configuration:[self webViewConfigurate]];
    if (@available(iOS 11.0, *)) {
        _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    _firstLoad = YES;
    
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    
    [self.webView loadHTMLString:@"" baseURL:kBasePath.ks_URL];
    
    
    [self.view addSubview:_webView];
    
    kShowHud;
}

-(WKWebViewConfiguration *)webViewConfigurate
{
    WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
    // 支持内嵌视频播放，不然网页中的视频无法播放
    webConfig.allowsInlineMediaPlayback = YES;
    NSString *cookieValue;

    NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
    NSString *lang = nil;
    if ([currentLanguage containsString:@"en"]) {//英文
        lang = @"en-us";
    }else if ([currentLanguage containsString:@"Hant"]){//繁体
        lang = @"zh-tw";
    }else{//简体
        lang = @"zh-cn";
    }
    if ([Utilities isExpired]) {
        cookieValue = [NSString stringWithFormat:@"document.cookie = 'odrtoken=%@';document.cookie = 'odrplatform=ios';document.cookie = 'odruuid=%@';document.cookie = 'odrthink_language=%@';",@"1",[Utilities randomUUID],lang];
    }else{
        cookieValue = [NSString stringWithFormat:@"document.cookie = 'odrtoken=%@';document.cookie = 'odrplatform=ios';document.cookie = 'odruuid=%@';document.cookie = 'odrthink_language=%@';",kUserInfo.token,[Utilities randomUUID],lang];
    }
    // 加cookie给h5识别，表明在ios端打开该地址
    WKUserContentController* userContentController = [[WKUserContentController alloc] init];
    [userContentController addScriptMessageHandler:self name:@"iosAction"];
    WKUserScript * cookieScript = [[WKUserScript alloc]
                                   initWithSource: cookieValue
                                   injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [userContentController addUserScript:cookieScript];
    webConfig.userContentController = userContentController;
    return webConfig;
}
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSString *actionSting = message.body;
    
//    [self showTips:actionSting];
    kLOG(@"webview返回的字段===%@===",actionSting);
    if ([actionSting isEqual:@"iosLoginAction"]) {
        dispatch_async_on_main_queue(^{
            [self gotoLoginVC];
        });
    }else if ([actionSting isEqual:@"goback"]){

        [self backAction];

    }else if ([actionSting isEqual:@"zh-cn"]){//简体
        [LocalizableLanguageManager setUserlanguage:CHINESESimlple];
    }else if ([actionSting isEqual:@"zh-tw"]){//繁体
        [LocalizableLanguageManager setUserlanguage:CHINESEradition];
    }else if ([actionSting isEqual:@"en-us"]){//英文
        [LocalizableLanguageManager setUserlanguage:ENGLISH];
    }else if ([actionSting isEqual:@"loginOut"]){//登出
        
    }else if ([actionSting isEqual:@"login"]){//登录
        [self gotoLoginVC];
    }else if ([actionSting hasPrefix:@"gobuy"]){//买入
        self.tabBarController.selectedIndex = 2;
        [kUserDefaults setObject:actionSting forKey:@"kCurrenryInfoKey"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kCurrenyId" object:actionSting];
        [self backAction];
    }else if ([actionSting hasPrefix:@"gosell"]){//卖出
        self.tabBarController.selectedIndex = 2;
        [kUserDefaults setObject:actionSting forKey:@"kCurrenryInfoKey"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kCurrenyId" object:actionSting];
        [self backAction];
    }
    
}


-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (_firstLoad == NO) {
        kHideHud;
    }
    
    if (_firstLoad) {
        _firstLoad = NO;
        
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        
        
        NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
        
        NSString *lang = nil;
        if ([currentLanguage containsString:@"en"]) {//英文
            lang = @"en-us";
        }else if ([currentLanguage containsString:@"Hant"]){//繁体
            lang = @"zh-tw";
        }else{//简体
            lang = @"zh-cn";
        }
        
        NSString *JSFuncString;
        if ([Utilities isExpired]) {
            JSFuncString = [NSString stringWithFormat:@"document.cookie = 'odrtoken=%@';document.cookie = 'odrplatform=ios';document.cookie = 'odruuid=%@';document.cookie = 'odrthink_language=%@';",@"1",[Utilities randomUUID],lang];
        }else{
            JSFuncString = [NSString stringWithFormat:@"document.cookie = 'odrtoken=%@';document.cookie = 'odrplatform=ios';document.cookie = 'odruuid=%@';document.cookie = 'odrthink_language=%@';",kUserInfo.token,[Utilities randomUUID],lang];
        }
        //拼凑js字符串，按照自己的需求拼凑Cookie
        NSMutableString *JSCookieString = JSFuncString.mutableCopy;
        for (NSHTTPCookie *cookie in cookieStorage.cookies) {
            NSString *excuteJSString = [NSString stringWithFormat:@"setCookie('%@', '%@', 3);", cookie.name, cookie.value]; [JSCookieString appendString:excuteJSString];
            
        }
        //执行js
        [webView evaluateJavaScript:JSCookieString completionHandler:^(id obj, NSError * _Nullable error) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Mobile/Trade/quotation.html",kBasePath]];

            // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            // 3. 发送请求给服务器
            [_webView loadRequest:request];
        }];
    }
    
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

-(void)backAction
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)userDidLogin
{
    [_webView removeFromSuperview];
    [self setupWebView];
}

-(void)userDidlogout
{
    [self userDidLogin];
}

@end
