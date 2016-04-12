//
//  PlayMusic.h
//  AdvancedFinal
//
//  Created by Pham Anh on 4/8/16.
//  Copyright © 2016 com.gaxxanh.iosFinalProject. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayViewController.h"
#import "AdvancedFinal-PrefixHeader.pch"

@protocol PlayManagerMusicDelegate <NSObject>

@optional

/* audioPlayerDidFinishPlaying:successfully: is called when a sound has finished playing. */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player withIndex:(NSInteger)index;
/* audioPlayerWillPlaing: is called when a sound will playing */
- (void)audioPlayerWillPlaying:(AVAudioPlayer *)player andSongInfo:(Song *)song withPreviousIndex:(NSInteger)prevIndex atIndex:(NSInteger)index;

@end

@interface PlayManagerMusic : NSObject

+ (PlayManagerMusic *) sharedInstance;

- (AVAudioPlayer *) audioPlayer;
- (void) addDelegate:(id<PlayManagerMusicDelegate>)delegate;
- (void) setPlayViewController:(PlayViewController *)playViewController;
- (NSArray<Song *> *) reloadListSong;
- (void) playSongAtIndex:(NSInteger)index;
- (void) next;
- (void) previous;
- (void) play;

- (void) updateNowPlayingInfo;

@end
