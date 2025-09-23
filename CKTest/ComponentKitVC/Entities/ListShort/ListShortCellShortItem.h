//
//  ShortItem.h
//  CKTest
//
//  Created by ductd on 23/9/25.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ListShortShortItemType) {
  ShortItemTypeAdd,
  ShortItemTypeURL,
};

@interface ListShortCellShortItem : NSObject <NSCopying>
@property (nonatomic, assign, readonly) ListShortShortItemType type;
@property (nonatomic, copy, readonly, nonnull) NSString *identifier;
@property (nonatomic, copy, readonly, nullable) NSString *url;
@property (nonatomic, copy, readonly, nullable) NSString *userName;
@property (nonatomic, copy, readonly, nullable) NSString *userAvatar;

+ (instancetype _Nonnull)addItemWithUsername: (NSString *_Nonnull)username
                                  withAvatar: (NSString *_Nonnull) avatar;
+ (instancetype _Nonnull)urlItem:(NSString *_Nonnull)url;
@end
