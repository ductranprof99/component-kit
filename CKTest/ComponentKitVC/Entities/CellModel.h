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
@end

@interface CellModel : NSObject
// main character
@property (atomic) NSString* uuidString;
@property (nonatomic) CellModelType cellType;

// user post
@property (nonatomic, copy) NSString *cellTextDescription;
@property (nonatomic, copy) NSURL *videoURL;
@property (nonatomic, copy) NSArray<NSString *> *listImageURL;
@property (nonatomic, copy) NSString *userUpdatedAvatar;

// cell utility
@property (nonatomic, copy) NSNumber *likeCount;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, readonly) NSString *userAvatarURL;
@property (nonatomic, copy) NSArray<NSDictionary *> *comments;
@property (nonatomic, copy) NSDate *cellPostDate;

// cell subpost
@property (nonatomic, copy) NSArray<SubPost *> *subPosts;

// short list + recommend video
@property (nonatomic, copy) NSArray<NSString *> *listShortURL;
@property (nonatomic, copy) NSArray<NSString *> *recommendVideoURL;

 // key value
@property (nonatomic, copy) NSString *reuseKey;
@end

