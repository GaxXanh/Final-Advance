//
//  ViewController.m
//  FinalProjectAdvanced
//
//  Created by Pham Anh on 4/8/16.
//  Copyright © 2016 com.gaxxanh.iosFinalProject. All rights reserved.
//

#import "ViewController.h"
#import "AdvancedFinal-PrefixHeader.pch"

@interface ViewController () <AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UISlider *sliderTimer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initForTheFirstTime];
    
//    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//
//    dispatch_async(dispatchQueue, ^{
//        
//        NSString *filePath = [[sLibraryAPI documentFolderPath] stringByAppendingPathComponent:@"01 Lonely.mp3"];
//        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
//        NSError *error = nil;
//        
//        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData
//                                                         error:&error];
//        
//        if (self.audioPlayer != nil) {
//            self.audioPlayer.delegate = self;
//            if ([self.audioPlayer prepareToPlay] && [self.audioPlayer play]) {
//                NSLog(@"Successfully player");
//            } else {
//                NSLog(@"Failed");
//            }
//        }
//        
//        // Start audio
//        
//    });
}

- (void) initForTheFirstTime
{
    self.audioPlayer = [[AVAudioPlayer alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)next:(id)sender {
}

- (IBAction)forward:(id)sender {
}

#pragma mark - AVAudioPlayer Delegate


@end
