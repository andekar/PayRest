//
//  PayUserRequests.h
//  Pods
//
//  Created by anders on 14/02/2015.
//
//

#import <Foundation/Foundation.h>
#import "PayUser.h"
#import "PayTransaction.h"

@interface PayUserRequests : NSObject
+ (PayUserRequests *) payUserRequests;

- (void)configureForUrl:(NSString *) baseUrl auth:(NSString *) auth;

#pragma load
- (void) loadUsers:(void (^)(NSArray *users))success failure:(void (^)())failure uids:(NSArray*) uids;
- (void) loadDebts:(void (^)(NSArray *debts))success failure:(void (^)())failure;
//transactions/[num] | [from]/[num] | [userid]/[from]/[num]
- (void) loadTransactions:(int) numTransactions success:(void (^)(NSArray *transactions))success failure:(void (^)())failure;
- (void) loadTransactionsFrom:(int) from to:(int) to success:(void (^)(NSArray *transactions))success failure:(void (^)())failure;
- (void) loadTransactionsToUserId:(NSString *) userid from:(int) from to:(int) to success:(void (^)(NSArray *transactions))success failure:(void (^)())failure;

- (void) loadCountries:(void (^)(NSArray *countries))success failure:(void (^)())failure;
- (void) loadExchangeRates:(void (^)(NSArray *rates))success failure:(void (^)())failure;

#pragma post
- (void) postTransactions:(NSArray *) transactions success:(void (^)(NSArray *transactions))success failure:(void (^)())failure;
- (void) postUsers:(NSArray *) userArr success:(void (^)(NSArray *debts))success failure:(void (^)())failure;

#pragma put
- (void) putUser:(PayUser *) user;

#pragma delete
- (void) deleteDebtToUser:(NSString *) userid  success:(void (^)())success failure:(void (^)())failure;
- (void) deleteTransaction:(PayTransaction *) transaction success:(void (^)())success failure:(void (^)())failure;
@end
