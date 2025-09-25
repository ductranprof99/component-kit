//
//  CellModel.h
//  CKTest
//
//  Created by ductd on 11/9/25.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CellModelType.h"

@interface SubPost: NSObject
@property (nonatomic, copy) NSNumber *likeCount;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, readonly) NSString *userAvatarURL;
@property (nonatomic, copy) NSArray<NSDictionary *> *comments;
@property (nonatomic, copy) NSURL *videoURL;
@property (nonatomic, copy) NSArray<NSString *> *listImageURL;
@property (nonatomic, copy) NSString *postText;
@end

@interface CellModel : NSObject
// main character
@property (atomic) NSString* uuidString;
@property (nonatomic) CellModelType cellType;
@property (nonatomic) UserPostType userPostType;

// user post
@property (nonatomic, copy) NSString *postText;
@property (nonatomic, copy) NSURL *videoURL;
@property (nonatomic, copy) NSArray<NSString *> *listImageURL;
@property (nonatomic, copy) NSString *userUpdatedAvatar;
@property (nonatomic, copy) NSArray<SubPost *> *subPosts;

// cell utility
@property (nonatomic, copy) NSNumber *likeCount;
@property (nonatomic, assign) BOOL isLiked;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSArray<NSDictionary *> *comments;
@property (nonatomic, copy, readwrite) NSString *userAvatarURL;
@property (nonatomic, copy, readwrite) NSDate *postedDate;

// short list + recommend video
@property (nonatomic, copy) NSArray<NSString *> *listShortURL;
@property (nonatomic, copy) NSArray<NSString *> *recommendVideoURL;

 // key value
@property (nonatomic, copy) NSString *reuseKey;
@end
