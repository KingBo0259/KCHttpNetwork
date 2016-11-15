//
//  KCTMSDecodeProtocol.h
//  KBFuny
//
//  Created by jinlb on 16/4/22.
//  Copyright © 2016年 jinlb. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KCTMSDecodeProtocol <NSObject>

@optional
///将服务器返回数据，解析到本地对象
-(id)decodeToNativeFromServiceResponse:(id)servicereResponse;


///解码单个对象
/*
 * @serviceResponse    服务器端返回的数据
 * @responseClass      单个返回对象类
 */
-(id)deccodeToSingleNativeFromServiceResponse:(id)serviceResponse
                              withResponseClass:(NSString*)responseClass;
@end
