//
//  FinModel.h
//  YJOTC
//
//  Created by l on 2018/10/10.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FinModel : NSObject

@property (nonatomic,copy)NSString *member_id;
@property (nonatomic,copy)NSString *money;
@property (nonatomic,copy)NSString *typename;
@property (nonatomic,copy)NSString *currency_mark;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *money_type;
@property (nonatomic,copy)NSString *currency_id;
@property (nonatomic,copy)NSString *finance_id;
@property (nonatomic,copy)NSString *add_time;
@property (nonatomic,copy)NSString *content;

@end

NS_ASSUME_NONNULL_END
