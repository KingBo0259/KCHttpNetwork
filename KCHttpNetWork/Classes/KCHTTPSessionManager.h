//
//  KCHTTPSessionManager.h
//  KCHttpNetworkDemo
//  主要实现单里解决 内存泄漏问题
//  Created by jinlb on 2016/12/6.
//  Copyright © 2016年 jinlb. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface KCHTTPSessionManager : AFHTTPSessionManager
+(instancetype)shareInstance;
@end
