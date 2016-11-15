//
//  NTMSRequestProtocol.h
//  KCHttpNetworkDemo
//  外层对象请求需要实现改接口
//  Created by jinlb on 2016/11/15.
//  Copyright © 2016年 jinlb. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NTMSRequestProtocol <NSObject>

/**
 设置服务器接口名称， 一般只在最外层接口使用

 @return 服务器接口名称
 */
-(NSString*)setServiceName;



/**
 设置返回对象名称， 一般只在最外层接口使用
 @return 服务器接口名称
 */
-(NSString*)setResponseClassName;
@end
