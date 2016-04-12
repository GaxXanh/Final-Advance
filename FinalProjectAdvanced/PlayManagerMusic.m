//
//  PlayMusic.m
//  AdvancedFinal
//
//  Created by Pham Anh on 4/8/16.
//  Copyright © 2016 com.gaxxanh.iosFinalProject. All rights reserved.
//

#import "PlayManagerMusic.h"

@interface PlayManagerMusic () <AVAudioPlayerDelegate> {
    NSArray<Song *> *_listSong;
    NSInteger _nowIndex;
    NSInteger _previousIndex;
}

@property (copy, nonatomic) NSArray *delegates;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) PlayViewController *playViewController;

@end

@implementation PlayManagerMusic

+ (PlayManagerMusic *)sharedInstance
{
    static PlayManagerMusic *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[PlayManagerMusic alloc] init];
    });
    return _sharedInstance;
}

- (id) init
{
    self = [super init];
    if (self) {
        _nowIndex = -1;
        _previousIndex = -1;
        self.delegates = @[];
    }
    
    return self;
}

-(void)addDelegate:(id<PlayManagerMusicDelegate>)delegate {
    NSMutableArray *delegatesCopy = [self.delegates mutableCopy];
    [delegatesCopy addObject:delegate];
    [self setDelegates:delegatesCopy];
}

- (NSArray<Song *> *) reloadListSong {
    if (self) {
        _listSong = [sLibraryAPI getListMusic];
    }
    
    return _listSong;
}

- (void) playSongAtIndex:(NSInteger)index {
    
    if (_nowIndex != -1) {
        _previousIndex = _nowIndex;
        _nowIndex = index;
        
        // Alway set isPlaying property of previousIndex to NO, then will reload with protocol
        [self restorePreviousSong];
        
    } else {
        _nowIndex = index;
    }
    
    [self play];
    
}

- (void) restorePreviousSong {
    
    [[_listSong objectAtIndex:_previousIndex] setIsPlaying:NO];
    
}



- (void) play {
    
    Song *nowPlayingSong = [_listSong objectAtIndex:_nowIndex];
    
    NSString *filePath = [nowPlayingSong getFilePath];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData
                                                 error:&error];
    _audioPlayer.delegate = self;
    
    if (_audioPlayer != nil) {
        
        if ([_audioPlayer prepareToPlay]) {
            
            // Success prepare
            
            [self updateNowPlayingInfo];
            
            [nowPlayingSong setIsPlaying:YES];
            
            _audioPlayer.delegate = self;
            
            for (id <PlayManagerMusicDelegate> delegate in self.delegates) {
                if ([delegate respondsToSelector:@selector(audioPlayerWillPlaying:andSongInfo:withPreviousIndex:atIndex:)]) {
                    [delegate audioPlayerWillPlaying:self.audioPlayer
                                         andSongInfo:nowPlayingSong
                                   withPreviousIndex:_previousIndex
                                             atIndex:_nowIndex];
                }
            }
            
            if ([_audioPlayer play]) {
                // Success play
            } else {
                // Failed to play
            }
        }
        
    } else {
        NSLog(@"Failed: %@", error);
    }

}

- (void) next {
    
    if ([_listSong count] - 1 > _nowIndex) {
        
        _previousIndex = _nowIndex;
        
        _nowIndex++;
        
        [self restorePreviousSong];
    }
    
    [self play];
}

- (void) previous {
    if (_nowIndex > 0) {
        
        _previousIndex = _nowIndex;
        
        _nowIndex--;
        
        [self restorePreviousSong];
    }
    
    [self play];
}

#pragma mark - Playing Center

- (void) updateNowPlayingInfo {
    
    Song *nowPlayingSong = [_listSong objectAtIndex:_nowIndex];
    
    NSMutableDictionary *albumInfo = [[NSMutableDictionary alloc] init];
    albumInfo[MPMediaItemPropertyTitle] = [nowPlayingSong getName];
    albumInfo[MPMediaItemPropertyArtist] = [nowPlayingSong getArtist];
    albumInfo[MPMediaItemPropertyAlbumTitle] = [nowPlayingSong getAlbumName];
    albumInfo[MPMediaItemPropertyPlaybackDuration] = [NSNumber numberWithDouble:[[self audioPlayer] duration]];
    albumInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = [NSNumber numberWithDouble:[[self audioPlayer] currentTime]];
    MPMediaItemArtwork *songArtwork = [[MPMediaItemArtwork alloc] initWithImage:[nowPlayingSong getArtwork]];
    albumInfo[MPMediaItemPropertyArtwork] = songArtwork;
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:albumInfo];
    
}

#pragma mark - <AVAudioPlayerDelegate>

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    for (id <PlayManagerMusicDelegate> delegate in self.delegates) {
        if ([delegate respondsToSelector:@selector(audioPlayerDidFinishPlaying:withIndex:)]) {
            [delegate audioPlayerDidFinishPlaying:[self audioPlayer]
                                        withIndex:_nowIndex];
        }
    }
    
    [self next];
    
}

@end
