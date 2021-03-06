//
//  PayUserRequests.m
//  Pods
//
//  Created by anders on 14/02/2015.
//
//

#import "PayUserRequests.h"
#import "RestKit.h"
#import "PayError.h"
#import "PayDebt.h"
#import "PayEditDetails.h"
#import "PayOrgTransaction.h"
#import "PayStatus.h"
#import "PayCountry.h"
#import "PayExchangeRate.h"
#import "PayTransactionWrapper.h"
#import "PayUserWrapper.h"
#import "PayTransferDebt.h"

@interface PayUserRequests ()
@property (nonatomic) BOOL initialized;
@end

@implementation PayUserRequests

static PayUserRequests *sPayUserRequests;
+ (PayUserRequests *) payUserRequests {
    if(!sPayUserRequests)
    {
        [self initialize];
    }
    return sPayUserRequests;
}

+ (void)initialize {
    NSAssert(self == [PayUserRequests class],
             @"PayUserRequests is not designed to be subclassed", nil);
    sPayUserRequests = [PayUserRequests new];
    sPayUserRequests.initialized = NO;
}

- (void)configureForUrl:(NSString *)baseUrl auth:(NSString *)auth protocolversion:(NSString*) pv
{
    if(self.initialized)
    {
        [[[RKObjectManager sharedManager] HTTPClient] setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Basic %@",auth]];
        return;
    }
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:baseUrl];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    
    [client setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Basic %@",auth]];
    [client setDefaultHeader:@"protocolversion" value:pv];
    [client setAllowsInvalidSSLCertificate:YES];
    
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/html"];
    
    [self userMapping:objectManager];
    
    [self statusMapping:objectManager];
    
    [self errorMapping:objectManager];
    
    [self debtsMapping:objectManager];
    
    [self transactionsMapping:objectManager];
    
    [self countryMapping:objectManager];
    
    [self exchangeRateMapping:objectManager];
    
    [self rateMapping:objectManager];
    
    [self iosTokenMapping:objectManager];
    
    self.initialized = YES;
}

#pragma Transaction stuff
- (void) deleteTransaction:(PayTransaction *) transaction success:(void (^)())success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    NSString *path = [@"/payapp/transactions/" stringByAppendingString:transaction.transaction_id];
    
    [[RKObjectManager sharedManager] deleteObject:nil path:path parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success();
    } failure:failure];
}

- (void) postTransactions:(NSArray *) transactions success:(void (^)(NSArray *transactions))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    NSMutableArray *myWrappers = [NSMutableArray new];
    for(PayTransaction *t in transactions)
    {
        PayTransactionWrapper *w = [PayTransactionWrapper new];
        w.transaction = t;
        [myWrappers addObject:w];
    }
    
    [RKObjectManager sharedManager].requestSerializationMIMEType=RKMIMETypeJSON;
    [[RKObjectManager sharedManager] postObject:myWrappers path:@"/payapp/transactions/" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSArray *arr = [mappingResult.dictionary objectForKey:@"transaction"];
        success(arr);
    } failure:failure];
    
}

- (void) loadTransactions:(NSNumber*) numTransactions success:(void (^)(NSArray *transactions))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;
{
    NSString *url = [@"/payapp/transactions/" stringByAppendingString:[numTransactions stringValue]];
    [[RKObjectManager sharedManager] getObjectsAtPath:url //todo number
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {// todo return
                                                  NSArray *arr = [[mappingResult dictionary] objectForKey:@"transaction"];
                                                  success(arr);
                                              }
                                              failure:failure];
}

- (void) loadTransactionsFrom:(NSNumber*) from to:(NSNumber*) to success:(void (^)(NSArray *transactions))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    NSString *url = [@"/payapp/transactions/" stringByAppendingFormat:@"%i/%i",[from intValue],[to intValue]];
    [[RKObjectManager sharedManager] getObjectsAtPath:url //todo number
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {// todo return
                                                  NSArray *arr = [[mappingResult dictionary] objectForKey:@"transaction"];
                                                  success(arr);
                                              }
                                              failure:failure];
}

