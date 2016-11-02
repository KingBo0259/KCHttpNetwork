//
//  KCTMSBaseService.h
//  KBFuny
//
//  Created by jinlb on 16/4/20.
//  Copyright © 2016年 jinlb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCTMSFactory.h"

@interface KCTMSBaseService : NSObject

///设置token
+(void)setUserToken:(NSString*)token;


/*
 * @requestValue  上行参数的对象
 * @responseClassName  反回的对象
 * @success         成功回调
 * @fail            失败回调
 */
-(void)postWithSingleRequestModel:(JSONModel*)requestValue
          responseClassName:(NSString*)responseClass
                    success:(KCTMSSuccessBlock)success
                       fail:(KCTMSErrorBlock)error;

/*
 * @requestValue  上行参数的对象
 * @success         成功回调
 * @fail            失败回调
 */
-(void)postWithRequestModel:(JSONModel*)requestValue
              success:(KCTMSSuccessBlock)success
                 fail:(KCTMSErrorBlock)error;

/*
 * @url             请求的URL 路径
 * @params          多个请求参数形式。当然这里也可以直接传 key值：@[JSONModel1,JSONModel2，key1，key2...] 或者直接上传组织字典：[{key1:{value1},[key2:{vlue2}]}]
 *                  当传key时 说明上行参数为空。不进行数据上行
 * @success         成功回调
 * @fail            失败回调
 */

-(void)postMulitWithParams:(NSArray*)params
                success:(KCTMSSuccessBlock)success
                   fail:(KCTMSErrorBlock)error;

/*
 *  无请求参数，直传人key 值; 只反回一个结果
 * @url    请求路径
 * @tmsKey  serviceKey
 * @success 成功结果
 * @error   失败结果
 */
-(void)postNoRequstWithTmsKey:(NSString*)tmsKey
                   success:(KCTMSSuccessBlock )success
                      fail:(KCTMSErrorBlock )error;

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
                        fail:(KCTMSErrorBlock __nullable)error;


-(void)syncPostRequestWithTmsKey:( NSString* __nonnull)tmsKey
                  dictionryValue:( NSDictionary* __nonnull)value
                         success:(KCTMSSuccessBlock __nullable)success
                            fail:(KCTMSErrorBlock __nullable)error;

@end
