//
//  DraftViewController.h
//  SummerMovieDraft
//
//  Created by Chris Tot on 6/17/13.
//  Copyright (c) 2013 christurnage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DraftViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) NSString *currLeague;
@property (nonatomic) int currLeagueIndexRow;

@end
