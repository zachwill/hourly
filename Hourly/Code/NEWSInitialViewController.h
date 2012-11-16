//
//  NEWSInitialViewController.h
//  Hourly
//
//  Created by Zach Williams on 11/15/12.
//  Copyright (c) 2012 Zach Williams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface NEWSInitialViewController : UIViewController <AVAudioPlayerDelegate>

@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) UIBarButtonItem *playButton;

@end