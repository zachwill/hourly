//
//  NEWSCollectionViewController.h
//  Hourly
//
//  Created by Zach Williams on 11/18/12.
//  Copyright (c) 2012 Zach Williams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NEWSCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end
