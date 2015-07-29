//
//  FPTFootprintsViewController.m
//  Footprint
//
//  Created by Yiming Tang on 7/25/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "FPTFootprintsViewController.h"
#import "FPTProfileViewController.h"
#import "FPTSignInViewController.h"

@implementation FPTFootprintsViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Footprint", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Profile", nil) style:UIBarButtonItemStylePlain target:self action:@selector(showProfile:)];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    FPTSignInViewController *signInViewController = [[FPTSignInViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:signInViewController];
    [self presentViewController:navigationController animated:animated completion:nil];
}


#pragma mark - Actions

- (void)showProfile:(id)sender {
    FPTProfileViewController *profileViewController = [[FPTProfileViewController alloc] init];
    [self.navigationController pushViewController:profileViewController animated:YES];
}

@end
