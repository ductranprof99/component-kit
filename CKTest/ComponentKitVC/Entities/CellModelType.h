//
//  CellModel 2.h
//  CKTest
//
//  Created by ductd on 11/9/25.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CellModelType) {
    CellModelTypeNewStatus,
    CellModelTypeUserPost,
    CellModelTypeRecomendationVideo,
    CellModelTypeShortList,
};

typedef NS_ENUM(NSInteger, UserPostType) {
    UserPostTypeNone, // for nothing value bro
    UserPostTypeVideo,
    UserPostTypeNormal,
    UserPostTypeUpdateAvatar,
    UserPostTypeRepost
};

