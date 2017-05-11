//
//  NTMSBaseService.m
//  KCHttpNetworkDemo
//
//  Created by jinlb on 2016/11/15.
//  Copyright © 2016年 jinlb. All rights reserved.
//

#import "NTMSBaseService.h"
#import "NKTMSArchive.h"
#import "NKTMSUnArchive.h"

//static  NSString *NTMSService=@"http://192.168.6.81:8091/ktms/service/call";
//static  NSString *NTMSService=@"http://192.168.6.109:8091/ktms/service/call";
//static  NSString *NTMSService=@"http://ktms-dev.kuaihuoyun.com/ktms/service/call";
//static  NSString *NTMSService=@"http://ktms-yf.kuaihuoyun.com/ktms/service/call";
static  NSString *NTMSService=@"https://ktms.kuaihuoyun.com/ktms/service/call";


//static  NSString *NTMSUploadService = @"http://ktms-dev.kuaihuoyun.com/ktms/file";
//static  NSString *NTMSUploadService=@"http://ktms-yf.kuaihuoyun.com/ktms/file";
static  NSString *NTMSUploadService=@"https://ktms.kuaihuoyun.com/ktms/file";

@implementation NTMSBaseService




+(void)initialize{
    //组合编码
    [KCTMSFactory initWithEncode:[NKTMSArchive new] decode:[NKTMSUnArchive new]];
}

+(void)setUserToken:(NSString*)token{
    [KCTMSFactoryHeader setToken:token];
}


/**
 单个JsonModel对象请求
 @param requestValue 请求对象，注意必须实现
 @param success 成功
 @param error 失败
 */
-(void)postNTMSWithValue:(JSONModel*)requestValue
               success:(KCTMSSuccessBlock )success
                  fail:(KCTMSErrorBlock )error{
    [KCTMSFactory postNTMSWithURL:NTMSService value:requestValue success:success fail:error];

    
}



/**
 以对象形式传入
 
 @param key serviceKey
 @param requestValue 请求字典对象@{}
 @param responseClass 返回的对象实例
 @param success 成功
 @param error 失败
 */
-(void)postNTMSWithKey:(NSString*)key
          requestValue:(NSDictionary*)requestValue
         responseClass:(NSString*)responseClass
               success:(KCTMSSuccessBlock )success
                  fail:(KCTMSErrorBlock )error{


    [KCTMSFactory postNTMSWithURL:NTMSService key:key requestValue:requestValue responseClass:responseClass success:success fail:error];

}

/**
 没有参数传入
 @param key serviceKey
 @param responseClass 返回的对象实例
 @param success 成功
 @param error 失败
 */ 
-(void)postNTMSWithKey:(NSString*)key
         responseClass:(NSString*)responseClass
               success:(KCTMSSuccessBlock )success
                  fail:(KCTMSErrorBlock )error{

    [KCTMSFactory postNTMSWithURL:NTMSService key:key responseClass:responseClass success:success fail:error];

}



/**
 小霸王项目单个对象万能请求
 
 @param value 请求value 对象为： JsonModel{包含key} 、@{key:@{}}、key
 @param responseClass 返回对象
 @param success 成功
 @param error 失败
 */
-(void)postNTMSWithValue:(id)value
          reponseClass:(NSString*)responseClass
               success:(KCTMSSuccessBlock )success
                  fail:(KCTMSErrorBlock )error{

    [KCTMSFactory postNTMSWithURL:NTMSService value:value reponseClass:responseClass success:success fail:error];

}

/*
 上传图片
 @param success 成功
 @param error 失败
 */
-(void)uploadImageWithImageName:(NSString *)imageName
                 photoImg:(UIImage *)photoImg
             reponseClass:(NSString*)responseClass
                  success:(KCTMSSuccessBlock )success
                     fail:(KCTMSErrorBlock )error
{
    NSString *urlStr =[NSString stringWithFormat:@"%@/upload",NTMSUploadService];
    [KCTMSFactory postNTMSUploadImageWithURL:urlStr imageName:imageName photoImg:photoImg reponseClass:responseClass success:success fail:error];
}


/*
 删除上传的图片
 @param success 成功
 @param error 失败
 */
-(void)deleteUploadImageWithFilePath:(NSString *)filePath
                        reponseClass:(NSString*)responseClass
                             success:(KCTMSSuccessBlock )success
                                fail:(KCTMSErrorBlock )error
{
    [KCTMSFactory postNTMSDeleteUploadImageWithURL:NTMSUploadService filePath:filePath reponseClass:responseClass success:success fail:error];
}

@end
