//
//  KCTMSBaseService.m
//  KBFuny
//
//  Created by jinlb on 16/4/20.
//  Copyright © 2016年 jinlb. All rights reserved.
//

#import "KCTMSBaseService.h"
#import "KCTMSArchive.h"
#import "KCTMSUnarchive.h"

static  NSString *KCTMSService=@"http://gate.kuaihuoyun.com";



static  NSString * KCTMSServiceURL;
static  NSString * KCTMSSingleServiceURL;
static  NSString * KCTMSMergeServiceURL;

@implementation KCTMSBaseService

+(void)initialize{
    
    KCTMSSingleServiceURL= [NSString stringWithFormat:@"%@/odin/servlet/gate/single",KCTMSService];
    KCTMSServiceURL      = [NSString stringWithFormat:@"%@/odin/servlet/gate/single",KCTMSService];
    KCTMSMergeServiceURL = [NSString stringWithFormat:@"%@/odin/servlet/gate/merge",KCTMSService];
    [KCTMSFactory initWithEncode:[KCTMSArchive new] decode:[KCTMSUnarchive new]];
    
}


+(void)setUserToken:(NSString*)token{
    [KCTMSFactoryHeader setToken:token];
    
}



/*
 * @requestValue  上行参数的对象
 * @responseClassName  反回的对象
 * @success         成功回调
 * @fail            失败回调
 */
-(void)postWithSingleRequestModel:(JSONModel*)requestValue
                responseClassName:(NSString*)responseClass
                          success:(KCTMSSuccessBlock __nullable)success
                             fail:(KCTMSErrorBlock __nullable)error{
    [KCTMSFactory postSingleWithURL:KCTMSSingleServiceURL request:requestValue responseClass:responseClass success:success fail:error];
}

-(void)postWithRequestModel:(JSONModel*)requestValue
                    success:(KCTMSSuccessBlock __nullable)success
                       fail:(KCTMSErrorBlock __nullable)error{
    
    [KCTMSFactory postWithURL:KCTMSSingleServiceURL
                        value:requestValue
                      success:^(KCTMSRpcResponse *responseObject) {
                          //1、 可以处理异常公共的 异常处理
                          
                          //2、回调
                          
                          if (success) {
                              success(responseObject);
                          }
                          
                          
                      } fail:^(NSError *error1) {
                          //处理公共的异常处理
                          if (error) {
                              error(error1);
                          }
                          
                      }
     ];
}


/*
 *  无请求参数，直传人key 值; 只反回一个结果
 * @url    请求路径
 * @tmsKey  serviceKey
 * @success 成功结果
 * @error   失败结果
 */
-(void)postNoRequstWithTmsKey:(NSString*)tmsKey
                      success:(KCTMSSuccessBlock __nullable)success
                         fail:(KCTMSErrorBlock __nullable)error{
    
    [KCTMSFactory postNoRequstWithURL:KCTMSServiceURL tmsKey:tmsKey success:^(KCTMSRpcResponse *responseObject) {
        //1、 可以处理异常公共的 异常处理
        
        //2、回调
        
        if (success) {
            success(responseObject);
        }
        
        
    } fail:^(NSError *error1) {
        
        //处理公共的异常处理
        if (error) {
            error(error1);
        }
        
        
    }];
    
}

/**
 *  单个字典对象数据上行请求数据
 *
 *  @param tmsKey  对应服务器端
 *  @param value   字典组装的请求对象 不可为空
 *  @param success 成功返回结果
 *  @param error   失败返回结果
 */
-(void)postRequestWithTmsKey:( NSString* __nonnull)tmsKey
              dictionryValue:( NSDictionary* __nonnull)value
                     success:(KCTMSSuccessBlock __nullable)success
                        fail:(KCTMSErrorBlock __nullable)error{
    //组装数字
    [self postMulitWithParams:@[@{tmsKey:value}] success:success fail:error];
    
}

/*
 * @url             请求的URL 路径
 * @params          多个请求参数形式如：[key1:JSONModel1,key2:JSONModel2]
 * @responseMap     json 反回映射到本地对象的映射表 ：｛key1:[JSONModel1 class],key2:[JSONModel2 class]｝
 * @success         成功回调
 * @fail            失败回调
 */

-(void)postMulitWithParams:(NSArray*)params
                   success:(KCTMSSuccessBlock __nullable)success
                      fail:(KCTMSErrorBlock __nullable)error{
    [KCTMSFactory   postMulitWithURL:KCTMSMergeServiceURL
                              params:params
                             success:^(KCTMSRpcResponse *responseObject) {
                                 //1、 可以处理异常公共的 异常处理
                                 
                                 //2、回调
                                 if (success) {
                                     success(responseObject);
                                 }
                                 
                             } fail:^(NSError *error1) {
                                 //处理公共的异常处理
                                 if (error) {
                                     error(error1);
                                 }
                                 
                             }];
}

/**
 *  同步请求-----单个字典对象数据上行请求数据
 *
 *  @param tmsKey  对应服务器端
 *  @param value   字典组装的请求对象 不可为空
 *  @param success 成功返回结果
 *  @param error   失败返回结果
 */
-(void)syncPostRequestWithTmsKey:( NSString* __nonnull)tmsKey
                  dictionryValue:( NSDictionary* __nonnull)value
                         success:(KCTMSSuccessBlock __nullable)success
                            fail:(KCTMSErrorBlock __nullable)error{
    //组装数字
    [KCTMSFactory  syncPostMulitWithURL:KCTMSMergeServiceURL
                             params:@[@{tmsKey:value}]
                            success:^(KCTMSRpcResponse *responseObject) {
                                //1、 可以处理异常公共的 异常处理
                                
                                //2、回调
                                if (success) {
                                    success(responseObject);
                                }
                                
                            } fail:^(NSError *error1) {
                                //处理公共的异常处理
                                if (error) {
                                    error(error1);
                                }
                                
                            }];
}


@end
