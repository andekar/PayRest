//
//  PayUser.m
//  Pods
//
//  Created by anders on 14/02/2015.
//
//

#import "PayUser.h"

@implementation PayUser

-(void) setUid:(NSString *)uid
{
    if(!self.username)
    {
        self.username = uid;
    }
    _uid = uid;
}
@end
