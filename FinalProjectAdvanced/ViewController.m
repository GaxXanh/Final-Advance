//
//  ViewController.m
//  FinalProjectAdvanced
//
//  Created by Pham Anh on 4/8/16.
//  Copyright © 2016 com.gaxxanh.iosFinalProject. All rights reserved.
//

#import "ViewController.h"
#import "AdvancedFinal-PrefixHeader.pch"

@interface ViewController () <AVAudioPlayerDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSArray *listSong;
}

@property (weak, nonatomic) IBOutlet UISlider *sliderTimer;
@property (weak, nonatomic) IBOutlet UITableView *tblSong;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initForTheFirstTime];
    
}

- (void) initForTheFirstTime
{
    listSong = [[NSArray alloc] initWithArray:[sLibraryAPI getListMusic]];
    [sPlayMusic setListSong:listSong];
//    [sPlayMusic setDelegateForAVAudioPlayer:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)next:(id)sender {
}

- (IBAction)forward:(id)sender {
}

//- (CGFloat) getAudioDuration {
////    return [self.audioPlayer duration];
//}

#pragma mark - AVAudioPlayer Delegate

#pragma mark - TableView Delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tblSong]) {
        [sPlayMusic playSongAtIndex:indexPath.row];
    }
}

#pragma mark - TableView Datasource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tblSong]) {
        if (section == 0) {
            return [listSong count];
        }
    }
    
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tblSong]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellSong forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellSong];
        }
        
        cell.textLabel.text = [[listSong objectAtIndex:indexPath.row] getName];
        
        return cell;
    }
    
    return nil;
}


@end
