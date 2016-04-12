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

typedef enum {
    
    PLAYER_STATE_HIDDEN = 0,
    PLAYER_STATE_SHOW = 1,
    
} PLAYER_STATE;

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, PlayManagerMusicDelegate> {
    NSArray *listSong;
    NSInteger _nowIndex;
    NSInteger _oldIndex;
}

@property (weak, nonatomic) IBOutlet UITableView *tblSong;
@property (strong, nonatomic) PlayViewController *playerVC;
@property(nonatomic, assign) NSInteger playerState;

@end

@implementation ViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [sPlayManagerMusic addDelegate:self];
    _nowIndex = NSNotFound;
    self.playerState = PLAYER_STATE_HIDDEN;
    self.playerVC = [self.storyboard
                     instantiateViewControllerWithIdentifier:NSStringFromClass([PlayViewController class])];
    
    [[self view] addSubview:[[self playerVC] view]];
    [self addChildViewController:[self playerVC]];
    
    listSong = [[NSArray alloc] initWithArray:[sLibraryAPI getListMusic]];
    
}

#pragma mark - TableView Delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showPlayerView];
    if ([tableView isEqual:self.tblSong]) {
        [sPlayManagerMusic playSongAtIndex:indexPath.row];
//        [self drawAtIndex:[indexPath row]];
    }
}

#pragma mark - TableView Datasource

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tblSong]) {
        if (section == 0) {
            return [listSong count];
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
        
        UILabel *labelName = [cell.contentView viewWithTag:LABEL_NAME_TAG];
        labelName.text = [[listSong objectAtIndex:indexPath.row] getName];
        
        UILabel *labelArtist = [cell.contentView viewWithTag:LABEL_ARTIST_TAG];
        labelArtist.text = [[listSong objectAtIndex:indexPath.row] getArtist];
        
        UILabel *labelDuration = [cell.contentView viewWithTag:LABEL_DURATION_TAG];
        labelDuration.text = [[listSong objectAtIndex:indexPath.row] getDurationString];
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - <PlayManagerMusicDelegate>

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player withIndex:(NSInteger)index{
    
}

- (void) audioPlayerWillPlaying:(AVAudioPlayer *)player
                    andSongInfo:(Song *)song
                        atIndex:(NSInteger)index {
    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//    UITableViewCell *cell = [self.tblSong cellForRowAtIndexPath:indexPath];
//    UILabel *nameLabel = [cell.contentView viewWithTag:LABEL_NAME_TAG];
//    NSLog(@"%@", nameLabel.text);
//    UIView *progressView = [cell.contentView viewWithTag:PROGRESS_VIEW_TAG];
//
//    [progressView setHidden:YES];
//    [self.tblSong reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]
//                        withRowAnimation:UITableViewRowAnimationNone];

    
}

@end
