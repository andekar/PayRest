//
//  PayUser.h
//  Pods
//
//  Created by anders on 14/02/2015.
//
//

#import <Foundation/Foundation.h>
#import "PayEditDetails.h"

@interface PayUser : NSObject
@property (nonatomic, strong) NSString *internal_uid;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *user_type;
@property (nonatomic, strong) NSString *displayname;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *echo_uuid;
@property (nonatomic, strong) PayEditDetails *user_edit_details;

@end
