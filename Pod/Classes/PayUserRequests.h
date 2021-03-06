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
#import "PayIOSToken.h"
#import "PayRate.h"
#import "RKObjectRequestOperation.h"

@interface PayUserRequests : NSObject

+ (PayUserRequests *) payUserRequests;

- (void)configureForUrl:(NSString *) baseUrl auth:(NSString *) auth protocolversion:(NSString*) pv;

#pragma load
- (void) loadUsers:(void (^)(NSArray *users))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error)) failure uids:(NSArray*) uids;
- (void) loadDebts:(void (^)(NSArray *debts))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;
//transactions/[num] | [from]/[num] | [userid]/[from]/[num]
- (void) loadTransactions:(NSNumber *) numTransactions success:(void (^)(NSArray *transactions))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;
- (void) loadTransactionsFrom:(NSNumber *) from to:(NSNumber *) to success:(void (^)(NSArray *transactions))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;
// below will choose correct one
- (void) loadTransactionsToUserId:(NSString *) userid from:(NSNumber *) from to:(NSNumber *) to success:(void (^)(NSArray *transactions))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

- (void) loadCountries:(void (^)(NSArray *countries))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;
- (void) loadExchangeRates:(void (^)(NSArray *rates))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;
- (void) loadRates:(void (^)(NSArray *rates))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

#pragma post
- (void) postTransactions:(NSArray *) transactions success:(void (^)(NSArray *transactions))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;
- (void) postUsers:(NSArray *) userArr success:(void (^)(NSArray *pus))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;
- (void) postIOSToken:(PayIOSToken *) token success:(void (^)())success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

#pragma put
- (void) putUser:(PayUser *) user success:(void (^)(PayUser *pu))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;
- (void) transferDebtsFrom:(PayUser *) from to:(PayUser *) pu success:(void (^)())success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

#pragma delete
- (void) deleteDebtToUser:(NSString *) userid  success:(void (^)())success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;
- (void) deleteTransaction:(PayTransaction *) transaction success:(void (^)())success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;
- (void) clearNotificationsSuccess:(void (^)())success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;
@end
