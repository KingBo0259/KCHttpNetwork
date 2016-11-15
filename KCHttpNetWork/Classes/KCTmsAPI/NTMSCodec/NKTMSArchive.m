//
//  NKTMSArchive.m
//  KCHttpNetworkDemo
//  xx
//  Created by jinlb on 2016/11/15.
//  Copyright © 2016年 jinlb. All rights reserved.
//

#import "NKTMSArchive.h"
#import "JSONModel.h"
#import "NTMSRequestProtocol.h"
@implementation NKTMSArchive

/**
 将请求对象 编码成字符串

 
 @param request [JSONModel1,{key2:JSONModel},key3] ; JSonModel形式传入，字典形式传入，key3直接穿入

 @return 返回json 对象
 */
-(id)encodeFromArray:(NSArray*)request{
    
    __block NSMutableString *mutbaleStr=[[NSMutableString alloc]init];
    
    [request enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary * value;
        NSString * tmsKey;
        NSString * tmsValue;
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
        if (obj&&[obj isKindOfClass:[JSONModel class]] ) {
            //JsonModel 对象解析
            value=[((JSONModel*)obj) toDictionary];
            for (NSString * key in [value allKeys]) {
                if ([value objectForKey:key] == nil || [value objectForKey:key] == [NSNull null]){
                    continue;
                }
                [dic setObject:[value objectForKey:key] forKey:key];
            }
            NSError *parseError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
            tmsValue = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            //从实例中获取
            BOOL  isRequetProtocol=[obj conformsToProtocol:@protocol(NTMSRequestProtocol)];
            if (isRequetProtocol) {
                id<NTMSRequestProtocol> tempProtocolObj=obj;
                tmsKey=[tempProtocolObj setServiceName];
            }else{
                tmsKey=@"UnDefine";
            }
        }else if(obj&&[obj isKindOfClass:[NSDictionary class]]){
            //入参形式入： {tmsKey:{json}}
            tmsKey= [[((NSDictionary*)obj) allKeys] firstObject];
            
            NSDictionary *requestValue=[[((NSDictionary*)obj) allValues] firstObject];
            NSError *parseError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestValue options:NSJSONWritingPrettyPrinted error:&parseError];
            //json Value
            tmsValue = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            
            
        }else
        {
            //如果没有入参数
            tmsValue=@"{}";
            tmsKey=obj;
        }
        NSString*tempStr=[NSString stringWithFormat:@"service=%@&params=%@&",tmsKey,tmsValue];
        [mutbaleStr appendString:tempStr];
        
    }];
    
    //最后一步去掉‘&‘分隔符
    return [mutbaleStr substringToIndex:mutbaleStr.length-1];
}

@end
