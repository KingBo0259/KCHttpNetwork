//
//  KCHttpEnum.h
//  kuaihuoyun
//
//  Created by jinlb on 15/9/18.
//  Copyright (c) 2015年 banyanan. All rights reserved.
//

#ifndef kuaihuoyun_KCHttpEnum_h
#define kuaihuoyun_KCHttpEnum_h


typedef NS_ENUM(NSInteger,KC_HTTP_STATE)
{
    KC_HTTP_SUCCESS    =200, //hessian 所有返回成功的状态
    KC_HTTP_URL_EXPIRE =301  //老接口过期，需要升级软件
};

#endif
