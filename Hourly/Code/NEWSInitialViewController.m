//
//  NEWSInitialViewController.m
//  Hourly
//
//  Created by Zach Williams on 11/15/12.
//  Copyright (c) 2012 Zach Williams. All rights reserved.
//

#import "NEWSInitialViewController.h"
#import <tgmath.h>

// ***************************************************************************

@interface NEWSInitialViewController ()

@property (nonatomic, strong) NSData *audioData;

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
    
    // Load the audio data
    [self preloadAudioData];
    [self createTimer];
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
    UIBarButtonItem *slider = [[UIBarButtonItem alloc] initWithCustomView:self.slider];
    self.toolbar.items = @[self.playButton, slider];
}

#pragma mark - UIBarButtonItems

- (UIBarButtonItem *)playButton {
    if (_playButton != nil) {
        return _playButton;
    }
    
    _playButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playNews)];
    _playButton.enabled = NO;
    return _playButton;
}

- (UISlider *)slider {
    if (_slider != nil) {
        return _slider;
    }
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    return _slider;
}

#pragma mark - AVAudioPlayer

- (AVAudioPlayer *)audioPlayer {
    if (_audioPlayer != nil) {
        return _audioPlayer;
    }
    
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithData:self.audioData error:&error];
    [_audioPlayer prepareToPlay];
    _audioPlayer.delegate = self;
    
    if (error) {
        NSLog(@"%@", error);
    }
    
    return _audioPlayer;
}

- (void)playNews {
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer pause];
    } else {
        [self.audioPlayer play];
        NSTimeInterval duration = self.audioPlayer.duration;
        NSLog(@"%.0f:%02.0f", floorf(duration / 60), fmod(duration, 60));
    }
}

#pragma mark - Audio Data

- (void)preloadAudioData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *audio = [NSData dataWithContentsOfURL:[NSURL URLWithString:kNPRAudioURL]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.audioData = audio;
            self.playButton.enabled  = YES;
            self.slider.maximumValue = self.audioPlayer.duration;
        });
    });
}

#pragma mark - Timer

- (void)createTimer {
    // This way the timer always updates -- even when scrolling.
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(printTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)printTime {
    if ([self.audioPlayer isPlaying]) {
        NSTimeInterval current = self.audioPlayer.currentTime;
        self.slider.value = current;
        NSLog(@"%.0f:%02.0f", floorf(current / 60), fmod(current, 60));
    }
}

@end
