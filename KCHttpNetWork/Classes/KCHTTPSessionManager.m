//
//  KCHTTPSessionManager.m
//  KCHttpNetworkDemo
//
//  Created by jinlb on 2016/12/6.
//  Copyright © 2016年 jinlb. All rights reserved.
//

#import "KCHTTPSessionManager.h"
@implementation KCHTTPSessionManager
+(instancetype)shareInstance{

    static KCHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[self manager];
        
        // 2.设置证书模式
        //先导入证书，找到证书的路径
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"NTMSCertificate" ofType:@"cer"];
        NSData *certData = [NSData dataWithContentsOfFile:cerPath];
        
        //AFSSLPinningModeCertificate 使用证书验证模式
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        
        //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
        //如果是需要验证自建证书，需要设置为YES
        securityPolicy.allowInvalidCertificates = YES;
        
        //validatesDomainName 是否需要验证域名，默认为YES；
        //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
        //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
        //如置为NO，建议自己添加对应域名的校验逻辑。
        securityPolicy.validatesDomainName = NO;
        NSArray *certificatesArr =[[NSArray alloc] initWithObjects:certData,nil];
        //NSSet *set = [[NSSet alloc] initWithObjects:certData, nil];
        securityPolicy.pinnedCertificates = certificatesArr;
        
        
        //        //2.设置非校验证书模式
        //        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        //        manager.securityPolicy.allowInvalidCertificates = YES;
        //        //设置超时
        //        manager.requestSerializer.timeoutInterval=15.0f;
        //        [manager.securityPolicy setValidatesDomainName:NO];
        
    });
    return manager;

}

@end
