//
//  YJUserInfo.m
//  YJOTC
//
//  Created by 周勇 on 2017/12/23.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YJUserInfo.h"

@implementation YJUserInfo

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"uid" :@"member_id",
             @"avatar" :@"user_head",
             @"phone" :@"phone",
             @"token" :@"token",
             @"userName" :@"name",
             @"nickName" :@"name",
             @"isSeller" : @"is_seller",
             @"user_name" : @"user_name"
             };
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.uid = [aDecoder decodeIntegerForKey:@"uid"];
        //        self.pid = [aDecoder decodeObjectForKey:@"pid"];
        //        self.account = [aDecoder decodeObjectForKey:@"account"];
        self.user_name = [aDecoder decodeObjectForKey:@"user_name"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.hx_password = [aDecoder decodeObjectForKey:@"hx_password"];
        self.hx_username = [aDecoder decodeObjectForKey:@"hx_username"];
        self.inviter_id = [aDecoder decodeObjectForKey:@"inviter_id"];
        self.isSeller = [aDecoder decodeBoolForKey:@"isSeller"];
//        self.ename = [aDecoder decodeObjectForKey:@"ename"];
        self.verify_state = [aDecoder decodeObjectForKey:@"verify_state"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    //    kLOG(@"调用了encodeWithCoder:方法");
    [aCoder encodeObject:self.userName forKey:@"userName"];
    //    [aCoder encodeObject:self.pid forKey:@"pid"];
    [aCoder encodeInteger:self.uid forKey:@"uid"];
    //    [aCoder encodeObject:self.account forKey:@"account"];
    [aCoder encodeObject:self.user_name forKey:@"user_name"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.hx_username forKey:@"hx_username"];
    [aCoder encodeObject:self.hx_password forKey:@"hx_password"];
    [aCoder encodeObject:self.inviter_id forKey:@"inviter_id"];
    [aCoder encodeBool:self.isSeller forKey:@"isSeller"];
//    [aCoder encodeObject:self.ename forKey:@"ename"];
    [aCoder encodeObject:self.verify_state forKey:@"verify_state"];
}

- (BOOL)hasVerified {
    return [self.verify_state isEqualToString:@"1"];
}

-(void)saveUserInfo
{
    BOOL success = [NSKeyedArchiver archiveRootObject:self toFile:[[NSString stringWithFormat:@"%zd",[kUserDefaults integerForKey:kUserIDKey]] appendDocument]];
    kLOG(@"归档结果---<  %d  >",success);
}

+(YJUserInfo *)userInfo
{
    YJUserInfo *model = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSString stringWithFormat:@"%zd",[kUserDefaults integerForKey:kUserIDKey]] appendDocument]];
//    model.nickName = model.ename;
    return model;
}
-(void)clearUserInfo
{
    YJUserInfo *model = kUserInfo;
    model.token = @"";
    //    model.account = @"";
    model.uid = 0;
    model.phone = @"";
    [model saveUserInfo];
}




@end
