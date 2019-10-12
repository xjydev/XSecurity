//
//  AppDelegate.m
//  XSecurity
//
//  Created by XiaoDev on 2019/9/9.
//  Copyright © 2019 XiaoDev. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftViewController.h"
#import "DrawerViewController.h"
#import "SafeView.h"
@interface AppDelegate ()
@property (nonatomic, strong)UINavigationController *mainNav;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    UIStoryboard *mainStoryB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LeftViewController *leftVC = [mainStoryB instantiateViewControllerWithIdentifier:@"LeftViewController"];
    self.mainNav = [mainStoryB instantiateViewControllerWithIdentifier:@"MainNav"];
    self.window.rootViewController = [[DrawerViewController alloc]initMainVC:self.mainNav leftVC:leftVC leftWidth:250];
    [self.window makeKeyAndVisible];
     [self showSafeView];
    return YES;
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self showSafeView];
    
}
/**
 显示安全锁界面
 */
- (void)showSafeView {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user objectForKey:KPassWord]) {
        [SafeView defaultSafeView].type = PassWordTypeDefault;
        [[SafeView defaultSafeView] showSafeViewHandle:^(NSInteger num) {
            
        }];
        
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
}

@end
