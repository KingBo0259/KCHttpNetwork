//
//  KCTMSFactory+NSingle.m
//  KCHttpNetworkDemo
//   
//  Created by jinlb on 2016/11/15.
//  Copyright © 2016年 jinlb. All rights reserved.
//

#import "KCTMSFactory+NSingle.h"
#import "NTMSRequestProtocol.h"
#import "KCHTTPSessionManager.h"

@implementation KCTMSFactory (NSingle)
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
                  fail:(KCTMSErrorBlock )error{
    
    BOOL isRequestProtocol=[requestValue conformsToProtocol:@protocol(NTMSRequestProtocol) ];
    NSString *responseClass=nil;
    if (isRequestProtocol) {
        id<NTMSRequestProtocol> tempRequestProtocol=(id<NTMSRequestProtocol>)requestValue;
        responseClass=[tempRequestProtocol setResponseClassName];
    }
    [self postNTMSWithURL:urlStr value:requestValue reponseClass:responseClass success:success fail:error];
}

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
{
    if (!key) {return;}
    
    //这里需要组合  @{key：value}
    [self postNTMSWithURL:urlStr value:@{key:requestValue} reponseClass:responseClass success:success fail:error];


}



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
                  fail:(KCTMSErrorBlock )error{
    [self postNTMSWithURL:urlStr value:key reponseClass:responseClass success:success fail:error];

    
}

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
                  fail:(KCTMSErrorBlock )error{

    //1、将请求参数 封装成tms指定的json组装格数
    NSString *bodyStr=[[self getEncoder] encodeFromArray:@[value]];//编码数据
    NSLog(@"bodyStr = %@ ",bodyStr);
    
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval=15.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
    request.HTTPBody=[bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    
    if ([KCTMSFactoryHeader getToken] ) {
        [request setValue:[KCTMSFactoryHeader getToken] forHTTPHeaderField:@"tkey"];
    }
    
    //    [request setValue:@"backend-service-factory" forHTTPHeaderField:@"from-source"];//不需要登录设置
    
    KCHTTPSessionManager *manager=[KCHTTPSessionManager shareInstance];
    
    NSURLSessionDataTask *task= [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error1) {
        
        if (error1) {
            if (error){
                error(error1);
            }
            return ;
        }
        
        id  tmsResponse= [[self getDecoder] deccodeToSingleNativeFromServiceResponse:responseObject withResponseClass:responseClass];
        if (success) {
            
            if([responseObject[@"status"] integerValue] == 401){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kReLogin" object:nil];
            }
            success(tmsResponse);
        }
        
        
    }];
    
    
    //启动方法
    [task resume];
    
}



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
                             fail:(KCTMSErrorBlock )error
{
   
    NSURL *tempUrl = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:tempUrl];
    request.timeoutInterval=15.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
    
    if ([KCTMSFactoryHeader getToken] ) {
        [request setValue:[KCTMSFactoryHeader getToken] forHTTPHeaderField:@"tkey"];
    }
    
    KCHTTPSessionManager *manager=[KCHTTPSessionManager shareInstance];
    
    NSURLSessionDataTask *task = [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imageData =UIImageJPEGRepresentation(photoImg,0.7);
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"filename"
                                fileName:imageName
                                mimeType:@"image/png"];
        NSLog(@"------%@",formData);
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        id  tmsResponse= [[self getDecoder] deccodeToSingleNativeFromServiceResponse:responseObject withResponseClass:responseClass];
        if (success) {
            success(tmsResponse);
            if([responseObject[@"status"] integerValue] == 401){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kReLogin" object:nil];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error1) {
        if (error1) {
            error(error1);
        }

    }];
    
    
}


/**
 删除图片
 @param success 成功
 @param error 失败
 */
+(void)postNTMSDeleteUploadImageWithURL:(NSString *)url
                               filePath:(NSString *)filePath
                           reponseClass:(NSString*)responseClass
                                success:(KCTMSSuccessBlock )success
                                   fail:(KCTMSErrorBlock )error
{
    NSString *urlStr =[NSString stringWithFormat:@"%@/delete?filePath=%@",url,filePath];
    NSURL *tempUrl = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:tempUrl];
    request.timeoutInterval=15.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
    
    if ([KCTMSFactoryHeader getToken] ) {
        [request setValue:[KCTMSFactoryHeader getToken] forHTTPHeaderField:@"tkey"];
    }
    
    KCHTTPSessionManager *manager=[KCHTTPSessionManager shareInstance];
    NSURLSessionDataTask *task= [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error1) {
        
        if (error1) {
            if (error){
                error(error1);
            }
            return ;
        }
        id  tmsResponse= [[self getDecoder] deccodeToSingleNativeFromServiceResponse:responseObject withResponseClass:responseClass];
        if (success) {
            success(tmsResponse);
            
            if([responseObject[@"status"] integerValue] == 401){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kReLogin" object:nil];
            }
        }

        
        
    }];
    
    
    //启动方法
    [task resume];
}




@end
