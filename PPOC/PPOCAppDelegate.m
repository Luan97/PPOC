//
//  PPOCAppDelegate.m
//  PPOC
//
//  Created by Luan-Ling Chiang on 7/19/14.
//  Copyright (c) 2014 gdeformer. All rights reserved.
//

#import "PPOCAppDelegate.h"

@implementation PPOCAppDelegate
@synthesize model = _model;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //get singleton AppModel for handling data retrieve and stroe to core data
    _model = [PPOCAppModel sharedInstance];
    //fetch data
    [_model fetchData];
    
    //customize UINavigationBar layout
    [self customizeAppearance];
    
    return YES;
}

- (void)customizeAppearance
{
    // Create image for navigation background - portrait
    UIImage *NavigationPortraitBackground = [[UIImage imageNamed:@"NavBackground_P"]
                                             resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    // Create image for navigation background - landscape
    UIImage *NavigationLandscapeBackground = [[UIImage imageNamed:@"NavBackground_L"]
                                              resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    // Set the background image all UINavigationBars
    [[UINavigationBar appearance] setBackgroundImage:NavigationPortraitBackground
                                       forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:NavigationLandscapeBackground
                                       forBarMetrics:UIBarMetricsLandscapePhone];
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
