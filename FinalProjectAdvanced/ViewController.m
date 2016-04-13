//
//  ViewController.m
//  FinalProjectAdvanced
//
//  Created by Pham Anh on 4/8/16.
//  Copyright © 2016 com.gaxxanh.iosFinalProject. All rights reserved.
//

#import "ViewController.h"
#import "AdvancedFinal-PrefixHeader.pch"
#import "PlayViewController.h"
#import "AppDelegate.h"

#define kStartAngle -M_PI_2

typedef enum {
    
    PLAYER_STATE_HIDDEN = 0,
    PLAYER_STATE_SHOW = 1,
    
} PLAYER_STATE;

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, PlayManagerMusicDelegate> {
    NSArray *_listSong;
    NSTimer *_timer;
    UIView *_progressView;
    AVAudioPlayer *_player;
}

@property (weak, nonatomic) IBOutlet UITableView *tblSong;
@property (strong, nonatomic) PlayViewController *playerVC;
@property(nonatomic, assign) NSInteger playerState;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [sPlayManagerMusic addDelegate:self];
    _listSong = [sPlayManagerMusic reloadListSong];
    
    self.playerState = PLAYER_STATE_HIDDEN;
    self.playerVC = [self.storyboard
                     instantiateViewControllerWithIdentifier:NSStringFromClass([PlayViewController class])];
    
    [[self view] addSubview:[[self playerVC] view]];
    [self addChildViewController:[self playerVC]];
    
}

#pragma mark - Private Methods

- (void) showPlayerView {
    if ([self playerVC] != nil && [self playerState] == PLAYER_STATE_HIDDEN) {
        
        [UIView animateWithDuration:kDurationAnimateGoUp
                              delay:0.1
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             UIView *view = [[self playerVC] view];
                             CGRect r = view.frame;
                             r.origin.y -= 80;
                             [view setFrame:r];
                             
                         } completion:^(BOOL finished) {
                             
                             NSArray<__kindof NSLayoutConstraint *> *constraintsOfView = [[self view] constraints];
                             
                             for (NSLayoutConstraint *constraint in constraintsOfView) {
                                 if ([constraint.identifier isEqualToString:@"bottomMargin"]) {
                                     constraint.constant = 80;
                                 }
                             }
                             
                         }];
        
        [self setPlayerState:PLAYER_STATE_SHOW];
        
    }
}

- (void) drawProgressCircleViewWithAudioPlayer:(AVAudioPlayer *)player
                                   atIndexPath:(NSIndexPath *)indexPath {
    
    [self resetTimer];
    
    UITableViewCell *cell = [self.tblSong cellForRowAtIndexPath:indexPath];
    _progressView = [cell.contentView viewWithTag:PROGRESS_VIEW_TAG];
    _player = player;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                              target:self
                                            selector:@selector(drawCircleTimer:)
                                            userInfo:nil
                                             repeats:YES];
    
}

- (void) drawCircleTimer:(NSTimer *)timer {
    
    [self removeSubLayer:_progressView];
    float percentTime = _player.currentTime / _player.duration;
    [self drawArcCircleForTime:_progressView andPercentTime:percentTime];
}

- (void) removeSubLayer:(UIView *)view {
    for (CAShapeLayer *layer in view.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
}

- (void)drawArcCircleForTime:(UIView *)viewTime
              andPercentTime:(float)percentTime {
    
    CGPoint center = CGPointMake(viewTime.frame.size.width/2, viewTime.frame.size.height/2);
    
    CAShapeLayer *circle = [CAShapeLayer layer];
    
    circle.path = [[self createCircle:center
                           withRadius:20
                          withPercent:percentTime] CGPath];
    
    circle.fillColor = [[UIColor redColor] CGColor];
    circle.strokeColor = [[UIColor blackColor] CGColor];
    circle.lineWidth = 0.3f;
    
    [viewTime.layer addSublayer:circle];
    
}

- (UIBezierPath *)createCircle:(CGPoint)center
                      withRadius:(CGFloat)radius
                     withPercent:(CGFloat)percent {
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle: -M_PI / 2
                                                      endAngle: ((M_PI * 2.0) * percent) - M_PI / 2
                                                     clockwise:YES];
    
    [path addLineToPoint:center];
    [path closePath];
    return path;
    
}

- (void) resetTimer {
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - TableView Delegate

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self resetTimer];
    [self showPlayerView];
    if ([tableView isEqual:self.tblSong]) {
        NSInteger indexOfSong = [indexPath row];
        [sPlayManagerMusic playSongAtIndex:indexOfSong];
    }
}

#pragma mark - TableView Datasource

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tblSong]) {
        if (section == 0) {
            return [_listSong count];
        }
    }
    
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tblSong]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellSong
                                                                forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellSong];
        }
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Song *song = [_listSong objectAtIndex:[indexPath row]];

    UILabel *labelName = [cell.contentView viewWithTag:LABEL_NAME_TAG];
    labelName.text = [[_listSong objectAtIndex:[indexPath row]] getName];
    
    UILabel *labelArtist = [cell.contentView viewWithTag:LABEL_ARTIST_TAG];
    labelArtist.text = [[_listSong objectAtIndex:[indexPath row]] getArtist];
    
    UILabel *labelDuration = [cell.contentView viewWithTag:LABEL_DURATION_TAG];
    
    UIView *progressView = [cell.contentView viewWithTag:PROGRESS_VIEW_TAG];
    
    if ([song isPlaying]) {
        
        /** For Cell Playing **/
        
        [labelDuration setText:@""];
        [progressView setHidden:NO];
        
    } else {
        
        /** For Cell Not Playing **/
        
        NSString *durationString = [[_listSong objectAtIndex:[indexPath row]] getDurationString];
        [labelDuration setText:durationString];
        [labelDuration setAlpha:0.0f];
        [progressView setHidden:YES];
        
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             [labelDuration setAlpha:1.0f];
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    
}

#pragma mark - <PlayManagerMusicDelegate>

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player withIndex:(NSInteger)index{
    
}

- (void) audioPlayerWillPlaying:(AVAudioPlayer *)player
                    andSongInfo:(Song *)song
              withPreviousIndex:(NSInteger)prevIndex
                        atIndex:(NSInteger)index {
    
    NSIndexPath *previousPath = [NSIndexPath indexPathForRow:prevIndex
                                                   inSection:0];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index
                                                inSection:0];
    
    [self.tblSong reloadRowsAtIndexPaths:@[previousPath, indexPath]
                        withRowAnimation:UITableViewRowAnimationNone];
    
    [self drawProgressCircleViewWithAudioPlayer:player atIndexPath:indexPath];
    
}

@end
