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
    });
    return manager;

}
@end
