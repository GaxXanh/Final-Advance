//
//  Song.m
//  AdvancedFinal
//
//  Created by Pham Anh on 4/8/16.
//  Copyright © 2016 com.gaxxanh.iosFinalProject. All rights reserved.
//

#import "Song.h"

@interface Song () {
    NSString *_name;
    NSString *_extensionPath;
    float _duration;
    NSString *_filePath;
}

@end

@implementation Song

- (id) initWithFilePath:(NSString *)filePath
{
    self = [super init];
    if (self) {
        _filePath = filePath;
        NSString *fileAbsoluteName = [filePath lastPathComponent];
        _name = [fileAbsoluteName stringByDeletingPathExtension];
        _extensionPath = [fileAbsoluteName pathExtension];
        _duration = 1.0f;
    }
    
    return self;
}

- (NSString *)getName
{
    return _name;
}

- (NSString *)getExtensionPath
{
    return _extensionPath;
}

- (float)getDuration
{
    return _duration;
}

- (NSString *)getFilePath
{
    return _filePath;
}

@end
