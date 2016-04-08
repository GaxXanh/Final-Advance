//
//  LibraryAPI.m
//  AdvancedFinal
//
//  Created by Pham Anh on 4/8/16.
//  Copyright © 2016 com.gaxxanh.iosFinalProject. All rights reserved.
//

#import "LibraryAPI.h"

@interface LibraryAPI () {
    NSFileManager *fileManager;
}

@end

@implementation LibraryAPI

+ (LibraryAPI *)sharedInstance
{
    static LibraryAPI *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[LibraryAPI alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        fileManager = [NSFileManager defaultManager];
        
    }
    return self;
}

- (NSString *)documentFolderPath;
{
    NSURL *url = [fileManager URLForDirectory:NSDocumentDirectory
                                     inDomain:NSUserDomainMask
                            appropriateForURL:nil
                                       create:NO
                                        error:nil];
    
    return url.path;
}

- (NSArray *)getListMusic
{
    return nil;
}

@end
