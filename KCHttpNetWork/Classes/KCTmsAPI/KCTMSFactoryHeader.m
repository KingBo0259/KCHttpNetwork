//
//  KCTMSFactoryHeader.m
//  KCNetWorkProxy
//
//  Created by jinlb on 16/5/16.
//  Copyright © 2016年 jinlb. All rights reserved.
//

#import "KCTMSFactoryHeader.h"
static NSString *userToken;

@implementation KCTMSFactoryHeader
+(void)setToken:(NSString*)token{
    userToken=token;
}

+(NSString*)getToken{
    return userToken;
} 
@end
