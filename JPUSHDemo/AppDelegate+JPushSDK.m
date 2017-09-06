//
//  AppDelegate+JPushService.m
//  JPUSHDemo
//
//  Created by TianLuLu on 2017/9/6.
//  Copyright © 2017年 TianLuLu. All rights reserved.
//

#import "AppDelegate+JPushSDK.h"
#import "YesViewController.h"
#import "NoViewController.h"

#define appJPushKey @"14a4aa6c6e997ef18d1e69ed"
#define isProduction NO

@implementation AppDelegate (JPushSDK)
-(void)JPushApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc]init];
    entity.types = JPAuthorizationOptionAlert | JPAuthorizationOptionBadge | JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
//        NSSet<UNNotificationCategory *> *categories for iOS10 or later
//        NSSet<UNUserNotificationCenter *> *categories for iOS8 and ios9
    }
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    /*
     appKey:填写管理Portal上创建应用后自动生成的AppKey值。请确保应用内配置的 AppKey 与 Portal 上创建应用后生成的 AppKey 一致。
     channel:指明应用程序包的下载渠道，为方便分渠道统计，具体值由你自行定义，如：App Store。
     apsForProduction:1.3.1版本新增，用于标识当前应用所使用的APNs证书环境。
     0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用。
     注：此字段的值要与Build Settings的Code Signing配置的证书环境一致。
     advertisingIdentifier:详见关于IDFA。
     */
    [JPUSHService setupWithOption:launchOptions appKey:appJPushKey channel:nil apsForProduction:isProduction advertisingIdentifier:nil];
}

//注册APNs成功并上报DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

//实现注册APNs失败接口（可选）
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
   NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

//请在AppDelegate.m实现该回调方法并添加回调方法中的代码
#pragma mark- JPUSHRegisterDelegate
//// iOS 10 Support  此状态为活跃状态 即app在前台获取通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler{
    // Required
    NSDictionary *userInfo = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionSound);
    //现在需要来处理自己的逻辑了(跳转等等)，现在推送的消息都在userInfo里面。。。。。。
    [self showAlWithDic:userInfo];
}

// iOS 10 Support 锁屏 横幅
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound); // // 系统要求执行这个方法
    //现在需要来处理自己的逻辑了(跳转等等)，现在推送的消息都在userInfo里面。。。。。。
    [self showAlWithDic:userInfo];
}

//活跃状态 锁屏进来
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    //现在需要来处理自己的逻辑了(跳转等等)，现在推送的消息都在userInfo里面。。。。。。
    [self showAlWithDic:userInfo];
}

//活跃状态
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    
    //    NSInteger num = [UIApplication sharedApplication].applicationIconBadgeNumber;
    //    [UIApplication sharedApplication].applicationIconBadgeNumber = num + 1;
   //现在需要来处理自己的逻辑了(跳转等等)，现在推送的消息都在userInfo里面。。。。。。
    [self showAlWithDic:userInfo];
}


- (void) showAlWithDic:(NSDictionary *) userInfo{
    NSLog(@"userInfo--%@",userInfo);
    NSString * message = userInfo[@"aps"][@"alert"];
    NSString *titleStr = @"新的消息";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleStr message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        YesViewController *vc = [[YesViewController alloc]init];
        [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
        
    }];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NoViewController *vc = [[NoViewController alloc]init];
        [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
    }];
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    [alertController addAction:yesAction];
    [alertController addAction:noAction];
}
@end
