//
//  PayEditDetails.h
//  Pods
//
//  Created by anders on 21/02/2015.
//
//

#import <Foundation/Foundation.h>

@interface PayEditDetails : NSObject
@property (nonatomic, strong) NSString *created_at; // todo fix date
@property (nonatomic, strong) NSString *created_by;
@property (nonatomic, strong) NSString *last_change; // todo fix date
@property (nonatomic, strong) NSString *last_changed_by;

//"edit_details":{
//    "created_at":1412457221192685,
//    "created_by":"890043b5-e69a-4af7-94a7-af9cac5a36d2",
//    "last_change":1412523623242310,
//    "last_changed_by":"890043b5-e69a-4af7-94a7-af9cac5a36d2"
//}
@end
