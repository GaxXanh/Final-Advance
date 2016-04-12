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
    NSString *_albumName;
    BOOL _isPlaying;
    UIImage *_artwork;
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
                
                NSLog(@"%@", (NSString *) [item commonKey]);
                
                if ([[item commonKey] isEqualToString:@"title"]) {
                    _name = (NSString *) [item value];
                }
                if ([[item commonKey] isEqualToString:@"artist"]) {
                    _artist = (NSString *) [item value];
                }
                
                if ([[item commonKey] isEqualToString:@"albumName"]) {
                    _albumName = (NSString *) [item value];
                }
                
                if ([[item commonKey] isEqualToString:@"artwork"]) {
                    
                    if ([item.keySpace isEqualToString:AVMetadataKeySpaceID3]) {
                        _artwork = [UIImage imageWithData:[item.value copyWithZone:nil]];
                    }
                    
                    else if ([item.keySpace isEqualToString:AVMetadataKeySpaceiTunes]) {
                        _artwork = [UIImage imageWithData:[item.value copyWithZone:nil]];
                    }
                    
                }
            }
        }
        
        if (_artwork == nil) {
            _artwork = [UIImage imageNamed:@"default-artwork.jpg"];
        }
        
        if (_name == nil) {
            _name = @"(No Name)";
        }
        
        if ([_artist isEqualToString:@""]) {
            _name = @"...";
        }
        
        if ([_albumName isEqualToString:@""]) {
            _albumName = @"...";
        }
        
        _duration = CMTimeGetSeconds([asset duration]);
        NSInteger minutes = (NSInteger)(CMTimeGetSeconds(asset.duration))/60;
        NSInteger seconds = (NSInteger)CMTimeGetSeconds(asset.duration) - (minutes * 60);
        
        _durationInString = [NSString stringWithFormat:@"%ld:%02ld",(long)minutes,(long)seconds];
        
        _isPlaying = NO;
    }
    
    return self;
}

- (UIImage *)getArtwork
{
    return _artwork;
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

- (NSString *)getAlbumName
{
    return _albumName;
}

- (void)setIsPlaying:(BOOL)isPlaying
{
    if (self) {
        _isPlaying = isPlaying;
    }
}

- (BOOL)isPlaying
{
    return _isPlaying;
}

@end
