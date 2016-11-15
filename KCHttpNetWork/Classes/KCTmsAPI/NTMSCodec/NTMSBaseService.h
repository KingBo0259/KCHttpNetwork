//
//  NTMSBaseService.h
//  KCHttpNetworkDemo
//  小霸王Service工程
//  Created by jinlb on 2016/11/15.
//  Copyright © 2016年 jinlb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCTMSFactory+NSingle.h"

@interface NTMSBaseService : NSObject


/**
 设置token

 @param token 传入token
 */
+(void)setUserToken:(NSString*)token;

/**
 单个JsonModel对象请求
 @param requestValue 请求对象，注意必须实现
 @param success 成功
 @param error 失败
 */
+(void)postNTMSWithValue:(JSONModel*)requestValue
               success:(KCTMSSuccessBlock )success
                  fail:(KCTMSErrorBlock )error;



/**
 以对象形式传入
 
 @param key serviceKey
 @param requestValue 请求字典对象@{}
 @param responseClass 返回的对象实例
 @param success 成功
 @param error 失败
 */
+(void)postNTMSWithKey:(NSString*)key
          requestValue:(NSDictionary*)requestValue
         responseClass:(NSString*)responseClass
               success:(KCTMSSuccessBlock )success
                  fail:(KCTMSErrorBlock )error;

/**
 没有参数传入
 @param key serviceKey
 @param responseClass 返回的对象实例
 @param success 成功
 @param error 失败
 */
+(void)postNTMSWithKey:(NSString*)key
         responseClass:(NSString*)responseClass
               success:(KCTMSSuccessBlock )success
                  fail:(KCTMSErrorBlock )error;



/**
 小霸王项目单个对象万能请求
 
 @param value 请求value 对象为： JsonModel{包含key} 、@{key:@{}}、key
 @param responseClass 返回对象
 @param success 成功
 @param error 失败
 */
+(void)postNTMSWithValue:(id)value
          reponseClass:(NSString*)responseClass
               success:(KCTMSSuccessBlock )success
                  fail:(KCTMSErrorBlock )error;
@end
