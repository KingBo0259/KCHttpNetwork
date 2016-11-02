//
//  KCTMSFactory.m
//  KBFuny
//
//  Created by jinlb on 16/4/19.
//  Copyright © 2016年 jinlb. All rights reserved.
//

#import "KCTMSFactory.h"
//#import <JSONModel/JSONHTTPClient.h>
#import <AFNetworking.h>
#import "AFURLRequestSerialization.h"
#import "KCHttpEnum.h"
//#import "NSString+SBJSON.h"

static id<KCTMSEncodeProtocol> _encode;//编码规则实例化
static id<KCTMSDecodeProtocol> _decode;//解码实体类

@implementation KCTMSFactory

#pragma 初始化编码器和解码器
+(void)initWithEncode:(id<KCTMSEncodeProtocol>)encode decode:(id<KCTMSDecodeProtocol>)decode{

    _encode=encode;
    _decode=decode;


}

#pragma mark -- Post

/*
 * 单个对象请求。 只反回一个响应结果。
 * @url    请求路径
 * @request requst对象值
 * @responseClass  反回对象
 * @success 成功结果
 * @error   失败结果
 */
+(void)postSingleWithURL:(NSString*)urlStr
                 request:( JSONModel* )requestObj
           responseClass:( NSString* )responseClass
                 success:(KCTMSSuccessBlock )success
                    fail:(KCTMSErrorBlock )error{

    //1、将请求参数 封装成tms指定的json组装格数
    NSString *bodyStr=[_encode encodeFromArray:@[requestObj]];//编码数据
    NSLog(@"bodyStr = %@ ",bodyStr);
    
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval=15.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
    request.HTTPBody=[bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    
    if ([KCTMSFactoryHeader getToken] ) {
        [request setValue:[KCTMSFactoryHeader getToken] forHTTPHeaderField:@"token"];
    }
    
//    [request setValue:@"backend-service-factory" forHTTPHeaderField:@"from-source"];//不需要登录设置
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    NSURLSessionDataTask *task= [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error1) {
        
        if (error1) {
            if (error){
                error(error1);
            }
            return ;
        }
        
        id  tmsResponse= [_decode deccodeToSingleNativeFromServiceResponse:responseObject withResponseClass:responseClass];
        if (success) {
            success(tmsResponse);
        }
        
        
    }];
    
    
    //启动方法
    [task resume];


}



+(void)postWithURL:(NSString*)urlStr
               value:(JSONModel*)requestValue
                   success:(KCTMSSuccessBlock)success
                      fail:(KCTMSErrorBlock)error{
    
    [self postMulitWithURL:urlStr
                    params:@[requestValue]//若是空的参数则转化为“”
                   success:^(KCTMSRpcResponse *responseObject) {
        if (success) {
            if( responseObject.body&&[responseObject.body isKindOfClass:[NSDictionary class]]
               && [responseObject.body count]>0){
                responseObject.body=[[responseObject.body allObjects] firstObject];
            }
//            responseObject.body=responseObject.body!=nil&&[responseObject isKindOfClass:[NSDictionary class]]?[responseObject.body allObjects][0]:nil;
            success(responseObject);
        }
        
    } fail:^(NSError *error1) {
        if(error){
            error(error1);
        }
        
    }];
}

/*
 *  无请求参数，直传人key 值
 * @url    请求路径
 * @responseClass 反回的对象数据 格式
 * @success 成功结果
 * @error   失败结果
 */

+(void)postNoRequstWithURL:(NSString*)urlStr
                    tmsKey:(NSString*)tmsKey
                   success:(KCTMSSuccessBlock )success
                      fail:(KCTMSErrorBlock )error{
    [self postMulitWithURL:urlStr
                    params:@[tmsKey]//若是空的参数则转化为“”
                   success:^(KCTMSRpcResponse *responseObject) {
                       if (success) {
//                          responseObject.body=responseObject.body&&[responseObject isKindOfClass:[NSDictionary class]]?[responseObject.body allObjects][0]:nil;
                           if (responseObject.status == KC_HTTP_SUCCESS) {
                               if( responseObject.body &&([responseObject.body isKindOfClass:[NSDictionary class]])){
                                   id firstObject=[[responseObject.body allObjects] firstObject];
                                   if ([firstObject isKindOfClass:[JSONModel class]]) {
                                       responseObject.body=firstObject;
                                   }
                               }
                           }
                           success(responseObject);

                       }
                       
                   } fail:^(NSError *error1) {
                       if(error){
                           error(error1);
                       }
    }];
}


/*
 * @url             请求的URL 路径
 * @params          多个请求参数形式如：｛key1:JSONModel1,key2:JSONModel2｝
 * @responseMap     json 反回映射到本地对象的映射表 ：｛key1:[JSONModel1 class],key2:[JSONModel2 class]｝
 * @success         成功回调
 * @fail            失败回调
 */

+(void)postMulitWithURL:(NSString*)urlStr
                 params:(NSArray*)params
           success:(KCTMSSuccessBlock)success
              fail:(KCTMSErrorBlock)error{
    
    
    //1、将请求参数 封装成tms指定的json组装格数
    NSString *bodyStr=[_encode encodeFromArray:params];//编码数据    
    
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval=15.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
    request.HTTPBody=[bodyStr dataUsingEncoding:NSUTF8StringEncoding];

    if ([KCTMSFactoryHeader getToken] ) {
        [request setValue:[KCTMSFactoryHeader getToken] forHTTPHeaderField:@"token"];
    }
//    [request setValue:@"backend-service-factory" forHTTPHeaderField:@"from-source"];//不需要登录设置

    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    NSURLSessionDataTask *task= [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error1) {
        
        if (error1) {
            if (error){
                error(error1);
            }
            return ;
        }
        
        id tmsResponse= [_decode decodeToNativeFromServiceResponse:responseObject];
        if (success) {
            success(tmsResponse);
        }
        
        
    }];
    

    //启动方法
    [task resume];
    
}

/// 同步请求
+(void)syncPostMulitWithURL:(NSString*)urlStr
                params:(NSArray*)params
               success:(KCTMSSuccessBlock)success
                  fail:(KCTMSErrorBlock)error{

    //1、将请求参数 封装成tms指定的json组装格数
    NSString *bodyStr=[_encode encodeFromArray:params];//编码数据
    AFHTTPRequestSerializer * serializer = [AFHTTPRequestSerializer serializer];
    NSError *serializationError = nil;
    NSMutableURLRequest * request = [serializer requestWithMethod:@"POST" URLString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil error:&serializationError];
    request.HTTPBody=[bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    if ([KCTMSFactoryHeader getToken] ) {
        [request setValue:[KCTMSFactoryHeader getToken] forHTTPHeaderField:@"token"];
    }
    NSError *error1=nil;
    NSData *responsedata = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error1];
    if (responsedata == nil) {
        if (error) {
            error(error1);
        }
        return;
    }
    
    NSString *resutStr= [[NSString alloc] initWithData:responsedata encoding:NSUTF8StringEncoding];
//    NSDictionary *resultDic=  [resutStr JSONValue];
    NSDictionary *resultDic=  [self dictionaryWithJsonString:resutStr];
    
    if (error1) {
        if (error){
            error(error1);
        }
        return ;
    }
    
    id tmsResponse= [_decode decodeToNativeFromServiceResponse:resultDic];
    if (success) {
        success(tmsResponse);
    }
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
