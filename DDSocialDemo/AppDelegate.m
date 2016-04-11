//
//  AppDelegate.m
//  DDSocialDemo
//
//  Created by lilingang on 16/4/5.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "AppDelegate.h"
#import "DDMainViewController.h"

#import "DDSocialShareHandler.h"
#import "DDSocialAuthHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    DDMainViewController *viewController = [[DDMainViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.window.rootViewController = navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    [[DDSocialAuthHandler sharedInstance] registerMIApp:@"2882303761517373163" redirectURL:@"http://xiaomi.com"];
    
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformMI appKey:@"2882303761517373163" appSecret:@"" redirectURL:@"http://xiaomi.com" appDescription:@""];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformWeChat appKey:@"wxd930ea5d5a258f4f" appSecret:@"" redirectURL:@"" appDescription:@""];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformSina appKey:@"2045436852" appSecret:@"" redirectURL:@"" appDescription:@""];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformQQ appKey:@"222222" appSecret:@"" redirectURL:@"" appDescription:@""];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformFacebook appKey:@"125938537776820" appSecret:@"" redirectURL:@"" appDescription:@""];
    [[DDSocialShareHandler sharedInstance] registerPlatform:DDSSPlatformGoogle appKey:@"" appSecret:@"" redirectURL:@"" appDescription:@""];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[DDSocialShareHandler sharedInstance] application:application handleOpenURL:url sourceApplication:nil annotation:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[DDSocialShareHandler sharedInstance] application:application handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    return [[DDSocialShareHandler sharedInstance] application:app openURL:url options:options];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end
