//
//  FinLogApi.h
//  YJOTC
//
//  Created by l on 2018/10/10.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "BaseListApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface FinLogApi : BaseListApi
- (instancetype)initWithKey:(NSString *)token
                     lanage:(NSString *)lanage
                   token_id:(NSString *)token_id;
@end

NS_ASSUME_NONNULL_END
