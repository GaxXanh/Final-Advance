//
//  PlayMusic.m
//  AdvancedFinal
//
//  Created by Pham Anh on 4/8/16.
//  Copyright © 2016 com.gaxxanh.iosFinalProject. All rights reserved.
//

#import "PlayMusic.h"
#import "AdvancedFinal-PrefixHeader.pch"

@interface PlayMusic () <AVAudioPlayerDelegate> {
    AVAudioPlayer *_audioPlayer;
    NSArray<Song *> *_listSong;
    dispatch_queue_t _dispatchQueue;
    NSInteger _index;
}

@end

@implementation PlayMusic

+ (PlayMusic *)sharedInstance
{
    static PlayMusic *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[PlayMusic alloc] init];
    });
    return _sharedInstance;
}

- (id) init
{
    self = [super init];
    if (self) {
        _audioPlayer = [[AVAudioPlayer alloc] init];
        _dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _index = 0;
    }
    
    return self;
}

- (void) setDelegateForAVAudioPlayer:(UIViewController *)viewController
{
    
}

- (void) setListSong:(NSArray<Song *> *)listSong
{
    if (self) {
        _listSong = listSong;
    }
}

- (void) playSongAtIndex:(NSInteger)index
{
    if ([_listSong count] >= index) {
        if (_audioPlayer != nil) {
            dispatch_suspend(_dispatchQueue);
            dispatch_resume(_dispatchQueue);
            dispatch_async(_dispatchQueue, ^{
                Song *currentSong = [_listSong objectAtIndex:index];
                
                NSString *filePath = [currentSong getFilePath];
                NSData *fileData = [NSData dataWithContentsOfFile:filePath];
                NSError *error = nil;
                
                _audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
                
                if (_audioPlayer != nil) {
                    if ([_audioPlayer prepareToPlay] && [_audioPlayer play]) {
                        // Success
                    } else {
                        // Failed
                    }
                } else {
                    // Failed to instantiate AVAudioPlayer
                }
            });
        }
    }
}

- (void) next
{
    if ([_listSong count] > _index) {
        _index++;
        [self playSongAtIndex:_index];
    } else {
        _index = 0;
        [self playSongAtIndex:_index];
    }
}

- (void) previous
{
    if (index > 0) {
        _index--;
        [self playSongAtIndex:_index];
    } else {
        _index = [_listSong count];
        [self playSongAtIndex:_index];
    }
}

#pragma mark - Audio Player Delegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"abc");
}

@end
