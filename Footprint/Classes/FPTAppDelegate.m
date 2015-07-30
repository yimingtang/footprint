//
//  FPTAppDelegate.m
//  Footprint
//
//  Created by Yiming Tang on 7/25/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "FPTAppDelegate.h"
#import "FPTFootprintsViewController.h"
@import SSDataKit;
@import AFNetworking;

@interface FPTAppDelegate ()

@end

@implementation FPTAppDelegate

#pragma mark - Accessors

@synthesize window = _window;

- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.backgroundColor = [UIColor whiteColor];
    }
    return _window;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Configure network stuff
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [SSManagedObject setAutomaticallyResetsPersistentStore:YES];
    
    // Set root view controller
    FPTFootprintsViewController *footprintsViewController = [[FPTFootprintsViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:footprintsViewController];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
