//
//  FPTFootprintsViewController.m
//  Footprint
//
//  Created by Yiming Tang on 7/25/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

@import DZNWebViewController;
@import SVPullToRefresh;
#import "FPTFootprintsViewController.h"
#import "FPTProfileViewController.h"
#import "FPTSignInViewController.h"
#import "FPTFootprint.h"
#import "FPTPost.h"
#import "FPTUser.h"
#import "FPTFootprintAPIClient.h"

@implementation FPTFootprintsViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Footprint", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Profile", nil) style:UIBarButtonItemStylePlain target:self action:@selector(showProfile:)];
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self refresh:nil];
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:animated];
    
    [self checkUser];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self refresh:nil];
}


#pragma mark - SSManagedViewController

- (Class)entityClass {
    return [FPTFootprint class];
}


- (void)setLoading:(BOOL)loading animated:(BOOL)animated {
    [super setLoading:loading animated:animated];
    
    if (loading) {
        [self.tableView.pullToRefreshView startAnimating];
    } else {
        [self.tableView.pullToRefreshView stopAnimating];
    }
}


#pragma mark - SSManagedTableViewController

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    FPTFootprint *footprint = [self objectForViewIndexPath:indexPath];
    
    cell.textLabel.text = footprint.post.title;
}


#pragma mark - Actions

- (void)showProfile:(id)sender {
    FPTProfileViewController *profileViewController = [[FPTProfileViewController alloc] init];
    [self.navigationController pushViewController:profileViewController animated:YES];
}


- (void)refresh:(id)sender {
    if (self.loading || ![FPTUser currentUser]) {
        return;
    }

    self.loading = YES;
    FPTFootprintAPIClient *client = [FPTFootprintAPIClient sharedClient];
    [client getGlobalFootprintsWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.loading = NO;
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.loading = NO;
        });
    }];
}


#pragma mark - Private

- (void)checkUser {
    if (![FPTUser currentUser]) {
        FPTSignInViewController *signInViewController = [[FPTSignInViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:signInViewController];
        [self presentViewController:navigationController animated:NO completion:nil];
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FPTFootprint *footprint = [self objectForViewIndexPath:indexPath];
    FPTPost *post = footprint.post;
    
    NSURL *URL = [NSURL URLWithString:post.url];
    
    DZNWebViewController *webViewController = [[DZNWebViewController alloc] initWithURL:URL];
    webViewController.supportedWebNavigationTools = DZNWebNavigationToolAll;
    webViewController.supportedWebActions = DZNWebActionAll;
    webViewController.showLoadingProgress = YES;
    webViewController.allowHistory = YES;
    webViewController.hideBarsWithGestures = YES;
    
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end
