//
//  KCTMSUnarchive.h
//  KBFuny
//
//  Created by jinlb on 16/4/21.
//  Copyright © 2016年 jinlb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCTMSDecodeProtocol.h"

@interface KCTMSUnarchive : NSObject<KCTMSDecodeProtocol>

+(NSMutableDictionary*)getTmsResponseMap;

///设置出参映射表
+(void)setResposneClass:(Class)reponseClass forTmsKey:(NSString*)key;

//反回对象名字
+(void)setResposneString:(NSString*)reponseString forTmsKey:(NSString*)key;


@end
