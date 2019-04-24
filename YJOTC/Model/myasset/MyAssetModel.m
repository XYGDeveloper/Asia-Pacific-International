//
//  MyAssetModel.m
//  YJOTC
//
//  Created by l on 2018/9/29.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "MyAssetModel.h"

@implementation sumModel

@end

@implementation current_userModel

@end

@implementation u_infoModel

@end


@implementation MyAssetModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"currency_user" : @"current_userModel",
             @"sum" : @"sumModel",
             };
}
@end
