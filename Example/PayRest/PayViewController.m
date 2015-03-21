//
//  PayViewController.m
//  PayRest
//
//  Created by Anders on 02/14/2015.
//  Copyright (c) 2014 Anders. All rights reserved.
//

#import "PayViewController.h"
#import "PayUser.h"
#import "PayTransaction.h"
#import "Base64.h"
#import "PayIOSToken.h"
#import "RestKit.h"

@interface PayViewController ()

@end

@implementation PayViewController

- (void)viewDidLoad
{
//    PayUserRequests *pr = [PayUserRequests payUserRequests];
    NSString *str1 =  [NSString stringWithFormat: @"%@:%@:%@", @"debug", @"andersk84@gmail.com"
                       , @"114115257233622203470"];
    NSString *str2 = [str1 base64EncodedString];
    NSLog(@"Basic %@ str1 %@", str2,str1);
    NSString *pv = @"0.37";
    NSString *baseUrl = @"https://test.payapp.iamanders.se:8443";
    [[PayUserRequests payUserRequests] configureForUrl:baseUrl auth:str2 protocolversion:pv];
    
    AFHTTPClient *client = [[RKObjectManager sharedManager] HTTPClient];
    NSString *ua = @"PayApp/1.6 CFNetwork/709.1 Darwin/13.3.0";
    [client setDefaultHeader:@"User-Agent" value:ua];
    
//    [[PayUserRequests payUserRequests] setDelegate:self];
    
    
    PayUser *testUser = [PayUser new];
    testUser.user_type = @"gmail";
    testUser.currency = @"SEK";
    testUser.echo_uuid = @"testecho";
    testUser.uid = @"114115257233622203470";
//    testUser.username = @"andersk84@gmail.com";
    testUser.displayname = @"this is my displayname";
//    [[PayUserRequests payUserRequests] loadRates:^(NSArray *rates) {
//        NSLog(@"WHoa");
//    } failure:^{
//        assert(false);
//    }];
//    [[PayUserRequests payUserRequests] transferDebtsFrom:testUser to:testUser success:^{
//        assert(true);
//    } failure:^{
//        assert(false);
//    }];
//    [[PayUserRequests payUserRequests] putUser:testUser success:^(PayUser *pu) {
//    } failure:^{
//        assert(false);
//    }];
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
//    [[PayUserRequests payUserRequests] loadTransactions:[NSNumber numberWithInt:10] success:^(NSArray *transactions) {
//        NSLog(@"Success");
//    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
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
//    PayIOSToken *token = [PayIOSToken new];
//    [token setIos_token:@"TOKENTOKEN"];
//    [pr postIOSToken:token success:^() {
//        NSLog(@"here");
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
