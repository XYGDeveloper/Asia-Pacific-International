
//
//  ICNNationalityModel.m
//  icn
//
//  Created by 周勇 on 2018/1/31.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "ICNNationalityModel.h"

@implementation ICNNationalityModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"countrycode" :@"phone_code"};
}
@end
