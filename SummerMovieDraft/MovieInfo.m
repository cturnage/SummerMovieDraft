//
//  MovieInfo.m
//  SummerMovieDraft
//
//  Created by Chris Tot on 6/19/13.
//  Copyright (c) 2013 christurnage. All rights reserved.
//

#import "MovieInfo.h"

@implementation MovieInfo
@synthesize strTitle, strReleaseDate, strImdb, strUrl, budget, gross, arrPercentages;

-(id)init
{
    self = [super init];
    if (self) {
        strTitle = [[NSString alloc] init];
        strReleaseDate = [[NSString alloc] init];
        strImdb = [[NSString alloc] init];
        strUrl = [[NSString alloc] init];
        arrPercentages = [[NSMutableArray alloc] initWithObjects:@"40", @"30", @"20", @"10", nil];
    }
    return self;
}

@end
