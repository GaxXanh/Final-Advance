//
//  PlayMusic.h
//  AdvancedFinal
//
//  Created by Pham Anh on 4/8/16.
//  Copyright © 2016 com.gaxxanh.iosFinalProject. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdvancedFinal-PrefixHeader.pch"

/** All delegate method is optional **/
@protocol PlayMusicDelegate <NSObject>

@optional

- (void) trackDidChange:(Song *)nowPlayingTrack previousTrack:(Song *)previousTrack;
- (void) endOfListReached:(Song *)lastTrack;

@end


@interface PlayMusic : NSObject 

+ (PlayMusic *) sharedInstance;
- (void) setListSong:(NSArray<Song *> *)listSong;
//- (void) setDelegateForAVAudioPlayer:(UIViewController *)viewController;
- (void) playSongAtIndex:(NSInteger)index;
- (void) next;
- (void) previous;

@end
