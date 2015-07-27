//
//  FPTFootprintAPIClientTests.m
//  Footprint
//
//  Created by Yiming Tang on 7/26/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

@import XCTest;
#import "FPTFootprintAPIClient.h"
#import "NSString+FootprintKit.h"
#import "FPTUser.h"

@interface FPTFootprintAPIClientTests : XCTestCase

@property (nonatomic) FPTFootprintAPIClient *client;

@end

@implementation FPTFootprintAPIClientTests

- (void)setUp {
    [super setUp];
    
    self.client = [FPTFootprintAPIClient sharedClient];
}


- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


#pragma mark - User

- (void)testSignUpWithExistingUser {
    // given
    NSString *username = @"example_user";
    NSString *password = @"password";
    XCTestExpectation *expectation = [self expectationWithDescription:@"register with an existing user"];
    
    // when
    [self.client signUpWithUsername:username password:password success:^(NSURLSessionDataTask *task, id responseObject) {
        [expectation fulfill];
        
        NSDictionary *dictionary = responseObject;
        
        // then
        XCTAssertNotNil(responseObject, @"should have a responseObject");
        XCTAssertTrue([dictionary[@"ok"] integerValue] == 0, "should have status code: 0");
        XCTAssertNil(dictionary[@"data"], @"should not have data");
        XCTAssertNotNil(dictionary[@"error"], @"should have an error");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [expectation fulfill];
        XCTAssertNil(error, @"should not have an error");
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}


- (void)testSignUpWithNewUser {
    // given
    NSString *username = [NSString fpk_UUIDString];
    NSString *password = @"password";
    
    // when
    XCTestExpectation *expectation = [self expectationWithDescription:@"register a new user"];
    [self.client signUpWithUsername:username password:password success:^(NSURLSessionDataTask *task, id responseObject) {
        [expectation fulfill];
        
        NSDictionary *dictionary = responseObject;
        NSDictionary *data = dictionary[@"data"];
        // then
        XCTAssertNotNil(dictionary, @"should have a responseObject");
        XCTAssertTrue([dictionary[@"ok"] integerValue] == 1, "should have status code: 1");
        XCTAssertNotNil(data, @"should have data");
        XCTAssertTrue([data[@"userId"] integerValue] > 0, @"should have a userID");
        XCTAssertNotNil(data[@"token"], @"should have a token");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [expectation fulfill];
        
        // then
        XCTAssertNil(error, @"should not have an error");
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}


- (void)testSignInWithInvalidInfo {
    // given
    NSString *username = @"example_user";
    NSString *password = @"bbbbbbbb";
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"sign in with invalid password"];
    
    // when
    [self.client signInWithUsername:username password:password success:^(NSURLSessionDataTask *task, id responseObject) {
        [expectation fulfill];
        
        NSDictionary *dictionary = responseObject;
        
        // then
        XCTAssertNotNil(responseObject, @"should have a responseObject");
        XCTAssertTrue([dictionary[@"ok"] integerValue] == 0, "should have status code: 0");
        XCTAssertNil(dictionary[@"data"], @"should not have data");
        XCTAssertNotNil(dictionary[@"error"], @"should have an error");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [expectation fulfill];
        XCTAssertNil(error, @"should not have an error");
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}


- (void)testSignInWithValidInfo {
    // given
    NSString *username = @"example_user";
    NSString *password = @"password";
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"sign in with invalid info"];
    
    // when
    [self.client signInWithUsername:username password:password success:^(NSURLSessionDataTask *task, id responseObject) {
        [expectation fulfill];
        
        NSDictionary *dictionary = responseObject;
        NSDictionary *data = dictionary[@"data"];
        // then
        XCTAssertNotNil(dictionary, @"should have a responseObject");
        XCTAssertTrue([dictionary[@"ok"] integerValue] == 1, "should have status code: 1");
        XCTAssertNotNil(data, @"should have data");
        XCTAssertTrue([data[@"userId"] integerValue] > 0, @"should have a userID");
        XCTAssertNotNil(data[@"expireTime"], @"should have expireTime");
        XCTAssertNotNil(data[@"token"], @"should have a token");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [expectation fulfill];
        XCTAssertNil(error, @"should not have an error");
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}


#pragma mark - Footprint

- (void)testGetGlobalFootprints {
    // given
    NSString *username = @"example_user";
    NSString *password = @"password";
    XCTestExpectation *expectation = [self expectationWithDescription:@"get global footprints"];
    
    // when
    [self.client signInWithUsername:username password:password success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.client getGlobalFootprintsWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            [expectation fulfill];
            
            NSDictionary *dictionary = responseObject;
            NSArray *footprints = dictionary[@"data"];
            XCTAssertNotNil(dictionary, @"should have a response object");
            XCTAssertNotNil(footprints, @"should have a list of footprints");
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [expectation fulfill];
            
            XCTAssertNil(error, @"should not have an error");
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [expectation fulfill];
        XCTAssertNil(error, @"should not have an error");
    }];
}

@end
