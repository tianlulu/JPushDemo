//
//  AppDelegate+JPushService.h
//  JPUSHDemo
//
//  Created by TianLuLu on 2017/9/6.
//  Copyright © 2017年 TianLuLu. All rights reserved.
//

#import "AppDelegate.h"
//引入JSPush功能所需头文件
#import "JPUSHService.h"
//ios 10注册APNS所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate(JPushSDK)<JPUSHRegisterDelegate>
-(void)JPushApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
@end
