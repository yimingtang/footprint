//
//  FPTSignInViewController.m
//  Footprint
//
//  Created by Yiming Tang on 7/29/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

@import SVProgressHUD;
#import "FPTSignInViewController.h"
#import "FPTFootprintAPIClient.h"

static NSString *const kFPTSignInViewControllerCellIdentifier = @"cell";

@interface FPTSignInViewController () <UITextFieldDelegate>

@property (nonatomic) UITextField *usernameTextField;
@property (nonatomic) UITextField *passwordTextField;
@property (nonatomic) UITextField *passwordConfirmationTextField;
@property (nonatomic) UIButton *footerButton;
@property (nonatomic) BOOL signUpMode;

@end


@implementation FPTSignInViewController

#pragma mark - Accessors

- (UITextField *)usernameTextField {
    if (!_usernameTextField) {
        _usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[self class] textFieldWidth], 30.0f)];
        _usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _usernameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _usernameTextField.delegate = self;
        _usernameTextField.returnKeyType = UIReturnKeyNext;
        _usernameTextField.font = [UIFont systemFontOfSize:18.0f];
    }
    return _usernameTextField;
}


- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[self class] textFieldWidth], 30.0f)];
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _passwordTextField.delegate = self;
        _passwordTextField.returnKeyType = UIReturnKeyNext;
        _passwordTextField.font = [UIFont systemFontOfSize:18.0f];
    }
    return _passwordTextField;
}


- (UITextField *)passwordConfirmationTextField {
    if (!_passwordConfirmationTextField) {
        _passwordConfirmationTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[self class] textFieldWidth], 30.0f)];
        _passwordConfirmationTextField.secureTextEntry = YES;
        _passwordConfirmationTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _passwordConfirmationTextField.delegate = self;
        _passwordConfirmationTextField.returnKeyType = UIReturnKeyGo;
        _passwordConfirmationTextField.font = [UIFont systemFontOfSize:18.0f];
        _passwordConfirmationTextField.placeholder = NSLocalizedString(@"Confirm your password", nil);
    }
    return _passwordConfirmationTextField;
}


- (UIButton *)footerButton {
    if (!_footerButton) {
        _footerButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 34.0f)];
        [_footerButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_footerButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_footerButton addTarget:self action:@selector(toggleMode:) forControlEvents:UIControlEventTouchUpInside];
        _footerButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    return _footerButton;
}

#pragma mark - Class Methods

+ (CGFloat)textFieldWidth {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 360.0f : 240.0f;
}


#pragma mark - NSObject

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (id)init {
    if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
        _signUpMode = NO;
    }
    return self;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Footprint", nil);
    self.tableView.tableFooterView = self.footerButton;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kFPTSignInViewControllerCellIdentifier];
    
    // Register notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChanged:) name:UITextFieldTextDidChangeNotification object:self.usernameTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChanged:) name:UITextFieldTextDidChangeNotification object:self.passwordTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChanged:) name:UITextFieldTextDidChangeNotification object:self.passwordConfirmationTextField];
    
    [self toggleModeAnimated:NO];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.usernameTextField becomeFirstResponder];
}


#pragma mark - Actions

- (void)toggleMode:(id)sender {
    [self toggleModeAnimated:YES];
}


- (void)signIn:(id)sender {
    if (!self.navigationItem.rightBarButtonItem.enabled) {
        return;
    }
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Signing in…", nil)];
    
    FPTFootprintAPIClient *client = [FPTFootprintAPIClient sharedClient];
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [client signInWithUsername:username password:password success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Signed In", nil)];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString *message = [error.localizedDescription capitalizedString];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [SVProgressHUD showErrorWithStatus:message];
        });
    }];
}


- (void)signUp:(id)sender {
    if (!self.navigationItem.rightBarButtonItem.enabled) {
        return;
    }
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Signing up…", nil)];
    
    FPTFootprintAPIClient *client = [FPTFootprintAPIClient sharedClient];
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;

    [client signUpWithUsername:username password:password success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Signed Up", nil)];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString *message = [error.localizedDescription capitalizedString];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:message];
        });
    }];
}


#pragma mark - Private

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"Username", nil);
        cell.accessoryView = self.usernameTextField;
    } else if (indexPath.row == 1) {
        cell.textLabel.text = NSLocalizedString(@"Password", nil);
        cell.accessoryView = self.passwordTextField;
    } else if (indexPath.row == 2) {
        cell.textLabel.text = NSLocalizedString(@"Confirm", nil);
        cell.accessoryView = self.passwordConfirmationTextField;
    } else {
        // Should never reach here
        cell.textLabel.text = nil;
        cell.accessoryView = nil;
    }
}


- (void)toggleModeAnimated:(BOOL)animated {
    NSArray *confirmation = @[[NSIndexPath indexPathForRow:2 inSection:0]];

    BOOL focusPassword = [self.passwordConfirmationTextField isFirstResponder];
    UITableViewRowAnimation animation = animated ? UITableViewRowAnimationTop : UITableViewRowAnimationNone;

    // Switch to sign in
    if (self.signUpMode) {
        self.signUpMode = NO;
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:confirmation withRowAnimation:animation];
        [self.tableView endUpdates];
        
        [self.footerButton setTitle:NSLocalizedString(@"Don't have an account? Sign Up →", nil) forState:UIControlStateNormal];
        
        self.usernameTextField.placeholder = NSLocalizedString(@"Your Username", nil);
        self.passwordTextField.placeholder = NSLocalizedString(@"Your password", nil);
        
        if (focusPassword) {
            [self.passwordTextField becomeFirstResponder];
        }
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Sign In", nil) style:UIBarButtonItemStyleDone target:self action:@selector(signIn:)];
    }

    // Switch to sign up
    else {
        self.signUpMode = YES;
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:confirmation withRowAnimation:animation];
        [self.tableView endUpdates];
        
        [self.footerButton setTitle:NSLocalizedString(@"Already have an account? Sign In →", nil) forState:UIControlStateNormal];
        
        self.usernameTextField.placeholder = NSLocalizedString(@"Choose a username", nil);
        self.passwordTextField.placeholder = NSLocalizedString(@"Choose a password", nil);
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up" style:UIBarButtonItemStyleDone target:self action:@selector(signUp:)];
    }

    [self validateButton];
}


- (void)validateButton {
    BOOL valid = self.usernameTextField.text.length >= 1 && self.passwordTextField.text.length >= 1;

    if (self.signUpMode && valid) {
        valid = [self.passwordTextField.text isEqualToString:self.passwordConfirmationTextField.text];
    }

    self.navigationItem.rightBarButtonItem.enabled = valid;
}


- (void)textFieldTextChanged:(NSNotification *)notification {
    [self validateButton];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.signUpMode ? 3 : 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFPTSignInViewControllerCellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [self validateButton];
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        if (self.signUpMode) {
            [self.passwordConfirmationTextField becomeFirstResponder];
        } else {
            [self signIn:textField];
        }
    } else if (textField == self.passwordConfirmationTextField) {
        [self signUp:textField];
    }
    return NO;
}

@end
