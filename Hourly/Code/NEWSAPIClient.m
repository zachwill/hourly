//
//  NEWSAPIClient.m
//  Hourly
//
//  Created by Zach Williams on 11/17/12.
//  Copyright (c) 2012 Zach Williams. All rights reserved.
//

#import "NEWSAPIClient.h"

// ***************************************************************************

static NSString * const kNEWSBaseURL = @"http://api.nytimes.com/svc/mostpopular/v2/";
static NSString * const kAPIKey = @"7d6bd012e70ea6dd05a4aae78a58cba8:12:66944183";

static NSString * NEWSRemoveNewlinesFromContent(NSString *title) {
    NSArray *components = [title componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
    return [components componentsJoinedByString:@" "];
}

static NSDate * NEWSDateFormatter(NSString *dateString) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter dateFromString:dateString];
}

// Score based on Hacker News algorithm.
static float HNScore(NSDate *date, NSNumber *score) {
    NSTimeInterval hours = abs([date timeIntervalSinceNow]) / 3600;
    // Use 1.25 rather than 1.8 for gravity.
    return ([score floatValue] / pow(hours, 1.25));
}

// ***************************************************************************

@implementation NEWSAPIClient

+ (id)sharedClient {
    static NEWSAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[NEWSAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kNEWSBaseURL]];
    });
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    return self;
}

- (id)representationOrArrayOfRepresentationsFromResponseObject:(id)responseObject {
    responseObject = [super representationOrArrayOfRepresentationsFromResponseObject:responseObject];
    NSArray *results = [responseObject objectForKey:@"results"];
    if ([responseObject isKindOfClass:[NSDictionary class]] && results.count > 0) {
        return results;
    }
    return responseObject;
}

- (NSURLRequest *)requestForFetchRequest:(NSFetchRequest *)fetchRequest
                             withContext:(NSManagedObjectContext *)context
{
    NSMutableURLRequest *mutableRequest = nil;
    if ([fetchRequest.entityName isEqualToString:@"Article"]) {
        mutableRequest = [self requestWithMethod:@"GET" path:@"mostshared/all-sections/twitter/1.json" parameters:@{@"api-key":kAPIKey}];
    }
    return mutableRequest;
}

- (NSDictionary *)attributesForRepresentation:(NSDictionary *)representation
                                     ofEntity:(NSEntityDescription *)entity
                                 fromResponse:(NSHTTPURLResponse *)response
{
    NSMutableDictionary *mutableProperties = [[super attributesForRepresentation:representation
                                                                        ofEntity:entity
                                                                    fromResponse:response] mutableCopy];
    if ([entity.name isEqualToString:@"Article"]) {
        mutableProperties[@"shares"] = representation[@"total_shares"];
        mutableProperties[@"title"] = NEWSRemoveNewlinesFromContent(representation[@"title"]);
        mutableProperties[@"abstract"] = NEWSRemoveNewlinesFromContent(representation[@"abstract"]);
        NSDate *published = NEWSDateFormatter(representation[@"published_date"]);
        mutableProperties[@"published"] = published;
        // Calculate the score... shares / (hours * 1.8)
        mutableProperties[@"score"] = @(HNScore(published, mutableProperties[@"shares"]));
    }
    return mutableProperties;
}

- (NSString *)resourceIdentifierForRepresentation:(NSDictionary *)representation
                                         ofEntity:(NSEntityDescription *)entity
                                     fromResponse:(NSHTTPURLResponse *)response
{
    return representation[@"url"];
}

- (BOOL)shouldFetchRemoteAttributeValuesForObjectWithID:(NSManagedObjectID *)objectID
                                 inManagedObjectContext:(NSManagedObjectContext *)context
{
    return NO;
}

- (BOOL)shouldFetchRemoteValuesForRelationship:(NSRelationshipDescription *)relationship
                               forObjectWithID:(NSManagedObjectID *)objectID
                        inManagedObjectContext:(NSManagedObjectContext *)context
{
    return NO;
}

@end
