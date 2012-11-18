//
//  NEWSIncrementalStore.m
//  Hourly
//
//  Created by Zach Williams on 11/17/12.
//  Copyright (c) 2012 Zach Williams. All rights reserved.
//

#import "NEWSIncrementalStore.h"
#import "NEWSAPIClient.h"
#import "NEWSDataModel.h"

@implementation NEWSIncrementalStore

+ (void)initialize {
    [NSPersistentStoreCoordinator registerStoreClass:self forStoreType:[self type]];
}

+ (NSString *)type {
    return NSStringFromClass(self);
}

- (NSManagedObjectModel *)model {
    NSURL *dataModelURL = [[NSBundle mainBundle] URLForResource:[[NEWSDataModel sharedModel] modelName]
                                                  withExtension:@"xcdatamodeld"];
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:dataModelURL];
}

- (id<AFIncrementalStoreHTTPClient>)HTTPClient {
    return [NEWSAPIClient sharedClient];
}
@end
