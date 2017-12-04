//
//  NativeActivity.h
//  rntest
//
//  Created by mini on 2017/11/6.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NativeActivity : UIViewController

@property (nonatomic, assign) BOOL islocal;
@property (nonatomic, retain) id videoItem;

- (id)initWithVid:(NSString *)vid platform:(NSString *)platform quality:(NSString *)quality;


@end