// below "to" can also be numTransactions
- (void) loadTransactionsToUserId:(NSString *) userid from:(NSNumber*) from to:(NSNumber*) to success:(void (^)(NSArray *transactions))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    if(!userid)
    {
        if(!from)
        {
            [self loadTransactions:to success:success failure:failure];
        }
        else
        {
            [self loadTransactionsFrom:from to:to success:success failure:failure];
        }
    }
    else
    {
        NSString *url = [@"/payapp/transactions/" stringByAppendingFormat:@"%@/%i/%i",userid,[from intValue],[to intValue]];
        [[RKObjectManager sharedManager] getObjectsAtPath:url //todo number
                                               parameters:nil
                                                  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {// todo return
                                                      NSArray *arr = [[mappingResult dictionary] objectForKey:@"transaction"];
                                                      success(arr);
                                                  }
                                                  failure:failure];
    }
}

#pragma debt stuff
- (void) deleteDebtToUser:(NSString *) userid success:(void (^)())success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    NSString *path = [@"/payapp/debts/" stringByAppendingString:userid];
    [[RKObjectManager sharedManager] deleteObject:nil path:path parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success();
    } failure:failure];
}
- (void) loadDebts:(void (^)(NSArray *debts))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/payapp/debts"
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  NSArray *arr = [[mappingResult dictionary] objectForKey:@"debt"];
                                                  success(arr);
                                                  
                                              }
                                              failure:failure];
}

- (void) transferDebtsFrom:(PayUser *) from to:(PayUser *) pu success:(void (^)())success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    PayTransferDebt *td = [PayTransferDebt new];
    [RKObjectManager sharedManager].requestSerializationMIMEType=RKMIMETypeJSON;
    td.n_uid = pu.internal_uid;
    td.old_uid = from.internal_uid;
    [[RKObjectManager sharedManager] putObject:td path:@"/payapp/debts" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success();
    } failure:failure];
}


#pragma user stuff
- (void) putUser:(PayUser *) user success:(void (^)(PayUser *pu))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    NSString *url = @"/payapp/users";
    [RKObjectManager sharedManager].requestSerializationMIMEType=RKMIMETypeJSON;
    [[RKObjectManager sharedManager] putObject:user path:url parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success(user);
    } failure:failure];
}


- (void) postUsers:(NSArray *) userarr success:(void (^)(NSArray *pus))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    NSString *url = @"/payapp/users";
    NSMutableArray *wrapperArr = [NSMutableArray new];
    for( PayUser *p in userarr)
    {
        PayUserWrapper *user = [PayUserWrapper new];
        user.user = p;
        [wrapperArr addObject:user];
    }
    //    @"user_type", @"currency", @"echo_uuid",  @"uid", @"displayname"
    [RKObjectManager sharedManager].requestSerializationMIMEType=RKMIMETypeJSON;
    [[RKObjectManager sharedManager] postObject:wrapperArr path:url parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSDictionary *dict = [mappingResult dictionary];
        NSArray *users = [dict objectForKey:@"user"];
        NSMutableArray *realUsers = [[NSMutableArray alloc] init];
        for(PayUser *usr in users)
        {
            if([usr internal_uid])
                [realUsers addObject:usr];
        }
        success(realUsers);
    } failure:failure];
    
}

- (void) loadUsers:(void (^)(NSArray *users))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure uids:(NSArray*) uids
{
    if([uids count] == 0) // avoid empty requests
    {
        success(@[]);
        return;
    }
    NSString *url = @"/payapp/users";
    for(NSString *tmp in uids)
    {
        url = [[url stringByAppendingString:@"/"]stringByAppendingString:tmp];
        
    }
    [[RKObjectManager sharedManager] getObjectsAtPath:url
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  NSDictionary *dict = [mappingResult dictionary];
                                                  NSArray *users = [dict objectForKey:@"user"];
                                                  NSMutableArray *realUsers = [[NSMutableArray alloc] init];
                                                  for(PayUser *usr in users)
                                                  {
                                                      if([usr internal_uid])
                                                          [realUsers addObject:usr];
                                                  }
                                                  success(realUsers);
                                                  
                                              }
                                              failure:failure];
}

#pragma currency stuff

- (void) loadCountries:(void (^)(NSArray *countries))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    NSString *url = @"/payapp/countries/";
    [[RKObjectManager sharedManager] getObjectsAtPath:url
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  NSDictionary *dict = [mappingResult dictionary];
                                                  NSArray *countries = [dict objectForKey:@"country"];
                                                  success(countries);
                                                  
                                              }
                                              failure:failure];
}

