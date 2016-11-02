//
//  KCTMSArchive.m
//  KBFuny
//
//  Created by jinlb on 16/4/21.
//  Copyright © 2016年 jinlb. All rights reserved.
//

#import "KCTMSArchive.h"
#import "JSONModel.h"
static NSMutableDictionary *_tmsRequestMap;//出参映射表

@implementation KCTMSArchive
+(void)initialize{

    if (self==[KCTMSArchive class]) {
        _tmsRequestMap=[[NSMutableDictionary alloc]init];
    }
}

+(void)setTmsKey:(NSString *)key forRequstModel:(Class)request{
    [_tmsRequestMap setObject:key forKey:NSStringFromClass(request)];

}

+(void)setTmsKey:(NSString*)key
 forRequstString:(NSString*)request{
    [_tmsRequestMap setObject:key forKey:request];

}


///将请求对象 编码成字符串
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
//                if ([[value objectForKey:key] isKindOfClass:[NSNumber class]] && [[value objectForKey:key] integerValue] < 0){
//                    continue;
//                }
                [dic setObject:[value objectForKey:key] forKey:key];
            }
            NSError *parseError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
            tmsValue = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            //注册中获取key
            tmsKey=[_tmsRequestMap objectForKey: NSStringFromClass([obj class])];
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
        NSString*tempStr=[NSString stringWithFormat:@"%@=%@&",tmsKey,tmsValue];
        [mutbaleStr appendString:tempStr];

    }];
    
    //最后一步去掉‘&‘分隔符
    return [mutbaleStr substringToIndex:mutbaleStr.length-1];
}


@end
