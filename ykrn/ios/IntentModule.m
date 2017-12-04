//
//  IntentModule.m
//  rntest
//
//  Created by mini on 2017/11/6.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "IntentModule.h"
#import <React/RCTBridgeModule.h>


@implementation IntentModule
@synthesize bridge = _bridge;

RCT_EXPORT_MODULE(IntentModule)
//RN跳转原生界面
RCT_EXPORT_METHOD(startActivityFromJS:(NSString *)msg){
  
  NSLog(@"RN传入原生界面的数据为:%@",msg);
  //主要这里必须使用主线程发送,不然有可能失效
  dispatch_async(dispatch_get_main_queue(), ^{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"startActivityFromJS" object:nil];
  });
}


@end
