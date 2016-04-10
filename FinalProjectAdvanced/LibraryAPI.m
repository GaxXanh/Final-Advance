//
//  LibraryAPI.m
//  AdvancedFinal
//
//  Created by Pham Anh on 4/8/16.
//  Copyright © 2016 com.gaxxanh.iosFinalProject. All rights reserved.
//

#import "LibraryAPI.h"
#import "AdvancedFinal-PrefixHeader.pch"
#import "Song.h"

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
    NSString *documentFolderPath = [self documentFolderPath];
    NSArray *dirArray;
    dirArray = [fileManager contentsOfDirectoryAtPath:documentFolderPath error:nil];
    
    NSMutableArray<Song *> *listSong = [[NSMutableArray alloc] init];
    for (NSString *songItem in dirArray) {
        NSString *filePath = [documentFolderPath stringByAppendingPathComponent:songItem];
        if (filePath != nil) {
            Song *songItem = [[Song alloc] initWithFilePath:filePath];
            [listSong addObject:songItem];
        }
    }
    
    return [NSArray arrayWithArray:listSong];
}

@end
