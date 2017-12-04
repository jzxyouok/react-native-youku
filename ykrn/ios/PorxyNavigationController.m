//
//  PorxyNavigationController.m
//  TestYKMediaPlayer
//
//  Created by weixinghua on 13-7-2.
//  Copyright (c) 2013年 Youku Inc. All rights reserved.
//

#import "PorxyNavigationController.h"

@interface PorxyNavigationController ()

@end

@implementation PorxyNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarHidden = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (self.supportPortraitOnly) {
        return UIInterfaceOrientationPortrait == toInterfaceOrientation;
    }else {
        return [self.topViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.supportPortraitOnly) {
        return UIInterfaceOrientationMaskPortrait;
    }else{
        return [self.topViewController supportedInterfaceOrientations];
    }
}

// New Autorotation support.
- (BOOL)shouldAutorotate {
    if (self.supportPortraitOnly) {
        return NO;
    }else{
        return [self.topViewController shouldAutorotate];
    }
}

@end
