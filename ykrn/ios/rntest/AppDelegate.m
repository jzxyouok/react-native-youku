/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "AppDelegate.h"

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import "NativeActivity.h"



@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  NSURL *jsCodeLocation;

  jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];

  RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                      moduleName:@"rntest"
                                               initialProperties:nil
                                                   launchOptions:launchOptions];
  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
//  self.window.rootViewController = rootViewController;
//  [self.window makeKeyAndVisible];
  
//  //关键代码
//  _nav=[[UINavigationController alloc]initWithRootViewController:rootViewController];
//  _nav.navigationBarHidden = YES;
//
//  self.window.rootViewController = _nav;
  
  _navViewController = [[PorxyNavigationController alloc] initWithRootViewController:rootViewController];
  _navViewController.supportPortraitOnly = NO;
  //   _navViewController.navigationBar.hidden = YES;
  self.window.rootViewController = _navViewController;
  
  [self.window makeKeyAndVisible];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doNotification:) name:@"startActivityFromJS" object:nil];
  
  return YES;
}
-(void)doNotification:(NSNotification *)notification
{
  NSLog(@"成功收到===>通知");
  //将通知里面的userInfo取出来，使用
  //[self.nav pushViewController:[NativeActivity new] animated:YES];
  [self.navViewController pushViewController:[NativeActivity new] animated:YES];
  
  //  //第三步移除通知
  //  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startActivityFromJS" object:nil];
  
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  
}


@end
