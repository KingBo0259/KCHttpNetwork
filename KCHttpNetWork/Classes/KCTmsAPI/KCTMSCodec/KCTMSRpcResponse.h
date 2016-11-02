//
//  KCTMSRpcResponse.h
//  KBFuny
//
//  Created by jinlb on 16/4/20.
//  Copyright © 2016年 jinlb. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface KCTMSRpcResponse: NSObject
@property(nonatomic,assign)NSInteger status;
@property(nonatomic,copy) NSString*message;
@property(nonatomic,strong) id body;
@end
