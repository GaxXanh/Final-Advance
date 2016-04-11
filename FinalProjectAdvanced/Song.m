//
//  Song.m
//  AdvancedFinal
//
//  Created by Pham Anh on 4/8/16.
//  Copyright © 2016 com.gaxxanh.iosFinalProject. All rights reserved.
//

#import "Song.h"
#import "AdvancedFinal-PrefixHeader.pch"

@interface Song () {
    NSString *_name;
    NSString *_extensionPath;
    float _duration;
    NSString *_filePath;
    NSString *_artist;
    NSString *_durationInString;
    BOOL _isPlaying;
}

@end

@implementation Song

- (id) initWithFilePath:(NSString *)filePath
{
    self = [super init];
    if (self) {
        _filePath = filePath;
        NSString *fileAbsoluteName = [filePath lastPathComponent];
        _extensionPath = [fileAbsoluteName pathExtension];
        
        NSURL *url = [NSURL fileURLWithPath:filePath];
        AVAsset *asset = [AVURLAsset URLAssetWithURL:url
                                             options:nil];
        for (NSString *format in [asset availableMetadataFormats]) {
            for (AVMetadataItem *item in [asset metadataForFormat:format]) {
                if ([[item commonKey] isEqualToString:@"title"]) {
                    _name = (NSString *) [item value];
                }
                if ([[item commonKey] isEqualToString:@"artist"]) {
                    _artist = (NSString *) [item value];
                }
            }
        }
        
        if (_name == nil) {
            _name = @"(No Name)";
        }
        
        if ([_artist isEqualToString:@""]) {
            _name = @"...";
        }
        
        _duration = CMTimeGetSeconds([asset duration]);
        NSInteger minutes = (NSInteger)(CMTimeGetSeconds(asset.duration))/60;
        NSInteger seconds = (NSInteger)CMTimeGetSeconds(asset.duration) - (minutes * 60);
        
        _durationInString = [NSString stringWithFormat:@"%ld:%02ld",(long)minutes,(long)seconds];
    }
    
    return self;
}

- (NSString *)getName
{
    return _name;
}

- (NSString *)getDurationString
{
    return _durationInString;
}

- (NSString *)getFilePath
{
    return _filePath;
}

- (NSString *)getArtist
{
    return _artist;
}

@end
