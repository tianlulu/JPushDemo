//
//  AppDelegate.m
//  JPUSHDemo
//
//  Created by TianLuLu on 2017/9/5.
//  Copyright © 2017年 TianLuLu. All rights reserved.
//

/**
 极光推送步骤与注意事项：
 1.创建应用： 上传APNs Development IOS证书的p12文件和Apple Push Service证书的p12文件
 2.appKey需要集成到项目中
 + (void)setupWithOption:(NSDictionary *)launchingOption appKey:(NSString *)appKey channel:(NSString *)channel apsForProductio (BOOL)isProduction advertisingIdentifier:(NSString *)advertisingId;
 3.上传证书的bundle必须与x-code 项目里面Bundle identifier一致（切记）
 4.导入sdk  pod 'JPush'
 5.开启Application Target的Capabilities->Push Notifications entitlement
 6.info.plist允许Xcode7支持Http传输方法 配置 间参考文档 https://docs.jiguang.cn/jpush/client/iOS/ios_guide_new/
 7.添加Delegate JPUSHRegisterDelegate 增加代理方法 见AppDelegate+JPushSDK
 */



#import "AppDelegate.h"
#import "AppDelegate+JPushSDK.h"

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self JPushApplication:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
