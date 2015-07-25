//
//  FPTProfileViewController.m
//  Footprint
//
//  Created by Yiming Tang on 7/25/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "FPTProfileViewController.h"
#import "FPTSettingsViewController.h"

@implementation FPTProfileViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Profile", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings", nil) style:UIBarButtonItemStylePlain target:self action:@selector(showSettings:)];
    
    self.view.backgroundColor = [UIColor whiteColor];
}


#pragma mark - Actions

- (void)showSettings:(id)sender {
    FPTSettingsViewController *settingsViewController = [[FPTSettingsViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
