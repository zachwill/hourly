//
//  NEWSInitialViewController.m
//  Hourly
//
//  Created by Zach Williams on 11/15/12.
//  Copyright (c) 2012 Zach Williams. All rights reserved.
//

#import "NEWSAudioViewController.h"
#import <tgmath.h>
#import "NEWSArticlesViewController.h"
#import "NEWSLayout.h"

// ***************************************************************************

@interface NEWSAudioViewController () <AVAudioSessionDelegate>

@property (nonatomic, strong) NSData *audioData;
@property (nonatomic, strong) UIBarButtonItem *pause;

@end

// ***************************************************************************

static NSString * const kNPRAudioURL = @"http://app.npr.org/anon.npr-mp3/npr/news/newscast.mp3";

#define RETURN_IF_NOT_NIL(ivar) \
    do { \
        if (ivar != nil) return ivar; \
    } while(0)

// ***************************************************************************

@implementation NEWSAudioViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    
    NEWSArticlesViewController *newsCollection = [[NEWSArticlesViewController alloc] initWithCollectionViewLayout:[[NEWSLayout alloc] init]];
    newsCollection.collectionView.frame = CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height - 44);
    [self addChildViewController:newsCollection];
    [newsCollection didMoveToParentViewController:self];
    [self.view addSubview:newsCollection.view];
    
    // UIToolbar
    [self addToolbarItems];
    [self.view addSubview:self.toolbar];
    
    // Load the audio data.
    [self updateAudioData];
    [self createTimer];
    
    // Allow for background audio.
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)loadView {
    [super loadView];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - UIToolbar

- (UIToolbar *)toolbar {
    RETURN_IF_NOT_NIL(_toolbar);
    float toolbarHeight = 44;
    CGRect toolbarRect  = CGRectMake(0, self.view.frame.size.height - (toolbarHeight + 44), self.view.frame.size.width, toolbarHeight);
    _toolbar = [[UIToolbar alloc] initWithFrame:toolbarRect];
    return _toolbar;
}

- (void)addToolbarItems {
    UIBarButtonItem *slider = [[UIBarButtonItem alloc] initWithCustomView:self.slider];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbar.items = @[self.play, flexible, slider, flexible, self.refresh];
}

#pragma mark - UIBarButtonItems

- (UIBarButtonItem *)play {
    RETURN_IF_NOT_NIL(_play);
    _play = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playNews)];
    return _play;
}

- (UIBarButtonItem *)pause {
    RETURN_IF_NOT_NIL(_pause);
    _pause = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(playNews)];
    return _pause;
}

- (UISlider *)slider {
    RETURN_IF_NOT_NIL(_slider);
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 210, 40)];
    [_slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    return _slider;
}

- (UIBarButtonItem *)refresh {
    RETURN_IF_NOT_NIL(_refresh);
    _refresh  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(updateAudioData)];
    return _refresh;
}

- (void)sliderChanged:(UISlider *)slider {
    [self.audioPlayer setCurrentTime:slider.value];
}

#pragma mark - AVAudioPlayer

- (AVAudioPlayer *)audioPlayer {
    RETURN_IF_NOT_NIL(_audioPlayer);
    
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithData:self.audioData error:&error];
    _audioPlayer.delegate = self;
    [_audioPlayer prepareToPlay];
    
    if (error) {
        NSLog(@"%@", error);
    }
    
    return _audioPlayer;
}

- (void)playNews {
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer pause];
        toolbarItems[0] = self.play;
    } else {
        [self.audioPlayer play];
        NSTimeInterval duration = self.audioPlayer.duration;
        NSLog(@"%.0f:%02.0f", floorf(duration / 60), fmod(duration, 60));
        toolbarItems[0] = self.pause;
    }
    self.toolbar.items = toolbarItems;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            [self.audioPlayer play];
            break;
        case UIEventSubtypeRemoteControlPause:
            [self.audioPlayer pause];
            break;
        default:
            break;
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    toolbarItems[0] = self.play;
    self.toolbar.items = toolbarItems;
    self.slider.value = 0;
}

#pragma mark - Audio Data

- (void)updateAudioData {
    self.play.enabled = NO;
    self.slider.value = 0;
    
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer pause];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *audio = [NSData dataWithContentsOfURL:[NSURL URLWithString:kNPRAudioURL]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.audioData = audio;
            self.play.enabled  = YES;
            self.slider.value = 0;
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
