//
//  NKTMSUnArchive.m
//  KCHttpNetworkDemo
//
//  Created by jinlb on 2016/11/15.
//  Copyright © 2016年 jinlb. All rights reserved.
//

#import "NKTMSUnArchive.h"
#import <JSONModel/JSONModel.h>
#import "KCTMSRpcResponse.h"

@implementation NKTMSUnArchive


/*
 * 解码单个对象
 * @serviceResponse    服务器端返回的数据
 * @responseClass      单个返回对象类
 */
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
    NSDictionary *body=dict[@"data"];
    
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
@end
