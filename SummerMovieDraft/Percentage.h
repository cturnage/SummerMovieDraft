//
//  Percentage.h
//  SummerMovieDraft
//
//  Created by Chris Tot on 6/15/13.
//  Copyright (c) 2013 christurnage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movie;

@interface Percentage : NSManagedObject

@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) Movie *percentageMovie;

@end
