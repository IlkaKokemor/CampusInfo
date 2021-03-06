//
//  CampusInfo1AppDelegate.m
//  CampusInfo1
//
//  Created by Ilka Kokemor on 3/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CampusInfo1AppDelegate.h"
#import "PersonDto.h"
#import "RoomDto.h"
#import "SchoolClassDto.h"

@implementation CampusInfo1AppDelegate


@synthesize window           =_window;
@synthesize tabBarController =_tabBarController;




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    // Override point for customization after application launch.
    // Add the tab bar controller's current view as a subview of the window
    //NSLog(@"Start Application");
    
    // sleep to test launch screen
    //[NSThread sleepForTimeInterval:10.0];
    
    // those two lines are needed for shaking 
    application.applicationSupportsShakeToEdit = YES;
     [self.window setRootViewController:self.tabBarController];

    
    //NSUserDefaults *_acronymUserDefaults = [NSUserDefaults standardUserDefaults];
    //NSString *_ownStoredAcronymString    = [_acronymUserDefaults stringForKey:@"TimeTableAcronym"];
    
    //if (_ownStoredAcronymString == nil)
    //    [self.tabBarController setSelectedIndex: 1]; // set search view
    //else
    //    [self.tabBarController setSelectedIndex: 0]; // set timetable view
    
    // always start with menu overview
    [self.tabBarController setSelectedIndex: 0];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/*
- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"controller class: %@", NSStringFromClass([viewController class]));
    NSLog(@"controller title: %@", viewController.title);
}
 */

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
