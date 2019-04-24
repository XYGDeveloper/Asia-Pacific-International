//
//  PayModel.h
//  YJOTC
//
//  Created by l on 2018/10/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface bankModel : NSObject

@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *member_id;
@property (nonatomic,copy)NSString *truename;
@property (nonatomic,copy)NSString *bankname;
@property (nonatomic,copy)NSString *province_id;
@property (nonatomic,copy)NSString *city_id;
@property (nonatomic,copy)NSString *bankadd;
@property (nonatomic,copy)NSString *bankcard;
@property (nonatomic,copy)NSString *add_time;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *c_id;
@property (nonatomic,copy)NSString *status;

@end

@interface AlipayModel : NSObject
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *member_id;
@property (nonatomic,copy)NSString *alipay;
@property (nonatomic,copy)NSString *alipay_pic;
@property (nonatomic,copy)NSString *add_time;
@property (nonatomic,copy)NSString *status;
@end

@interface WechatModel : NSObject
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *member_id;
@property (nonatomic,copy)NSString *wechat;
@property (nonatomic,copy)NSString *bankname;
@property (nonatomic,copy)NSString *add_time;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *wechat_pic;

@end

@interface PayModel : NSObject
@property (nonatomic,copy)NSArray *member_bank;
@property (nonatomic,copy)NSArray *member_alipay;
@property (nonatomic,copy)NSArray *member_wechat;

@end

