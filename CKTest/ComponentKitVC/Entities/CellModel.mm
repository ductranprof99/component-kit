//
//  Data.c
//  CKTest
//
//  Created by ductd on 11/9/25.
//

#import <Foundation/Foundation.h>
#import "CellModelType.h"
#import "CellModel.h"
#import <UIKit/UIKit.h>
#import "NSDate_Ext.h"

// Make read-only avatar URLs writeable within this translation unit
@interface SubPost ()
@property (nonatomic, copy, readwrite) NSString *userAvatarURL;
@end

#pragma mark - Cell Model initialie
CellModel *CellModelFromDict(NSDictionary *dict) {
    CellModel *model = [CellModel new];
    model.uuidString = [[NSUUID UUID] UUIDString];

    // Resolve type safely
    NSNumber *typeNum = dict[@"type"];
    if (typeNum) {
        model.cellType = (CellModelType)[typeNum integerValue];
    }
    NSNumber *subTypeNum = dict[@"subType"];
    if (subTypeNum) {
        model.userPostType = (UserPostType)[subTypeNum integerValue];
    } else {
        model.userPostType = UserPostTypeNone;
    }

    switch (model.cellType) {
        case CellModelTypeNewStatus:
            break;
        case CellModelTypeUserPost: {
            // 2) User post variants
            // Common meta
            id likeCount = dict[@"likeCount"];
            if (likeCount) {
                model.likeCount = likeCount;
            } else {
                model.likeCount = 0;
            }
            NSArray *comments = dict[@"comments"]; if ([comments isKindOfClass:[NSArray class]]) model.comments = comments;
            NSString *userName = dict[@"userName"]; if (userName) model.userName = userName;
            NSString *avatarURL = dict[@"userAvatarURL"]; if ([avatarURL isKindOfClass:[NSString class]] && avatarURL.length > 0) model.userAvatarURL = avatarURL;
            
            NSString *text = dict[@"text"]; if (text) model.postText = text;
            
            id postedVal = dict[@"postedDate"];
            NSDate *parsedPosted = [NSDate ck_dateFromFlexible:postedVal];
            if (parsedPosted) {
                model.postedDate = parsedPosted;
            }
            
            id likedVal = dict[@"isLiked"];
            if (likedVal != nil) {
                if ([likedVal isKindOfClass:[NSNumber class]]) {
                    model.isLiked = [(NSNumber *)likedVal boolValue];
                } else if ([likedVal isKindOfClass:[NSString class]]) {
                    model.isLiked = [((NSString *)likedVal) boolValue];
                } else {
                    model.isLiked = arc4random_uniform(2) == 1;
                }
            } else {
                model.isLiked = arc4random_uniform(2) == 1;
            }
            
            switch (model.userPostType) {
                case UserPostTypeNone:
                    break;
                case UserPostTypeVideo:
                {
                    id videoVal = dict[@"videoURL"];
                    if (videoVal) {
                        if ([videoVal isKindOfClass:[NSURL class]]) {
                            model.videoURL = (NSURL *)videoVal;
                        } else if ([videoVal isKindOfClass:[NSString class]]) {
                            model.videoURL = [NSURL URLWithString:(NSString *)videoVal];
                        }
                    }
                }
                    break;
                case UserPostTypeNormal:
                {
                    NSArray *images = dict[@"images"]; // array of URL strings
                    if ([images isKindOfClass:[NSArray class]] && images.count > 0) {
                        model.listImageURL = images;
                    }
                }
                    break;
                case UserPostTypeUpdateAvatar:
                {
                    // Dedicated cell type in case caller sets it directly
                    NSString *updatedAvatar = dict[@"userUpdatedAvatar"];
                    if (updatedAvatar && updatedAvatar.length > 0) {
                        model.userUpdatedAvatar = updatedAvatar;
                    } else if (model.userAvatarURL) {
                        model.userUpdatedAvatar = model.userAvatarURL;
                    }
                }
                    break;
                case UserPostTypeRepost:
                {
                    NSArray *subpostsArr = dict[@"subPosts"]; // array of dicts
                    if ([subpostsArr isKindOfClass:[NSArray class]] && subpostsArr.count > 0) {
                        NSMutableArray<SubPost *> *subs = [NSMutableArray arrayWithCapacity:subpostsArr.count];
                        for (NSDictionary *sp in subpostsArr) {
                            if (![sp isKindOfClass:[NSDictionary class]]) continue;
                            SubPost *s = [SubPost new];
                            id likeCount = sp[@"likeCount"]; if (likeCount) s.likeCount = likeCount;
                            NSString *userName = sp[@"userName"]; if (userName) s.userName = userName;
                            NSString *spAvatar = sp[@"userAvatarURL"]; if ([spAvatar isKindOfClass:[NSString class]] && spAvatar.length > 0) s.userAvatarURL = spAvatar;
                            // userAvatarURL is readonly; assume it is provided via KVC-compliant backing ivar or ignored for now
                            [subs addObject:s];
                        }
                        model.subPosts = subs;
                    } else {
                        model.subPosts = @[]; // keep empty to signal invalid/mock gap
                    }
                }
                    break;
            }
           
        }
            break;
        case CellModelTypeShortList: {
            // 4) Short list: Must have list short URL (array of strings)
            NSArray *shorts = dict[@"listShortURL"];
            if ([shorts isKindOfClass:[NSArray class]] && shorts.count > 0) {
                model.listShortURL = shorts;
            } else {
                model.listShortURL = @[];
            }
            
            NSString *userName = dict[@"userName"]; if (userName) model.userName = userName;
            
            NSString *avatarURL = dict[@"userAvatarURL"]; if ([avatarURL isKindOfClass:[NSString class]] && avatarURL.length > 0) model.userAvatarURL = avatarURL;
           
        } break;

        case CellModelTypeRecomendationVideo: {
            // 5) Recommend video: list recommend video (array of strings)
            NSArray *recs = dict[@"recommendVideoURL"];
            if ([recs isKindOfClass:[NSArray class]] && recs.count > 0) {
                model.recommendVideoURL = recs;
            } else {
                model.recommendVideoURL = @[];
            }
        } break;
    }

    return model;
    
}

