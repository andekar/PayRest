//
//  PayRate.h
//  Pods
//
//  Created by anders on 14/03/2015.
//
//

#import <Foundation/Foundation.h>

@interface PayRate : NSObject
@property (nonatomic, strong) NSString *country_code;
@property (nonatomic, strong) NSString *country_name;
@property (nonatomic, strong) NSNumber *rate;
@end
