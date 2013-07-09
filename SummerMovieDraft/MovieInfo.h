//
//  MovieInfo.h
//  SummerMovieDraft
//
//  Created by Chris Tot on 6/19/13.
//  Copyright (c) 2013 christurnage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieInfo : NSObject

@property (strong, nonatomic) NSString *strTitle;
@property (strong, nonatomic) NSString *strReleaseDate;
@property (strong, nonatomic) NSString *strImdb;
@property (strong, nonatomic) NSString *strUrl;
@property (nonatomic) int budget;
@property (nonatomic) int gross;
@property (strong, nonatomic) NSMutableArray *arrPercentages;

@end
