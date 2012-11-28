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
#import "GRMustache.h"

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
    [self loadGRMustacheHTML];
    [self.view addSubview:self.webView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Who doesn't like sharing articles, right?
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareArticle:)];
    
    // Swipe to go back
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.webView.scrollView addGestureRecognizer:swipe];
}

- (void)loadGRMustacheHTML {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:self.articleRequest];
        [operation setSuccessCallbackQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"</?body[^>]*>(.*)</body>" options:NSRegularExpressionDotMatchesLineSeparators error:nil];
            [regex enumerateMatchesInString:html options:NSRegularExpressionDotMatchesLineSeparators range:NSMakeRange(0, html.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                if (result != nil && result.numberOfRanges > 1) {
                    NSString *innerHTML = [html substringWithRange:[result rangeAtIndex:1]];
                    NSString *render = [GRMustacheTemplate renderObject:@{@"body": innerHTML} fromResource:@"html" bundle:nil error:nil];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.webView loadHTMLString:render baseURL:[NSURL URLWithString:@"http://httpbin.org"]];
                    });
                }
            }];
        } failure:nil];
        [operation start];
    });
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
    [webView.scrollView setContentSize: CGSizeMake(webView.frame.size.width, webView.scrollView.contentSize.height)];
}

#pragma mark - NSURLRequest

- (NSURLRequest *)articleRequest {
    if (_articleRequest != nil) {
        return _articleRequest;
    }
    
    NSURL *nytimes  = [NSURL URLWithString:[NSString stringWithFormat:@"%@?pagewanted=print", self.article.url]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nytimes];
    [request setValue:@"http://nytimes.com/" forHTTPHeaderField:@"Referer"];
    _articleRequest = request;
    return _articleRequest;
}

#pragma mark - UIGestureRecognizers

- (void)swiped:(UISwipeGestureRecognizer *)swipe {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIActionSheet

- (void)shareArticle:(id)sender {
    NSURL *articleURL = [NSURL URLWithString:self.article.url];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[articleURL] applicationActivities:nil];
    activityVC.excludedActivityTypes = @[
        UIActivityTypeAssignToContact,
        UIActivityTypeCopyToPasteboard,
        UIActivityTypePostToFacebook,
        UIActivityTypePostToWeibo,
        UIActivityTypePrint
    ];
    [self presentViewController:activityVC animated:YES completion:nil];
}

@end
