//
//  NetworkTool.m
//  ywshop
//
//  Created by 周勇 on 2017/10/19.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "NetworkTool.h"
#import "YTLoginManager.h"

typedef NS_ENUM(NSInteger, NetworkRequestMethod) {
    NetworkRequestMethodGET,
    NetworkRequestMethodPOST
};

@interface NetworkTool ()


@end

@implementation NetworkTool

static NetworkTool * singleton;

+ (instancetype)sharedTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        singleton = [[NetworkTool alloc] initWithBaseURL:kBasePath.ks_URL];
//        singleton = [[NetworkTool alloc] init];
//        singleton.responseSerializer = [AFHTTPResponseSerializer serializer];

//        singleton.requestSerializer = [AFJSONRequestSerializer serializer];
        singleton.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json",@"image/png", @"text/json", @"text/javascript", @"text/plain", nil];
//        singleton.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
    });
    return singleton;
}

/**  post请求  */
- (void)POST_HTTPS :(NSString *) req_URL andParam:(NSDictionary *)param completeBlock:(void (^)(BOOL success,NSDictionary *responseObj,NSError *error ))completeBlock
{
    
  AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:kBasePath.ks_URL];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json",@"image/png", @"text/json", @"text/javascript", @"text/plain", nil];

    [manager POST:req_URL parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject != nil) {
            NSInteger code = [[responseObject ksObjectForKey:@"code"] integerValue];
            
            BOOL status = code == 10000 ? YES : NO;
            
//            if (code == 10000 || code == 200) {
//                status = YES;
//            }else{
//                status = NO;
//            }
            
            [YTLoginManager checkIsLogOutByCode:code];

            if (status) {
                completeBlock(YES , responseObject,nil);
            }else if(code == 906 || code == 904 || code == 903){//未登录
                
                //                [[NSNotificationCenter defaultCenter]postNotificationName:kTokenExpiredKey  object:nil];
                completeBlock( NO,responseObject,nil);
                
            }else{
                completeBlock( NO,responseObject,nil);
                //                [kKeyWindow showWarning:message];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completeBlock(NO,nil, error);
        kLOG(@"%@",error);
        //        [self showNetRequestResultTip];
        if (error.code == -1001) {
            dispatch_async_on_main_queue(^{
                //                [[KSAlertView sharedAlertView] showAlertViewWithTitle:nil messsage:@"加载失败"];
            });
            //            [[NSNotificationCenter defaultCenter]postNotificationName:kConnectTimeOutKey object:nil];
        }
        
    }];
}

/**  get请求  */
- (void)GET_HTTPS :(NSString *) req_URL andParam:(NSDictionary *)param completeBlock:(void (^)(BOOL success,NSDictionary *responseObj, NSError *error))completeBlock
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:kBasePath.ks_URL];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json",@"image/png", @"text/json", @"text/javascript", @"text/plain", nil];
    [manager GET:req_URL parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger code = [[responseObject ksObjectForKey:@"code"] integerValue];
        
        BOOL status = code == 10000 ? YES : NO;
        [YTLoginManager checkIsLogOutByCode:code];

        if (code == 10000 || code == 200) {
            status = YES;
        }else{
            status = NO;
        }
        
        if (status == YES) {
            completeBlock(YES , responseObject,nil);
            
        }else{
            
            completeBlock( NO,responseObject,nil);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        kLOG(@"%@",error);
        //        [self showNetRequestResultTip];
    }];
 
}

- (NSURLSessionDataTask *)objPOST:(NSString *)URLString
                       parameters:(NSDictionary *)parameters
                          success:(void(^)(YWNetworkResultModel *model, id responseObject))success
                          failure:(void(^)(NSError *error))failure {
    
    return [self requestMethod:NetworkRequestMethodPOST
                     URLString:URLString
                    parameters:parameters
                       success:success
                       failure:failure];
}

- (NSURLSessionDataTask *)objGET:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void(^)(YWNetworkResultModel *data, id responseObject))success
                         failure:(void(^)(NSError *error))failure {
    
    return [self requestMethod:NetworkRequestMethodGET
                     URLString:URLString
                    parameters:parameters
                       success:success
                       failure:failure];
}

- (NSURLSessionDataTask *)requestMethod:(NetworkRequestMethod)requestMethod
                              URLString:(NSString *)URLString
                             parameters:(NSDictionary *)parameters
                                success:(void(^)(YWNetworkResultModel *data, id responseObject))success
                                failure:(void(^)(NSError *error))failure {
    
    void(^successHandler)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            YWNetworkResultModel *model = [YWNetworkResultModel mj_objectWithKeyValues:responseObject];
            success(model, responseObject);
        }
    };
    
    switch (requestMethod) {
        case NetworkRequestMethodGET:
            return [self GET:URLString parameters:parameters progress:nil success:successHandler failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
            break;
            
        case NetworkRequestMethodPOST:
            return [self POST:URLString parameters:parameters progress:nil success:successHandler failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
            break;
    }
}

@end
