//
//  KCTMSArchive.h
//  KBFuny
//
//  Created by jinlb on 16/4/21.
//  Copyright © 2016年 jinlb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCTMSEncodeProtocol.h"

@interface KCTMSArchive : NSObject<KCTMSEncodeProtocol>


+(void)setTmsKey:(NSString*)key
        forRequstModel:( Class)request;

+(void)setTmsKey:(NSString*)key
  forRequstString:(NSString*)request;

@end