- (void) loadExchangeRates:(void (^)(NSArray *rates))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    NSString *url = @"/payapp/rates/";
    [[RKObjectManager sharedManager] getObjectsAtPath:url
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  NSDictionary *dict = [mappingResult dictionary];
                                                  NSArray *rates = [dict objectForKey:@"exchange_rate"];
                                                  success(rates);
                                                  
                                              }
                                              failure:failure];
}


- (void) loadRates:(void (^)(NSArray *rates))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    NSString *url = @"/payapp/crates/";
    [[RKObjectManager sharedManager] getObjectsAtPath:url
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  NSDictionary *dict = [mappingResult dictionary];
                                                  NSArray *rates = [dict objectForKey:@"exchange_rate"];
                                                  success(rates);
                                                  
                                              }
                                              failure:failure];
}

#pragma ios_token stuff
- (void) postIOSToken:(PayIOSToken *) token success:(void (^)())success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    NSString *url = @"/payapp/ios_token";
    
    [RKObjectManager sharedManager].requestSerializationMIMEType=RKMIMETypeJSON;
    [[RKObjectManager sharedManager] postObject:token path:url parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        success();
    } failure:failure];
    
}

- (void) clearNotificationsSuccess:(void (^)())success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    
    NSString *path = @"/payapp/ios_token/badge";
    
    [[RKObjectManager sharedManager] deleteObject:nil path:path parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success();
    } failure:failure];
}

#pragma mappings
- (void) errorMapping:(RKObjectManager *)objectManager
{
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[PayError class]];
    [errorMapping addAttributeMappingsFromArray:@[@"error"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *errorResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:errorMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:nil//@"/payapp/users/:username"
                                                keyPath:@""
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:errorResponseDescriptor];
}

- (void) statusMapping:(RKObjectManager *)objectManager
{
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[PayStatus class]];
    [errorMapping addAttributeMappingsFromArray:@[@"status"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *errorResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:errorMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil//@"/payapp/users/:username"
                                                keyPath:@""
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:errorResponseDescriptor];
}

- (void) userMapping:(RKObjectManager *)objectManager
{
    RKObjectMapping *payUserMapping = [RKObjectMapping mappingForClass:[PayUser class]];
    [payUserMapping addAttributeMappingsFromArray:@[@"internal_uid", @"uid", @"username", @"user_type", @"displayname", @"currency", @"echo_uuid"]]; // todo add stuff?
    [payUserMapping addAttributeMappingToKeyOfRepresentationFromAttribute:@"user"];
    
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:payUserMapping
                                                 method:RKRequestMethodGET | RKRequestMethodPOST
                                            pathPattern:nil//@"/payapp/users/:username"
                                                keyPath:@"user"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    // Now configure the edit_details mapping
    RKObjectMapping* editDetailsMapping = [RKObjectMapping mappingForClass:[PayEditDetails class] ];
    [editDetailsMapping addAttributeMappingsFromArray:@[@"created_at",@"created_by",@"last_change",@"last_changed_by"]];
    
    // Define the relationship mapping
    [payUserMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user_edit_details" toKeyPath:@"user_edit_details" withMapping:editDetailsMapping]];
    
    
    [objectManager addResponseDescriptor:responseDescriptor];
    
    //    user_edit_details
    
    // POST MAPPING
    // Configure a request mapping for our user class.
    RKObjectMapping* userRequestMapping = [RKObjectMapping requestMapping ]; // Shortcut for [RKObjectMapping mappingForClass:[NSMutableDictionary class] ]
    [userRequestMapping addAttributeMappingsFromArray:@[@"user_type", @"currency", @"echo_uuid",  @"uid", @"displayname"]];
    
    // Now configure the request descriptor
    //    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:userRequestMapping objectClass:[PayUser class] rootKeyPath:@"user" method:RKRequestMethodPOST];
    RKObjectMapping* userWrapperRequestMapping = [RKObjectMapping requestMapping ];
    [userWrapperRequestMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:userRequestMapping]];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:userWrapperRequestMapping objectClass:[PayUserWrapper class] rootKeyPath:nil method:RKRequestMethodPOST];
    
    
    [objectManager addRequestDescriptor:requestDescriptor];
    
    // PUT MAPPING
    // Configure a request mapping for our user class.
    RKObjectMapping* userPostRequestMapping = [RKObjectMapping requestMapping ]; // Shortcut for [RKObjectMapping mappingForClass:[NSMutableDictionary class] ]
    [userPostRequestMapping addAttributeMappingsFromArray:@[@"displayname", @"currency"]];
    
    // Now configure the request descriptor
    RKRequestDescriptor *requestPostDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:userPostRequestMapping objectClass:[PayUser class] rootKeyPath:@"user" method:RKRequestMethodPUT];
    
    
    [objectManager addRequestDescriptor:requestPostDescriptor];
}

