//
//  NEWSCollectionViewController.m
//  Hourly
//
//  Created by Zach Williams on 11/18/12.
//  Copyright (c) 2012 Zach Williams. All rights reserved.
//

#import "NEWSArticlesViewController.h"
#import "NEWSDataModel.h"
#import "NEWSArticleView.h"
#import "Article.h"
#import "NEWSWebViewController.h"

// ***************************************************************************

@interface NEWSArticlesViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

// ***************************************************************************

@implementation NEWSArticlesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *articleNib = [UINib nibWithNibName:@"NEWSArticleView" bundle:nil];
    [self.collectionView registerNib:articleNib forCellWithReuseIdentifier:@"Article"];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.showsVerticalScrollIndicator = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView addSubview:self.refreshControl];
    [self refetchData];
}

#pragma mark - UIRefreshControl

- (UIRefreshControl *)refreshControl {
    if (_refreshControl != nil) {
        return _refreshControl;
    }
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refetchData) forControlEvents:UIControlEventValueChanged];
    return _refreshControl;
}

#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Article"];
    NSManagedObjectContext *context = [[NEWSDataModel sharedModel] mainContext];
    fetchRequest.fetchLimit = 20;
    fetchRequest.returnsObjectsAsFaults = NO;
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"shares" ascending:NO]];
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:context
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:@"News"];
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.collectionView reloadData];
}

- (void)refetchData {
    [self.fetchedResultsController performSelectorOnMainThread:@selector(performFetch:)
                                                    withObject:nil
                                                 waitUntilDone:YES
                                                         modes:@[NSRunLoopCommonModes]];
    if ([self.refreshControl isRefreshing]) {
        [self.refreshControl endRefreshing];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self.fetchedResultsController.sections objectAtIndex:section] numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NEWSArticleView *articleView = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"Article" forIndexPath:indexPath];
    articleView.article = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSLog(@"%@", articleView.article.score);
    return articleView;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Article *article = [self.fetchedResultsController objectAtIndexPath:indexPath];
    CGSize constraint = CGSizeMake(280, MAXFLOAT);
    CGSize summary = [article.abstract sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:constraint];
    CGSize title = [article.title sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:constraint];
    return CGSizeMake(300, title.height + summary.height + 22);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Article *article = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NEWSWebViewController *webVC = [[NEWSWebViewController alloc] initWithArticle:article];
    [self.navigationController pushViewController:webVC animated:YES];
}

@end
