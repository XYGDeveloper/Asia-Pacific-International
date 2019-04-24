//
//  NSString+IM.m
//  
//
//  Created by tarena31 on 16/7/13.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "NSString+ZZ.h"

@implementation NSString (ZZ)
- (NSURL *)ks_URL {
    /******  网络url  ******/
    if ([self containsString:@"http://"] || [self containsString:@"https://"]) {
        return [NSURL URLWithString:self];
    }
    /******  文件url  ******/
    return [NSURL fileURLWithPath:self];
}

@end
