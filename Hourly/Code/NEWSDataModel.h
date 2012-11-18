//
//  NEWSDataModel.h
//  Hourly
//
//  Created by Zach Williams on 11/17/12.
//  Copyright (c) 2012 Zach Williams. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSPersistentStoreCoordinator, NSManagedObjectContext;

@interface NEWSDataModel : NSObject

@property (nonatomic, readonly) NSString *modelName;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSManagedObjectContext *mainContext;

+ (id)sharedModel;
- (NSString *)pathToModel;
- (NSString *)storeFileName;
- (NSURL *)localStoreURL;
- (void)createSharedURLCache;

@end
