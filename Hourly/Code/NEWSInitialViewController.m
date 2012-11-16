//
//  NEWSInitialViewController.m
//  Hourly
//
//  Created by Zach Williams on 11/15/12.
//  Copyright (c) 2012 Zach Williams. All rights reserved.
//

#import "NEWSInitialViewController.h"

@interface NEWSInitialViewController ()

@end

// ***************************************************************************

static NSString * const kNPRAudioURL = @"http://app.npr.org/anon.npr-mp3/npr/news/newscast.mp3";

// ***************************************************************************

@implementation NEWSInitialViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    
    // UIToolbar
    [self addToolbarItems];
    [self.view addSubview:self.toolbar];
}

#pragma mark - UIToolbar

- (UIToolbar *)toolbar {
    if (_toolbar != nil) {
        return _toolbar;
    }
    
    float toolbarHeight = 40.0f;
    CGRect toolbarRect  = CGRectMake(0, self.view.frame.size.height - toolbarHeight, self.view.frame.size.width, toolbarHeight);
    _toolbar = [[UIToolbar alloc] initWithFrame:toolbarRect];
    return _toolbar;
}

- (void)addToolbarItems {
    self.toolbar.items = @[self.playButton];
}

#pragma mark - UIBarButtonItem

- (UIBarButtonItem *)playButton {
    if (_playButton != nil) {
        return _playButton;
    }
    
    _playButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playNews)];
    return _playButton;
}

#pragma mark - AVAudioPlayer

- (AVAudioPlayer *)audioPlayer {
    if (_audioPlayer != nil) {
        return _audioPlayer;
    }
    
    NSError *error;
    NSData *npr  = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:kNPRAudioURL]];
    _audioPlayer = [[AVAudioPlayer alloc] initWithData:npr error:&error];
    _audioPlayer.delegate = self;
    
    if (error) {
        NSLog(@"Audio Player Error: %@", error);
    }
    
    return _audioPlayer;
}

- (void)playNews {
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
    } else {
        [self.audioPlayer play];
    }
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
}

@end
