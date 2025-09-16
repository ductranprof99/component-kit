//
//  AppImageDownloader.m
//  CKTest
//
//  Created by ductd on 16/9/25.
//

#import "AppImageDownloader.h"
#import <UIKit/UIKit.h>

typedef id (^ImageDownloaderBlock)(NSURL *url,
                                      id caller,
                        dispatch_queue_t callbackQueue,
                                    void (^downloadProgressBlock)(CGFloat),
                                   void (^completion)(CGImageRef, NSError*));

@implementation AppImageDownloader
{
    ImageDownloaderBlock _downloadImageBlock;
    NSString *sessionID;
}

- (instancetype)initWithDownloadImageBlock:(ImageDownloaderBlock)downloadImageBlock
{
    sessionID = @"com.cktest.image.bg";
    self = [super init];
    if (self) {
        _downloadImageBlock = [downloadImageBlock copy];
    }
    
    NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:sessionID];
    
    cfg.discretionary = YES;
    cfg.sessionSendsLaunchEvents = YES;
    
    return self;
}

- (void)cancelImageDownload:(id)download {
    // Support common cancellable tokens (NSURLSessionTask or any object responding to -cancel)
    if (!download) { return; }
    if ([download respondsToSelector:@selector(cancel)]) {
        @try {
            [download performSelector:@selector(cancel)];
        } @catch (__attribute__((unused)) NSException *exception) {
            // Silently ignore if the token is not cancellable
        }
    }
}

/// Check: Becareful with this function, you can download multiple image yes, but how you control it is a disaster
+ (instancetype) sharedDownloader {
    static AppImageDownloader *dl;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dl = [[AppImageDownloader alloc] initWithDownloadImageBlock:nil];
    });
    return dl;
}


- (id)downloadImageWithURL:(NSURL *)URL
                    caller:(id)caller
             callbackQueue:(dispatch_queue_t)callbackQueue
     downloadProgressBlock:(void (^)(CGFloat))downloadProgressBlock
                completion:(void (^)(CGImageRef, NSError *))completion {
    // If a custom downloader block was injected, use it
    if (_downloadImageBlock) {
        return _downloadImageBlock(URL, caller, callbackQueue, downloadProgressBlock, completion);
    }

    // Fallback: simple NSURLSession-based downloader.
    // Progress reporting is minimal (0.0 at start, 1.0 on completion).
    if (!URL) {
//        if (completion) {
//            dispatch_async(callbackQueue ?: dispatch_get_main_queue(), ^{
//                NSError *err = [NSError errorWithDomain:@"AppImageDownloader"
//                                                   code:-1
//                                               userInfo:@{NSLocalizedDescriptionKey: @"Invalid URL"}];
//                completion(NULL, err);
//            });
//        }
        return nil;
    }

    // Notify start progress
    if (downloadProgressBlock) {
        dispatch_async(callbackQueue ?: dispatch_get_main_queue(), ^{
            downloadProgressBlock(0.0);
        });
    }

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:URL
                                        completionHandler:^(NSData * _Nullable data,
                                                            NSURLResponse * _Nullable response,
                                                            NSError * _Nullable error)
    {
        dispatch_queue_t queue = callbackQueue ?: dispatch_get_main_queue();
        if (error || !data.length) {
            if (completion) {
                dispatch_async(queue, ^{
                    completion(NULL, error ?: [NSError errorWithDomain:@"AppImageDownloader"
                                                                 code:-2
                                                             userInfo:@{NSLocalizedDescriptionKey: @"No data"}]);
                });
            }
            return;
        }

        UIImage *uiImage = [UIImage imageWithData:data];
        if (!uiImage.CGImage) {
            if (completion) {
                dispatch_async(queue, ^{
                    NSError *err = [NSError errorWithDomain:@"AppImageDownloader"
                                                       code:-3
                                                   userInfo:@{NSLocalizedDescriptionKey: @"Failed to decode image"}];
                    completion(NULL, err);
                });
            }
            return;
        }

        CGImageRef cg = CGImageRetain(uiImage.CGImage); // Retain to own across the async call
        dispatch_async(queue, ^{
            if (downloadProgressBlock) {
                downloadProgressBlock(1.0);
            }
            if (completion) {
                completion(cg, nil);
            }
            CGImageRelease(cg);
        });
    }];

    [task resume];
    return task; // Return the task as the cancellation token
}

@end
