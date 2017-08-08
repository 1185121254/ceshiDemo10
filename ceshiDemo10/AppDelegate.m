//
//  AppDelegate.m
//  ceshiDemo10
//
//  Created by chaojie on 2017/5/11.
//  Copyright © 2017年 chaojie. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

static NSString *jpushAppKey = @"79045655cfa005a5eb52c21a";
static NSString *JPushChannel = @"Publish channel";
// static BOOL JPushIsProduction = NO;
#ifdef DEBUG
// 开发 极光FALSE为开发环境
static BOOL const JPushIsProduction = FALSE;
#else
// 生产 极光TRUE为生产环境
static BOOL const JPushIsProduction = TRUE;
#endif

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    MainViewController *main = [[MainViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:main];
    self.window.rootViewController = nav;
    
    // 启动极光推送
    // Required
    // - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) // iOS10
    {
        JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = (UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound);
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    {
        // categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else
    {
        // categories nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    // Required
    // [JPUSHService setupWithOption:launchOptions]
    // pushConfig.plist appKey
    // 有广告符标识IDFA（尽量不用，避免上架审核被拒）
    /*
     NSString *JPushAdvertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
     [JPUSHService setupWithOption:JPushOptions
     appKey:JPushAppKey
     channel:JPushChannel
     apsForProduction:JPushIsProduction
     advertisingIdentifier:JPushAdvertisingId];
     */
    // 或无广告符标识IDFA（尽量不用，避免上架审核被拒）
    [JPUSHService setupWithOption:launchOptions
                           appKey:jpushAppKey
                          channel:JPushChannel
                 apsForProduction:JPushIsProduction];
    
    
    // 2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0)
        {
            // iOS10获取registrationID放到这里了, 可以存到缓存里, 用来标识用户单独发送推送
            NSLog(@"registrationID获取成功：%@",registrationID);
            [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"registrationID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
 
    
    return YES;
}

//注册
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}
//注册失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificwationsWithError:(NSError *)error
{
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
//接收
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // apn 内容获取：
    // 取得 APNs 标准信息内容
    [JPUSHService handleRemoteNotification:userInfo];
}
//iOS10以下版本时
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"2-1 didReceiveRemoteNotification remoteNotification = %@", userInfo);
    
    // apn 内容获取：
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    NSLog(@"2-2 didReceiveRemoteNotification remoteNotification = %@", userInfo);
    if ([userInfo isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = userInfo[@"aps"];
        NSString *content = dict[@"alert"];
        NSLog(@"content = %@", content);
    }
    
    if (application.applicationState == UIApplicationStateActive)
    {
        // 程序当前正处于前台
    }
    else if (application.applicationState == UIApplicationStateInactive)
    {
        // 程序处于后台
    }
}
//ios10以上版本时
// 当程序在前台时, 收到推送弹出的通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    // completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}
// 程序关闭后, 通过点击推送弹出的通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    completionHandler();  // 系统要求执行这个方法
}

@end
