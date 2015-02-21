//
//  PayTransactionWrapper.h
//  Pods
//
//  Created by anders on 21/02/2015.
//
//

#import <Foundation/Foundation.h>
#import "PayTransaction.h"
@interface PayTransactionWrapper : NSObject
@property (nonatomic, strong) PayTransaction *transaction;
@end
