//
//  AppDelegate.m
//  My Weight
//
//  Created by Александр Карцев on 9/15/15.
//  Copyright (c) 2015 Alex Kartsev. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse setApplicationId:@"ZqhmBUDBzmPsxE0ZLw8158wM235pGe9PSfgJ1tFZ"
                  clientKey:@"37QgrQyJlrlJIDPgy2G2a4sxCt7aoOAIvvPy9Oi9"];

    [[DataManager sharedManager] deleteAllObjects];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
