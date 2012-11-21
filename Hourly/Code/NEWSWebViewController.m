//
//  NEWSWebViewController.m
//  Hourly
//
//  Created by Zach Williams on 11/20/12.
//  Copyright (c) 2012 Zach Williams. All rights reserved.
//

#import "NEWSWebViewController.h"
#import "Article.h"
#import "AFNetworking.h"

@interface NEWSWebViewController ()
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURLRequest *articleRequest;
@end

@implementation NEWSWebViewController

- (id)initWithArticle:(Article *)article {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.article = article;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, -10, self.view.frame.size.width, self.view.frame.size.height - 34)];
    self.webView.delegate = self;
    [self.webView loadRequest:self.articleRequest];
    self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    [self.view addSubview:self.webView];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeOther || navigationType == UIWebViewNavigationTypeLinkClicked) {
        return YES;
    }
    NSLog(@"%@", request);
    return NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSLog(@"%d cookies", cookies.count);
    for (NSHTTPCookie *cookie in cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

#pragma mark - NSURLRequest

- (NSURLRequest *)articleRequest {
    if (_articleRequest != nil) {
        return _articleRequest;
    }
    
    NSURL *nytimes  = [NSURL URLWithString:[NSString stringWithFormat:@"%@?pagewanted=print", self.article.url]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nytimes];
    [request setValue:self.article.url forHTTPHeaderField:@"Referer"];
    _articleRequest = request;
    return _articleRequest;
}

@end