- (void) debtsMapping:(RKObjectManager *)objectManager
{
    RKObjectMapping *payDebtMapping = [RKObjectMapping mappingForClass:[PayDebt class]];
    [payDebtMapping addAttributeMappingsFromArray:@[@"id",@"uid1", @"uid2", @"amount", @"currency"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:payDebtMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/payapp/debts"
                                                keyPath:@"debt"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    
    
    // Now configure the Article mapping
    RKObjectMapping* editDetailsMapping = [RKObjectMapping mappingForClass:[PayEditDetails class] ];
    [editDetailsMapping addAttributeMappingsFromArray:@[@"created_at",@"created_by",@"last_change",@"last_changed_by"]];
    
    // Define the relationship mapping
    [payDebtMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"edit_details"
                                                                                   toKeyPath:@"edit_details" withMapping:editDetailsMapping]];
    
    
    [objectManager addResponseDescriptor:responseDescriptor];
    
    
    // PUT MAPPING
    // Configure a request mapping for our user class.
    RKObjectMapping* transferDebtRequestMapping = [RKObjectMapping requestMapping ]; // Shortcut for [RKObjectMapping mappingForClass:[NSMutableDictionary class] ]
    //    [transferDebtRequestMapping addAttributeMappingsFromArray:@[@"", @"currency"]];
    [transferDebtRequestMapping addAttributeMappingsFromDictionary:[[NSDictionary alloc] initWithObjects:@[@"old_uid", @"new_uid"] forKeys:@[@"old_uid", @"n_uid"]]];
    
    // Now configure the request descriptor
    RKRequestDescriptor *requestPostDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:transferDebtRequestMapping objectClass:[PayTransferDebt class] rootKeyPath:nil method:RKRequestMethodPUT];
    
    
    [objectManager addRequestDescriptor:requestPostDescriptor];
    
}

