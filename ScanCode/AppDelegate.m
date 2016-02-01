//
//  AppDelegate.m
//  ScanCode
//
//  Created by TaoXinle on 15/11/2.
//  Copyright © 2015年 TaoXinle. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configShortCutItems];
    // Override point for customization after application launch.
    return YES;
}

- (void)configShortCutItems {
    NSMutableArray *shortcutItems = [NSMutableArray array];
    UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc] initWithType:@"1" localizedTitle:@"Scan from Camera" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"scanimage"] userInfo:nil];
    UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc] initWithType:@"2" localizedTitle:@"Scan from Photo" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"scanlib"] userInfo:nil];
    UIApplicationShortcutItem *item3 = [[UIApplicationShortcutItem alloc] initWithType:@"3" localizedTitle:@"Generate QR Code" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"generateicon"] userInfo:nil];
    [shortcutItems addObject:item1];
    [shortcutItems addObject:item2];
    [shortcutItems addObject:item3];
    
    [[UIApplication sharedApplication] setShortcutItems:shortcutItems];
}

// 处理shortcutItem
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectVC" object:[NSNumber numberWithInteger:shortcutItem.type.integerValue]];
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
