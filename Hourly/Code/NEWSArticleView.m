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

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = [UIColor lightGrayColor];
    return self;
}

- (void)setArticle:(Article *)article {
    _article = article;
    self.title.text = article.title;
    NSMutableString *summary = [article.abstract mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)(summary), NULL, kCFStringTransformToXMLHex, true);
    self.summary.text = summary;
}

@end
