//
//  PlayViewController.m
//  AdvancedFinal
//
//  Created by Pham Anh on 4/10/16.
//  Copyright © 2016 com.gaxxanh.iosFinalProject. All rights reserved.
//

#import "PlayViewController.h"
#import "AdvancedFinal-PrefixHeader.pch"

@interface PlayViewController () <PlayManagerMusicDelegate> {
    NSTimer *_timer;
}

@property (weak, nonatomic) IBOutlet UISlider *sliderAudio;
@property (weak, nonatomic) IBOutlet UILabel *lblNameAudio;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation PlayViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [sPlayManagerMusic addDelegate:self];
}

- (void) viewWillAppear:(BOOL)animated {
    [[self lblNameAudio] setText:@""];
    [[self sliderAudio] setValue:0.0f];
    [[self sliderAudio] setContinuous:YES];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIView *view = [self view];
    CGRect r = view.frame;
    CGRect boundMainScreen = [[UIScreen mainScreen] bounds];
    r.origin.y += boundMainScreen.size.height;
    [view setFrame:r];
    
}

#pragma mark - IBAction

- (IBAction)previous:(id)sender {
    [sPlayManagerMusic previous];
}

- (IBAction)changeValueSlider:(id)sender {
    self.audioPlayer.currentTime = self.sliderAudio.value;
}

- (IBAction)next:(id)sender {
    [sPlayManagerMusic next];
}

#pragma mark - Timer

- (void) stopTimerForSlider {
    if ([_timer isValid]) {
        [_timer invalidate];
    }
    
    _timer = nil;
}

- (void) startTimer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                  target:self
                                                selector:@selector(updateSlider)
                                                userInfo:nil
                                                 repeats:YES];
    }
}

- (void) updateSlider {
    [self.sliderAudio setValue:self.audioPlayer.currentTime animated:YES];
}

#pragma mark - AVAudioPlayer Delegate <AVAudioPlayerDelegate>

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"abc");
}

#pragma mark - <PlayManagerMusicDelegate>

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player {
    [UIView animateWithDuration:0.7 animations:^{
        [[self sliderAudio] setValue:0.0f animated:YES];
    }];
}

- (void)audioPlayerWillPlaying:(AVAudioPlayer *)player andSongInfo:(Song *)song atIndex:(NSInteger)index {
    
    [self setAudioPlayer:player];
    
    [self stopTimerForSlider];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.7 animations:^{
            [[self sliderAudio] setValue:0.0f animated:YES];
        }];
        [[self sliderAudio] setMaximumValue:[player duration]];
        [self startTimer];
        [self.lblNameAudio setText:song.getName];
    });
    
//    [self.lblNameAudio setText:song.getName];
}

@end