NSArray *cellListData(void)
{
    static NSArray *data;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *mutableData = [NSMutableArray array];
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];

        // 1.1) New Status (static cell + shortlist)
        [mutableData addObject:@{ @"type": @(CellModelTypeNewStatus) }];
        
        // 1.2) Short list
        [mutableData addObject:@{
            @"type": @(CellModelTypeShortList),
            @"listShortURL": @[
//                @"https://short.url/a",
//                @"https://short.url/b",
//                @"https://short.url/c"
                
                @"https://picsum.photos/400/300?1",
                @"https://picsum.photos/400/300?2",
                @"https://picsum.photos/400/300?3"
            ],
            @"userName": @"john",
            @"userAvatarURL": @"https://picsum.photos/40/40?u=normal"
        }];

        // 2.1) Normal user posts
        for (NSInteger i = 0; i < 3; i++) {
            [mutableData addObject:@{
                @"type": @(CellModelTypeUserPost),
                @"subType": @(UserPostTypeNormal),
                @"text": [NSString stringWithFormat:@"Normal post #%ld: hello world!", (long)i],
                @"likeCount": @(10 + i),
                @"comments": @[
                    @{ @"username": @"alice", @"comment": @"nice!" },
                    @{ @"username": @"bob",   @"comment": @"cool" }
                ],
                @"userName": @"john",
                @"userAvatarURL": @"https://picsum.photos/40/40?u=normal",
                @"postedDate": @((i == 0) ? (now - 30) : (i == 1 ? (now - 90 * 60) : (now - 26 * 3600))),
                @"isLiked": @(arc4random_uniform(2)),
            }];
        }
        
        for (NSInteger i = 3; i < 6; i++) {
            // Build a random set of 1..5 image URLs
            NSUInteger imgCount = 1 + arc4random_uniform(5); // 1..5
            NSMutableArray<NSString *> *randImgs = [NSMutableArray arrayWithCapacity:imgCount];
            for (NSUInteger k = 0; k < imgCount; k++) {
                // Use a random query token to avoid caching duplicates
                unsigned token = arc4random_uniform(1000000);
                [randImgs addObject:[NSString stringWithFormat:@"https://picsum.photos/400/300?seed=%ld_%lu_%u", (long)i, (unsigned long)k, token]];
            }

            NSMutableDictionary *post = [@{
                @"type": @(CellModelTypeUserPost),
                @"subType": @(UserPostTypeNormal),
                @"text": [NSString stringWithFormat:@"Post with image post #%ld: hello world! A string created by using format as a template into which the remaining argument values are substituted without any localization.", (long)i],
                @"likeCount": @(10 + i),
                @"comments": @[
                    @{ @"username": @"alice", @"comment": @"nice!" },
                    @{ @"username": @"bob",   @"comment": @"cool" }
                ],
                @"userName": @"john",
                @"userAvatarURL": @"https://picsum.photos/40/40?u=normal",
                @"postedDate": @((i == 0) ? (now - 30) : (i == 1 ? (now - 90 * 60) : (now - 26 * 3600))),
            } mutableCopy];

            // Insert random images
            post[@"images"] = randImgs;
            post[@"isLiked"] = @(arc4random_uniform(2));
            [mutableData addObject:post];
        }


        // 2.2) Video posts
        for (NSInteger i = 0; i < 2; i++) {
            [mutableData addObject:@{
                @"type": @(CellModelTypeUserPost),
                @"subType": @(UserPostTypeVideo),
                @"videoURL": [NSString stringWithFormat:@"https://example.com/video_%ld.mp4", (long)i],
                @"likeCount": @(100 + i),
                @"comments": @[],
                @"userName": @"john",
                @"userAvatarURL": @"https://picsum.photos/40/40?u=video",
                @"postedDate": (i == 0) ? @((long long)((now - 5 * 60) * 1000.0)) : @"2023-08-15T10:00:00Z",
                @"isLiked": @(arc4random_uniform(2)),
            }];
        }

        // 2.3) Image posts (multiple images)
        for (NSInteger i = 0; i < 2; i++) {
            [mutableData addObject:@{
                @"type": @(CellModelTypeUserPost),
                @"subType": @(UserPostTypeNormal),
                @"images": @[
                    @"https://picsum.photos/400/300?1",
                    @"https://picsum.photos/400/300?2",
                    @"https://picsum.photos/400/300?3"
                ],
                @"likeCount": @(50 + i),
                @"userName": @"john",
                @"userAvatarURL": @"https://picsum.photos/40/40?u=image",
                @"postedDate": (i == 0) ? @"24/09/2024" : @"1700000000",
            }];
        }

        // 2.4) Change avatar posts
        [mutableData addObject:@{
                    @"type": @(CellModelTypeUserPost),
       @"userUpdatedAvatar":@"https://picsum.photos/200/200?avatar",
                @"userName": @"john",
                @"postedDate": @(now - 2 * 3600),
           @"userAvatarURL": @"https://picsum.photos/40/40?u=change",
           @"isLiked": @(arc4random_uniform(2)),
        }];
        
        [mutableData addObject:@{
            @"type": @(CellModelTypeUserPost),
            @"postedDate": @((long long)((now - 3 * 24 * 3600) * 1000.0)),
            @"subType": @(UserPostTypeUpdateAvatar),
            @"userName": @"john",
            @"userAvatarURL": @"https://picsum.photos/40/40?u=change2",
            @"isLiked": @(arc4random_uniform(2)),
        }]; // fallback to current avatar

        // 3) Repost: with >= 1 subpost
        [mutableData addObject:@{
            @"type": @(CellModelTypeUserPost),
            @"subType": @(UserPostTypeRepost),
            @"userName": @"anna",
            @"userAvatarURL": @"https://picsum.photos/40/40?u=repost",
            @"postedDate": @(now - 10 * 60),
            @"subPosts": @[
                @{
                    @"userName": @"mark",
                    @"likeCount": @(3),
                    @"userAvatarURL": @"https://picsum.photos/40/40?u=mark"
                },
                @{
                    @"userName": @"lisa",
                    @"likeCount": @(5),
                    @"userAvatarURL": @"https://picsum.photos/40/40?u=lisa" }
            ],
            @"isLiked": @(arc4random_uniform(2)),
        }];

       
        // 4) Recommend video
        [mutableData addObject:@{
            @"type": @(CellModelTypeRecomendationVideo),
            @"recommendVideoURL": @[
                @"https://example.com/rec1.mp4",
                @"https://example.com/rec2.mp4",
                @"https://example.com/rec3.mp4"
            ]
        }];

        data = [mutableData copy];
    });
    return data;
}

@implementation CellModel
- (id)copyWithZone:(NSZone *)zone {
    CellModel *m = [[[self class] allocWithZone:zone] init];
    m.uuidString = self.uuidString;
    m.cellType = self.cellType;
    m.userPostType = self.userPostType;
    
    m.postText = self.postText;
    m.videoURL = self.videoURL;
    m.listImageURL = self.listImageURL;
    m.userUpdatedAvatar = self.userUpdatedAvatar;
    m.subPosts = self.subPosts;
    
    m.likeCount = self.likeCount;
    m.isLiked = self.isLiked;
    m.userName = self.userName;
    m.comments = self.comments;
    m.userAvatarURL = self.userAvatarURL;
    m.postedDate = self.postedDate;
    
    m.listShortURL = self.listShortURL;
    m.recommendVideoURL = self.recommendVideoURL;
    
    m.reuseKey = self.reuseKey;
    return m;
}

- (CellModel *)newModelWithToggleLike {
    CellModel *m = [self copy];
    m.isLiked = !self.isLiked;
    auto count = [self.likeCount intValue] + (m.isLiked ? 1 : -1);
    m.likeCount = @(count);
    return m;
}

@end


@implementation SubPost
@end
