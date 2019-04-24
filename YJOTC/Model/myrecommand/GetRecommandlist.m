//
//  GetRecommandlist.m
//  YJOTC
//
//  Created by l on 2018/9/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "GetRecommandlist.h"
#import "RecommandModel.h"

@interface GetRecommandlist()
@property (nonatomic,strong)NSString *lan;
@property (nonatomic,strong)NSString *token;
@property (nonatomic,strong)NSString *token_id;
@property (nonatomic,strong)NSString *uuid;
@end

@implementation GetRecommandlist

- (instancetype)initWithKey:(NSString *)token
                     lanage:(NSString *)lanage
                   token_id:(NSString *)token_id
                       uuid:(NSString *)uuid{
    self = [super init];
    if (self) {
        self.lan = lanage;
        self.token = token;
        self.token_id = token_id;
        self.uuid = uuid;
    }
    return self;
}

- (void)refresh {
    NSDictionary *params = @{@"language":self.lan ?: @"",
                             @"key":self.token ?: @"",
                             @"token_id":self.token_id ?: @"",
                             @"uuid":self.uuid ?: @""
                             };
    [self refreshWithParams:params];
}

- (void)loadNextPage {
    NSDictionary *params = @{
                             @"language":self.lan ?: @"",
                             @"key":self.token ?: @"",
                             @"token_id":self.token_id ?: @"",
                             @"uuid":self.uuid ?: @""
                             };
    [self loadNextPageWithParams:params];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(recommand);
    return command;
}

- (id)reformData:(id)responseObject {
    RecommandModel *model = [RecommandModel mj_objectWithKeyValues:responseObject];
    return model;
}

@end
