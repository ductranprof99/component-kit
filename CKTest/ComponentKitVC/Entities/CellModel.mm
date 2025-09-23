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

// Make read-only avatar URLs writeable within this translation unit
@interface CellModel ()
@property (nonatomic, copy, readwrite) NSString *userAvatarURL;
@end

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
            id likeCount = dict[@"likeCount"]; if (likeCount) model.likeCount = likeCount;
            NSArray *comments = dict[@"comments"]; if ([comments isKindOfClass:[NSArray class]]) model.comments = comments;
            NSString *userName = dict[@"userName"]; if (userName) model.userName = userName;
            NSString *avatarURL = dict[@"userAvatarURL"]; if ([avatarURL isKindOfClass:[NSString class]] && avatarURL.length > 0) model.userAvatarURL = avatarURL;
            
            NSString *text = dict[@"text"]; if (text) model.cellTextDescription = text;
            
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
                @"userAvatarURL": @"https://picsum.photos/40/40?u=normal"
            }];
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
                @"userAvatarURL": @"https://picsum.photos/40/40?u=video"
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
                @"userAvatarURL": @"https://picsum.photos/40/40?u=image"
            }];
        }

        // 2.4) Change avatar posts
        [mutableData addObject:@{
                    @"type": @(CellModelTypeUserPost),
       @"userUpdatedAvatar":@"https://picsum.photos/200/200?avatar",
                @"userName": @"john",
           @"userAvatarURL": @"https://picsum.photos/40/40?u=change"
        }];
        
        [mutableData addObject:@{
            @"type": @(CellModelTypeUserPost),
            @"subType": @(UserPostTypeUpdateAvatar),
            @"userName": @"john",
            @"userAvatarURL": @"https://picsum.photos/40/40?u=change2"
        }]; // fallback to current avatar

        // 3) Repost: with >= 1 subpost
        [mutableData addObject:@{
            @"type": @(CellModelTypeUserPost),
            @"subType": @(UserPostTypeRepost),
            @"userName": @"anna",
            @"userAvatarURL": @"https://picsum.photos/40/40?u=repost",
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
            ]
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
@end


@implementation SubPost
@end
