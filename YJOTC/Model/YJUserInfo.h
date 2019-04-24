//
//  YJUserInfo.h
//  YJOTC
//
//  Created by 周勇 on 2017/12/23.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJUserInfo : NSObject


/**  用户id  */
@property(nonatomic,assign)NSInteger uid;
/**  token  */
@property(nonatomic,copy)NSString * token;
/**  头像  */
@property(nonatomic,copy)NSString * avatar;
/**  token  */
@property(nonatomic,copy)NSString * inviter_id;
/**  token  */
@property(nonatomic,copy)NSString * phone;
/**  token  */
@property(nonatomic,copy)NSString * userName;
/**  昵称  */
@property(nonatomic,copy)NSString *user_name;
/**  环信id  */
@property(nonatomic,copy)NSString * hx_username;
/**  环信密码  */
@property(nonatomic,copy)NSString * hx_password;

//@property(nonatomic,copy)NSString * ename;


/**
 实名验证状态
 */
@property (nonatomic, copy) NSString *verify_state;//1:表示已验证


/**  是否是商家  */
@property(nonatomic,assign)BOOL isSeller;


/**
 已通过实名验证?

 @return 已通过实名验证?
 */
- (BOOL)hasVerified;





+(YJUserInfo *)userInfo;

-(void)saveUserInfo;

-(void)clearUserInfo;


@end
