//
//  Song.h
//  AdvancedFinal
//
//  Created by Pham Anh on 4/8/16.
//  Copyright © 2016 com.gaxxanh.iosFinalProject. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Song : NSObject

- (id) initWithFilePath:(NSString *)filePath;
- (NSString *)getName;
- (NSString *)getFilePath;
- (NSString *)getArtist;
- (NSString *)getAlbumName;
- (NSString *)getDurationString;
- (BOOL)isPlaying;
- (void)setIsPlaying:(BOOL)isPlaying;
- (UIImage *)getArtwork;

@end
