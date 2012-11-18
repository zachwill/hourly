//
//  Article.h
//  Hourly
//
//  Created by Zach Williams on 11/18/12.
//  Copyright (c) 2012 Zach Williams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Article : NSManagedObject

@property (nonatomic, retain) NSString * abstract;
@property (nonatomic, retain) NSString * byline;
@property (nonatomic, retain) NSString * published;
@property (nonatomic, retain) NSString * section;
@property (nonatomic, retain) NSNumber * shares;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;

@end
