//
//  PayViewController.m
//  PayRest
//
//  Created by Anders on 02/14/2015.
//  Copyright (c) 2014 Anders. All rights reserved.
//

#import "PayViewController.h"
#import "PayUserRequests.h"
#import "PayUser.h"
#import "PayTransaction.h"

@interface PayViewController ()

@end

@implementation PayViewController

- (void)viewDidLoad
{
    PayUserRequests *pr = [PayUserRequests payUserRequests];
    
//    PayUser *testUser = [PayUser new];
//    testUser.user_type = @"local";
//    testUser.currency = @"SEK";
//    testUser.echo_uuid = @"testecho";
//    testUser.uid = @"testecho2";
//    testUser.displayname = @"this is my displayname";
//    //    PayUser *copy = testUser;
//
//    // create user first
//    [pr postUsers:@[testUser] success:^(NSArray *users) {
//    } failure:^{
//        
//        NSLog(@"failed");
//        assert(false);
//    }];
//    
//    [pr loadUsers:^(NSArray *users) {
//        NSLog(@"success with users");
//    } failure:^{
//        NSLog(@"Failed with request");
//        assert(false);
//    } uids:@[@"andersk84@gmail.com",@"test",@"mattias.thell@gmail.com"]];
//    [pr loadCountries:^(NSArray *countries) {
//        NSLog(@"here");
//    } failure:^{
//        assert(false);
//        NSLog(@"there");
//    }];
//    [pr loadExchangeRates:^(NSArray *rates) {
//        NSLog(@"here");
//    } failure:^{
//        
//        NSLog(@"there");
//        assert(false);
//    }];
//    [pr loadDebts:^(NSArray *debts) {
//        NSLog(@"success");
//    } failure:^{
//        NSLog(@"failure");
//        assert(false);
//    }];
//    [pr loadTransactions:^(NSArray *transactions) {
//        NSLog(@"success");
//    } failure:^{
//        NSLog(@"failure");
//        assert(false);
//    }];
//
//    PayTransaction* transaction = [PayTransaction new];
//    transaction.amount = [NSNumber numberWithDouble:20.0];
//    transaction.currency = @"SEK";
//    transaction.paid_by = @"andersk84@gmail.com";
//    transaction.paid_for = @"ffaaf593-ff96-4c7a-ab22-d756b5fdc470";
//    transaction.echo_uuid = @"echo";
//    transaction.reason = @"testreason";
//    PayOrgTransaction *orgt =[PayOrgTransaction new];
//    orgt.currency = @"SEK";
//    orgt.amount =[NSNumber numberWithDouble:20.0];
//    transaction.org_transaction = orgt;
//    [pr postTransactions:@[transaction] success:^(NSArray *transactions) {
//        [pr deleteTransaction:[transactions firstObject] success:^{
//            NSLog(@"ok");
//        } failure:^{
//            assert(false);
//        }];
//    } failure:^{
//        assert(false);
//    }];
//    
//    [pr deleteDebtToUser:@"testuser" success:^{
//        NSLog(@"GOT OK!");
//    } failure:^{
//        assert(false);
//    }];

    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
