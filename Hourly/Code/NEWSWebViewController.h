//
//  NEWSWebViewController.h
//  Hourly
//
//  Created by Zach Williams on 11/20/12.
//  Copyright (c) 2012 Zach Williams. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Article;

@interface NEWSWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) Article *article;

- (id)initWithArticle:(Article *)article;

@end
