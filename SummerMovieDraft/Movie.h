//
//  Movie.h
//  SummerMovieDraft
//
//  Created by Chris Tot on 6/15/13.
//  Copyright (c) 2013 christurnage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Team;

@interface Movie : NSManagedObject

@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * releaseDate;
@property (nonatomic, retain) NSNumber * wk1Gross;
@property (nonatomic, retain) NSNumber * wk2Gross;
@property (nonatomic, retain) NSNumber * wk3Gross;
@property (nonatomic, retain) NSNumber * wk4Gross;
@property (nonatomic, retain) NSNumber * budget;
@property (nonatomic, retain) Team *movieTeam;
@property (nonatomic, retain) NSSet *moviePercentage;
@end

@interface Movie (CoreDataGeneratedAccessors)

- (void)addMoviePercentageObject:(NSManagedObject *)value;
- (void)removeMoviePercentageObject:(NSManagedObject *)value;
- (void)addMoviePercentage:(NSSet *)values;
- (void)removeMoviePercentage:(NSSet *)values;

@end
