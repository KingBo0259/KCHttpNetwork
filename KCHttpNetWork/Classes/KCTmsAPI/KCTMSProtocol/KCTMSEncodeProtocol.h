//
//  KCTMSEncodeProtocol.h
//  KBFuny
//
//  Created by jinlb on 16/4/22.
//  Copyright © 2016年 jinlb. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KCTMSEncodeProtocol <NSObject>

@required
-(id)encodeFromArray:(NSArray*)request;

@end

