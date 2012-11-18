//
//  NEWSArticleView.h
//  Hourly
//
//  Created by Zach Williams on 11/18/12.
//  Copyright (c) 2012 Zach Williams. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Article;

@interface NEWSArticleView : UICollectionViewCell

@property (nonatomic, strong) Article *article;
@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *summary;

@end
