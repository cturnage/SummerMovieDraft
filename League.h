//
//  League.h
//  SummerMovieDraft
//
//  Created by Chris Tot on 6/16/13.
//  Copyright (c) 2013 christurnage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Team;

@interface League : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * teamCount;
@property (nonatomic, retain) NSSet *leagueTeam;
@end

@interface League (CoreDataGeneratedAccessors)

- (void)addLeagueTeamObject:(Team *)value;
- (void)removeLeagueTeamObject:(Team *)value;
- (void)addLeagueTeam:(NSSet *)values;
- (void)removeLeagueTeam:(NSSet *)values;

@end
