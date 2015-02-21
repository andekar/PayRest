//
//  PayTransaction.h
//  Pods
//
//  Created by anders on 21/02/2015.
//
//

#import <Foundation/Foundation.h>
#import "PayEditDetails.h"
#import "PayOrgTransaction.h"

@interface PayTransaction : NSObject

@property (nonatomic, strong) NSString *transaction_id;
@property (nonatomic, strong) NSString *paid_by;
@property (nonatomic, strong) NSString *paid_for;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, strong) NSString *server_timestamp;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) PayOrgTransaction *org_transaction;// todo org_transaction
@property (nonatomic) PayEditDetails *edit_details;
@property (nonatomic, strong) NSString *echo_uuid;
@property (nonatomic, strong) NSString *status;

@end

//"transaction":{
//    "transaction_id":"6ae01e69-85fe-4fc4-a7ca-9cd22c85ed76",
//    "paid_by":"890043b5-e69a-4af7-94a7-af9cac5a36d2",
//    "paid_for":"8cd677d5-b0a3-4f9e-bf02-0bd3d47b0069",
//    "amount":1128.642364393294,
//    "reason":"test",
//    "timestamp":1412523623240014,
//    "server_timestamp":1412523623240014,
//    "currency":"SEK",
//    "org_transaction":{
//        "amount":150,
//        "currency":"CHF"
//    },
//    "edit_details":{
//        "created_at":1412523623240072,
//        "created_by":"890043b5-e69a-4af7-94a7-af9cac5a36d2",
//        "last_change":1412523623240072,
//        "last_changed_by":"890043b5-e69a-4af7-94a7-af9cac5a36d2"
//    },
//    "echo_uuid":"69CAFDBE-60E0-4AAA-8051-B06C10D711B5",
//    "status":"ok"
//}
