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
- (void) loadTransactions:(NSNumber *) numTransactions success:(void (^)(NSArray *transactions))success failure:(void (^)())failure;
- (void) loadTransactionsFrom:(NSNumber *) from to:(NSNumber *) to success:(void (^)(NSArray *transactions))success failure:(void (^)())failure;
// below will choose correct one
- (void) loadTransactionsToUserId:(NSString *) userid from:(NSNumber *) from to:(NSNumber *) to success:(void (^)(NSArray *transactions))success failure:(void (^)())failure;

- (void) loadCountries:(void (^)(NSArray *countries))success failure:(void (^)())failure;
- (void) loadExchangeRates:(void (^)(NSArray *rates))success failure:(void (^)())failure;

#pragma post
- (void) postTransactions:(NSArray *) transactions success:(void (^)(NSArray *transactions))success failure:(void (^)())failure;
- (void) postUsers:(NSArray *) userArr success:(void (^)(NSArray *pus))success failure:(void (^)())failure;

#pragma put
- (void) putUser:(PayUser *) user success:(void (^)(PayUser *pu))success failure:(void (^)())failure;

#pragma delete
- (void) deleteDebtToUser:(NSString *) userid  success:(void (^)())success failure:(void (^)())failure;
- (void) deleteTransaction:(PayTransaction *) transaction success:(void (^)())success failure:(void (^)())failure;
@end
