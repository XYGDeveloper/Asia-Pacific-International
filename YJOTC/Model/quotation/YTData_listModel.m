//
//  YTData_listModel.m
//  YJOTC
//
//  Created by l on 2018/10/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTData_listModel.h"

@implementation ListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"price": @"new_price",
             @"price_usd": @"new_price_usd",
             @"price_status": @"new_price_status",
             @"H_done_num":@"24H_done_num",
             };
}

- (NSString *)currency_id {

    return [NSString stringWithFormat:@"%@_%@", _currency_id, _trade_currency_id];
}

- (NSString *)originalCurrency_id {
    return _currency_id;
}

- (NSString *)comcurrencyName {
    return [NSString stringWithFormat:@"%@_%@", _currency_name, _trade_currency_mark];
}

@end

@implementation YTData_listModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"data_list" : @"ListModel",
             };
}

@end
