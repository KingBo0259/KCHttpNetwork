//
//  KCTMSUnarchive.m
//  KBFuny
//
//  Created by jinlb on 16/4/21.
//  Copyright © 2016年 jinlb. All rights reserved.
//

#import "KCTMSUnarchive.h"
#import <JSONModel/JSONModel.h>
#import "KCTMSRpcResponse.h"

static NSMutableDictionary *_tmsResponseMap;//出参映射表
@implementation KCTMSUnarchive

+(void)initialize{

    if (self==[KCTMSUnarchive class]) {
        _tmsResponseMap=[[NSMutableDictionary alloc]init];
    }

}


+(NSMutableDictionary*)getTmsResponseMap{

    return _tmsResponseMap;
}

///设置出参映射表
+(void)setResposneClass:(Class)reponseClass forTmsKey:(NSString*)key{

    [_tmsResponseMap setObject:NSStringFromClass(reponseClass) forKey:key];
}

+(void)setResposneString:(NSString*)reponseString forTmsKey:(NSString*)key{
    [_tmsResponseMap setObject:reponseString forKey:key];

}

#pragma mark DecodeProtocol
//这里返回的是 Dictionary
-(id)decodeToNativeFromServiceResponse:(id)servicereResponse{
    //    NSString *html = servicereResponse;
    //    //转为NSDiction
    //    NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dict=servicereResponse;

    //一级分离出  status 、message  、yij
    NSInteger status= [dict[@"status"] integerValue];
    NSString *message= dict[@"message"];
    
    __block KCTMSRpcResponse *tmsResponse=[[KCTMSRpcResponse alloc]init];
    [tmsResponse setStatus:status];
    [tmsResponse setMessage:message];
    
    //获取json 对象结构数据
    NSDictionary *body=dict[@"body"];
    
    //将json  结构转化为 KCTMSRpcseponse 对象
    NSDictionary *responseBody=[self decodeRpcResponeFromTMSJson:body ];
    
    [tmsResponse setBody:responseBody];
    return tmsResponse;
}

#pragma mark - decode

///解码单个对象
-(id)deccodeToSingleNativeFromServiceResponse:(id)serviceResponse
                            withResponseClass:(NSString*)responseClass{
    
    //    NSString *html = servicereResponse;
    //    //转为NSDiction
    //    NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dict=serviceResponse;
    
    //一级分离出  status 、message  、yij
    NSInteger status= [dict[@"status"] integerValue];
    NSString *message= dict[@"message"];
    
    __block KCTMSRpcResponse *tmsResponse=[[KCTMSRpcResponse alloc]init];
    [tmsResponse setStatus:status];
    [tmsResponse setMessage:message];
    //获取json 对象结构数据
    NSDictionary *body=dict[@"body"];
    
    //不等于200说明错误  则直接反回
    if(status!=200||!body)return tmsResponse;
    
    if (!responseClass||responseClass.length==0) {
        //若不需要解码 则直接返回
        [tmsResponse setBody:body];
    }else if ([body isKindOfClass:[NSDictionary class]]) {//字典解析
        //上下文传入对象
        id class= NSClassFromString(responseClass);
        //最外层TMSKey 值 如:{}
        [body enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSError *error;
            
            if ([obj isKindOfClass:[NSArray class]]) {
                // 格式如:TMSReconciliationAPI.getStatementsForDatePeriod={[name:""],[name:"'],[name:""]}
                //1、数组解析
               __block NSMutableArray *arrayObj=[NSMutableArray new];
                
                [obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    NSError *objError;
                    id entity=[[class alloc] initWithDictionary:obj error:&objError];
                    if (entity) {
                        [arrayObj addObject:entity];
                    }
                }];
                [tmsResponse setBody:arrayObj];
                
            }else{
                
                //格式如： TMSReconciliationAPI.getStatementsForDatePeriod={"countKey": "", "startTime": "", "operator": "", "endTime": "", "page": "", "size": ""}
                //2、单个对象解析
            id responseObject=[[class alloc] initWithDictionary:obj error:&error];
                [tmsResponse setBody:responseObject];
            }
        }];
    }else {
        [tmsResponse setBody:body];
    
    }
    
    return tmsResponse;
    
    
}


/*
 * 将 TMSjson 对象映射成  本地对象
 * @body  这里是字典，因为已经将json 转为字典了
 * @map   key  和本地对象的映射关系
 */
-(NSDictionary*)decodeRpcResponeFromTMSJson:(NSDictionary*)body{
    
    if(![body isKindOfClass:[NSDictionary class]])return body;

    __block NSMutableDictionary* resultDic=[[NSMutableDictionary alloc]initWithCapacity:body.count];
    //反回多个结果集
    [body enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        // 整整的数据，单个请求数据只有一级目录结构
        id bodyJson= obj;
        NSError *error;
        
        NSString* classString= [_tmsResponseMap objectForKey:key];
        if (!classString) {
            [resultDic setValue:bodyJson forKey:key];
            
        }else{
            
            id class= NSClassFromString(classString);
            //NSArray 解析
            if ([obj isKindOfClass:[NSArray class]]) {
               __block NSMutableArray *arrayObj=[[NSMutableArray alloc]init];
                
                [obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSError *itemError=nil;
                    id item=[[class alloc] initWithDictionary:obj error:&itemError];
                    [arrayObj addObject:item];
                }];
                [resultDic setValue:arrayObj forKey:key];
                
            }else{
                //单个对象解码
                id response=[[class alloc] initWithDictionary:bodyJson error:&error];
                [resultDic setValue:response forKey:key];
            }
        }
        
    }];
    return resultDic;
}

@end
