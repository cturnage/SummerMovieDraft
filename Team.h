//
//  Team.h
//  SummerMovieDraft
//
//  Created by Chris Tot on 6/20/13.
//  Copyright (c) 2013 christurnage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class League, Movie;

@interface Team : NSManagedObject

@property (nonatomic, retain) NSNumber * movieCount;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * teamBudget;
@property (nonatomic, retain) League *teamLeague;
@property (nonatomic, retain) NSSet *teamMovie;
@end

@interface Team (CoreDataGeneratedAccessors)

- (void)addTeamMovieObject:(Movie *)value;
- (void)removeTeamMovieObject:(Movie *)value;
- (void)addTeamMovie:(NSSet *)values;
- (void)removeTeamMovie:(NSSet *)values;

@end
