//
//  KCTMSFactory+NSingle.h
//  KCHttpNetworkDemo
//  这里只负责编写 小霸王项目的单个对象请求
//  Created by jinlb on 2016/11/15.
//  Copyright © 2016年 jinlb. All rights reserved.
//

#import "KCTMSFactory.h"

@interface KCTMSFactory (NSingle)


/**
 单个JsonModel对象请求
 @param urlStr URL
 @param requestValue 请求对象，注意必须实现 
 @param success 成功
 @param error 失败
 */
+(void)postNTMSWithURL:(NSString*)urlStr
                value:(JSONModel*)requestValue
              success:(KCTMSSuccessBlock )success
                 fail:(KCTMSErrorBlock )error;



/**
 以对象形式传入

 @param urlStr URL
 @param key serviceKey
 @param requestValue 请求字典对象@{}
 @param responseClass 返回的对象实例
 @param success 成功
 @param error 失败
 */
+(void)postNTMSWithURL:(NSString*)urlStr
                   key:(NSString*)key
         requestValue:(NSDictionary*)requestValue
         responseClass:(NSString*)responseClass
               success:(KCTMSSuccessBlock )success
                  fail:(KCTMSErrorBlock )error;

/**
 没有参数传入
 @param urlStr URL
 @param key serviceKey
 @param responseClass 返回的对象实例
 @param success 成功
 @param error 失败
 */
+(void)postNTMSWithURL:(NSString*)urlStr
                   key:(NSString*)key
         responseClass:(NSString*)responseClass
               success:(KCTMSSuccessBlock )success
                  fail:(KCTMSErrorBlock )error;



/**
 小霸王项目单个对象万能请求

 @param urlStr URL
 @param value 请求value 对象为： JsonModel{包含key} 、@{key:@{}}、key
 @param responseClass 返回对象
 @param success 成功
 @param error 失败
 */
+(void)postNTMSWithURL:(NSString*)urlStr
                 value:(id)value
          reponseClass:(NSString*)responseClass
               success:(KCTMSSuccessBlock )success
                  fail:(KCTMSErrorBlock )error;


/**
 上传图片
 @param success 成功
 @param error 失败
 */
+(void)postNTMSUploadImageWithURL:(NSString *)url
                        imageName:(NSString *)imageName
                         photoImg:(UIImage *)photoImg
                     reponseClass:(NSString*)responseClass
                          success:(KCTMSSuccessBlock )success
                             fail:(KCTMSErrorBlock )error;

/**
 删除图片
 @param success 成功
 @param error 失败
 */
+(void)postNTMSDeleteUploadImageWithURL:(NSString *)url
                               filePath:(NSString *)filePath
                           reponseClass:(NSString*)responseClass
                                success:(KCTMSSuccessBlock )success
                                   fail:(KCTMSErrorBlock )error;


@end
