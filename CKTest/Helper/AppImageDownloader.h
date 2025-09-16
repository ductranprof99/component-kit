//
//  CKTestImageDownloader.h
//  CKTest
//
//  Created by ductd on 16/9/25.
//

#import <ComponentKit/CKNetworkImageDownloading.h>

@interface AppImageDownloader : NSObject <CKNetworkImageDownloading>
@property (nonatomic, strong) NSURLSession *backgroundSession;
@property (nonatomic, copy) void (^backgroundCompletionHandler)(void);
@end
