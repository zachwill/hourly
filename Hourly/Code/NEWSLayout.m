//
//  NEWSLayout.m
//  Hourly
//
//  Created by Zach Williams on 11/18/12.
//  Copyright (c) 2012 Zach Williams. All rights reserved.
//

#import "NEWSLayout.h"

@implementation NEWSLayout

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.itemSize = CGSizeMake(300, 50);
    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    return self;
}

@end
