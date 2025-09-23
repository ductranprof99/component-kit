//
// ListShortCellShortItem.m
//  CKTest
//
//  Created by ductd on 23/9/25.
//

#import "ListShortCellShortItem.h"

@implementation ListShortCellShortItem
+ (instancetype)urlItem:(NSString *)url {
    ListShortCellShortItem *i = [ListShortCellShortItem new];
    [i setValue:@(ShortItemTypeURL) forKey:@"_type"];
    [i setValue:(url.length ? url : [[NSUUID UUID] UUIDString]) forKey:@"_identifier"];
    [i setValue:url forKey:@"_url"];
    return i;
}

- (id)copyWithZone:(NSZone *)zone { return self; } //

+ (instancetype _Nonnull)addItemWithUsername:(NSString *)username
                                  withAvatar:(NSString *)avatar
{
    ListShortCellShortItem *i = [ListShortCellShortItem new];
    [i setValue:@(ShortItemTypeAdd) forKey:@"_type"];
    [i setValue:@"add" forKey:@"_identifier"];
    [i setValue:username forKey:@"_userName"];
    [i setValue:avatar forKey:@"_userAvatar"];
    return i;
}

@end
