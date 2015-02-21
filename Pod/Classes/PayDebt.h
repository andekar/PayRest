//
//  PayDebt.h
//  Pods
//
//  Created by anders on 21/02/2015.
//
//

#import <Foundation/Foundation.h>
#import "PayEditDetails.h"

@interface PayDebt : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *uid1;
@property (nonatomic, strong) NSString *uid2;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic) PayEditDetails *edit_details;
@end
