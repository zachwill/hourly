//
//  NEWSAPIClient.h
//  Hourly
//
//  Created by Zach Williams on 11/17/12.
//  Copyright (c) 2012 Zach Williams. All rights reserved.
//

#import "AFRESTClient.h"
#import "AFIncrementalStore.h"

@interface NEWSAPIClient : AFRESTClient <AFIncrementalStoreHTTPClient>

+ (id)sharedClient;

@end
