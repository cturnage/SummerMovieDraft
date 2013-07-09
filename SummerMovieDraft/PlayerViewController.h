//
//  PlayerViewController.h
//  SummerMovieDraft
//
//  Created by Chris Tot on 6/16/13.
//  Copyright (c) 2013 christurnage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSString *currLeague;
@property (nonatomic) int currLeagueIndexRow;

@end
