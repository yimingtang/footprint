//
//  FPTProfileViewController.m
//  Footprint
//
//  Created by Yiming Tang on 7/25/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

@import SVPullToRefresh;
#import "FPTProfileViewController.h"
#import "FPTSettingsViewController.h"
#import "FPTUser.h"
#import "FPTFootprint.h"
#import "FPTPost.h"
#import "FPTFootprintAPIClient.h"

@implementation FPTProfileViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Profile", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings", nil) style:UIBarButtonItemStylePlain target:self action:@selector(showSettings:)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self refresh:nil];
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.loading = NO;
    [self refresh:nil];
}


#pragma mark - SSManagedViewController

- (Class)entityClass {
    return [FPTFootprint class];
}


- (NSPredicate *)predicate {
    return [NSPredicate predicateWithFormat:@"user = %@", [FPTUser currentUser]];
}


#pragma mark - SSManagedTableViewController

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    FPTFootprint *footprint = [self objectForViewIndexPath:indexPath];
    
    cell.textLabel.text = footprint.post.title;
}


#pragma mark - Actions

- (void)showSettings:(id)sender {
    FPTSettingsViewController *settingsViewController = [[FPTSettingsViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}


- (void)refresh:(id)sender {
    if (self.loading || ![FPTUser currentUser]) {
        return;
    }
    
    self.loading = YES;
    FPTFootprintAPIClient *client = [FPTFootprintAPIClient sharedClient];
    [client getMyFootprintsWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.loading = NO;
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.loading = NO;
        });
    }];
}

@end
