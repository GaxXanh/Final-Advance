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
    dispatch_queue_t _dispatchQueue;
    NSInteger _index;
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
        _dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _index = NSNotFound;
        self.delegates = @[];
    }
    
    return self;
}

-(void)addDelegate:(id<PlayManagerMusicDelegate>)delegate {
    NSMutableArray *delegatesCopy = [self.delegates mutableCopy];
    [delegatesCopy addObject:delegate];
    [self setDelegates:delegatesCopy];
}

- (void) setListSong:(NSArray<Song *> *)listSong {
    if (self) {
        _listSong = listSong;
    }
}

- (void) setPlayViewController:(PlayViewController *)playViewController {
    if (self) {
        _playViewController = playViewController;
    }
}

- (void) playSongAtIndex:(NSInteger)index
{
    
    if ([_listSong count] >= index) {
        _index = index;
        dispatch_suspend(_dispatchQueue);
        dispatch_resume(_dispatchQueue);
        dispatch_async(_dispatchQueue, ^{
            Song *currentSong = [_listSong objectAtIndex:index];
            
            NSString *filePath = [currentSong getFilePath];
            NSData *fileData = [NSData dataWithContentsOfFile:filePath];
            NSError *error = nil;
            
            _audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
            _audioPlayer.delegate = self;
            
            if (_audioPlayer != nil) {
                
                for (id <PlayManagerMusicDelegate> delegate in self.delegates) {
                    if ([delegate respondsToSelector:@selector(audioPlayerWillPlaying:andSongInfo:atIndex:)]) {
                        [delegate audioPlayerWillPlaying:self.audioPlayer andSongInfo:[_listSong objectAtIndex:index] atIndex:_index];
                    }
                }
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


#pragma mark - <AVAudioPlayerDelegate>

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    for (id <PlayManagerMusicDelegate> delegate in self.delegates) {
        if ([delegate respondsToSelector:@selector(audioPlayerDidFinishPlaying:withIndex:)]) {
            [delegate audioPlayerDidFinishPlaying:[self audioPlayer] withIndex:_index];
        }
    }
    
}

@end