- (void) transactionsMapping:(RKObjectManager *)objectManager
{
    RKObjectMapping *payTransactionMapping = [RKObjectMapping mappingForClass:[PayTransaction class]];
    [payTransactionMapping addAttributeMappingsFromArray:@[@"transaction_id",@"paid_by", @"paid_for", @"amount", @"reason",@"timestamp",@"server_timestamp", @"currency",@"echo_uuid",@"status"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:payTransactionMapping
                                                 method:RKRequestMethodGET|RKRequestMethodPOST
                                            pathPattern:@"/payapp/transactions/:id"
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    
    
    // Now configure the edit_details mapping
    RKObjectMapping* editDetailsMapping = [RKObjectMapping mappingForClass:[PayEditDetails class] ];
    [editDetailsMapping addAttributeMappingsFromArray:@[@"created_at",@"created_by",@"last_change",@"last_changed_by"]];
    
    // Define the relationship mapping
    [payTransactionMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"edit_details"
                                                                                          toKeyPath:@"edit_details" withMapping:editDetailsMapping]];
    
    // Now configure the org_transaction mapping
    RKObjectMapping* orgTransactionDetailsMapping = [RKObjectMapping mappingForClass:[PayOrgTransaction class] ];
    [orgTransactionDetailsMapping addAttributeMappingsFromArray:@[@"amount",@"currency"]];
    
    // Define the relationship mapping
    [payTransactionMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"org_transaction"
                                                                                          toKeyPath:@"org_transaction" withMapping:orgTransactionDetailsMapping]];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    
    // POST MAPPING
    RKObjectMapping* orgTransactionRMapping = [RKObjectMapping requestMapping ]; // Shortcut for
    [orgTransactionRMapping addAttributeMappingsFromArray:@[@"amount", @"currency"]];
    
    // Configure a request mapping for our transaction class.
    RKObjectMapping* transactionRequestMapping = [RKObjectMapping requestMapping ]; // Shortcut for [RKObjectMapping mappingForClass:[NSMutableDictionary class] ]
    [transactionRequestMapping addAttributeMappingsFromArray:@[ @"reason", @"amount", @"paid_by", @"paid_for", @"currency", @"echo_uuid", @"timestamp"]];
    
    [transactionRequestMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"org_transaction" toKeyPath:@"org_transaction" withMapping:orgTransactionRMapping]];
    
    // Now configure the request descriptor
    
    RKObjectMapping* wrapperTransactionRMapping = [RKObjectMapping requestMapping ]; // Shortcut for
    [wrapperTransactionRMapping addAttributeMappingsFromArray:@[]];
    [wrapperTransactionRMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"transaction" toKeyPath:@"transaction" withMapping:transactionRequestMapping]];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:wrapperTransactionRMapping objectClass:[PayTransactionWrapper class] rootKeyPath:nil method:RKRequestMethodPOST];
    
    [objectManager addRequestDescriptor:requestDescriptor];
    
    // response of post
    
    RKResponseDescriptor *rresponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:payTransactionMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:@"/payapp/transactions/"
                                                keyPath:@"transaction"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:rresponseDescriptor];
    
    RKResponseDescriptor *rresponseDescriptor2 =
    [RKResponseDescriptor responseDescriptorWithMapping:payTransactionMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:@"/payapp/transactions/:from/:to"
                                                keyPath:@"transaction"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:rresponseDescriptor2];
    
    RKResponseDescriptor *rresponseDescriptor3 =
    [RKResponseDescriptor responseDescriptorWithMapping:payTransactionMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:@"/payapp/transactions/:id/:from/:to"
                                                keyPath:@"transaction"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:rresponseDescriptor3];
    
    
    RKResponseDescriptor *successResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[RKObjectMapping mappingForClass:nil]
                                                                                                   method:RKRequestMethodDELETE
                                                                                              pathPattern:nil
                                                                                                  keyPath:nil
                                                                                              statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:successResponseDescriptor];
}

- (void) countryMapping:(RKObjectManager *)objectManager
{
    RKObjectMapping *payCountryMapping = [RKObjectMapping mappingForClass:[PayCountry class]];
    [payCountryMapping addAttributeMappingsFromArray:@[@"country_code", @"country_name"]];
    
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:payCountryMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/payapp/countries/"
                                                keyPath:@"country"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    
    [objectManager addResponseDescriptor:responseDescriptor];
    
    
}

- (void) exchangeRateMapping:(RKObjectManager *)objectManager
{
    RKObjectMapping *payExchangeMapping = [RKObjectMapping mappingForClass:[PayExchangeRate class]];
    [payExchangeMapping addAttributeMappingsFromArray:@[@"country_code", @"rate"]];
    
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:payExchangeMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/payapp/rates/"
                                                keyPath:@"exchange_rate"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    
    [objectManager addResponseDescriptor:responseDescriptor];
}

- (void) rateMapping:(RKObjectManager *)objectManager
{
    RKObjectMapping *payExchangeMapping = [RKObjectMapping mappingForClass:[PayRate class]];
    [payExchangeMapping addAttributeMappingsFromArray:@[@"country_code", @"country_name", @"rate"]];
    
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:payExchangeMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/payapp/crates/"
                                                keyPath:@"exchange_rate"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    
    [objectManager addResponseDescriptor:responseDescriptor];
}

- (void) iosTokenMapping:(RKObjectManager *)objectManager
{
    // POST MAPPING
    // Configure a request mapping for our ios_token class.
    RKObjectMapping* iosRequestMapping = [RKObjectMapping requestMapping ];
    [iosRequestMapping addAttributeMappingsFromArray:@[@"ios_token"]];
    
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:iosRequestMapping objectClass:[PayIOSToken class] rootKeyPath:nil method:RKRequestMethodPOST];
    
    
    [objectManager addRequestDescriptor:requestDescriptor];
}

@end
