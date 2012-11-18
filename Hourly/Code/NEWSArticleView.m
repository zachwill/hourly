//
//  NEWSArticleView.m
//  Hourly
//
//  Created by Zach Williams on 11/18/12.
//  Copyright (c) 2012 Zach Williams. All rights reserved.
//

#import "NEWSArticleView.h"
#import "Article.h"

@implementation NEWSArticleView

- (void)setArticle:(Article *)article {
    _article = article;
    self.title.text = article.title;
    self.summary.text = article.abstract;
}

@end
