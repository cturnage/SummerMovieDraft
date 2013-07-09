//
//  DraftViewController.m
//  SummerMovieDraft
//
//  Created by Chris Tot on 6/17/13.
//  Copyright (c) 2013 christurnage. All rights reserved.
//

#import "DraftViewController.h"
#import "AppDelegate.h"
#import "MovieInfo.h"
#import "League.h"
#import "Team.h"
#import "Movie.h"
#import "Percentage.h"
#import <QuartzCore/QuartzCore.h>

@interface DraftViewController ()
{
    bool draftingUp;
    bool snakeAgain;
    bool extraTurn;
    
    bool allowanceOn;
    int allowance;
    
    bool endDraft;
}

@property AppDelegate *appD;
@property (strong, nonatomic) NSArray *arrLeagues;
@property (strong, nonatomic) NSArray *arrTeams;
@property (nonatomic, strong) NSMutableArray *arrDraftOrder;

@property (strong, nonatomic) NSMutableArray *availableMovies;
@property (weak, nonatomic) IBOutlet UIPickerView *pkrMovieList;
@property (weak, nonatomic) IBOutlet UIButton *btnPickMovie;
@property (weak, nonatomic) IBOutlet UILabel *lblBudget;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrDrafter;
@property (weak, nonatomic) IBOutlet UILabel *lblNextDrafter;
@property (weak, nonatomic) IBOutlet UILabel *lblDraftComplete;

@property (nonatomic) int currDrafter;

- (IBAction)showPicks:(id)sender;
- (IBAction)pickMovie:(id)sender;


@end

@implementation DraftViewController
@synthesize appD, currLeague, currLeagueIndexRow, arrLeagues, arrTeams, arrDraftOrder, currDrafter;
@synthesize availableMovies, pkrMovieList, lblBudget, lblCurrDrafter, lblNextDrafter;
@synthesize btnPickMovie, lblDraftComplete;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //**************************
    // Set the button Text Color
    [self.btnPickMovie setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnPickMovie setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [[self.btnPickMovie titleLabel] setFont:[UIFont fontWithName:@"Knewave" size:18.0f]];
    // Draw a custom gradient
    // Set the button Background Color
    //[self.btnCancel setBackgroundColor:[UIColor blackColor]];
    // Draw a custom gradient
    CAGradientLayer *btnGradient = [CAGradientLayer layer];
    btnGradient.frame = self.btnPickMovie.bounds;
    btnGradient.colors = [NSArray arrayWithObjects:
                          (id)[[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] CGColor],
                          (id)[[UIColor colorWithRed:51.0f / 255.0f green:51.0f / 255.0f blue:51.0f / 255.0f alpha:1.0f] CGColor],
                          nil];
    [self.btnPickMovie.layer insertSublayer:btnGradient atIndex:0];
    
    // Round button corners
    CALayer *btnLayer = [self.btnPickMovie layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    
    // Apply a 1 pixel, black border
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor blackColor] CGColor]];
    
    UIAlertView *myAlert = [[UIAlertView alloc]
                            initWithTitle:@""
                            message:@"After the first player has taken his turn, stay on this page until the draft is complete. Going back will end the draft. Have fun!"
                            delegate:self
                            cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [myAlert show];

    
    //NSLog(@"Current League: %@", currLeague);
    //NSLog(@"League Num: %d", currLeagueIndexRow);
    
    draftingUp = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    //sets up draft list
    [self createDraftList];
    
    //Get the reference to the application to access the DB (uses appdelegate.h)
    appD = [[UIApplication sharedApplication] delegate];
    
    //Access to the data through the reference of the application
    NSManagedObjectContext *context = [appD managedObjectContext];
    
    //fetch teams
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"League" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSError *error;
    
    arrLeagues = [context executeFetchRequest:fetchRequest error:&error];
    arrTeams = [[[arrLeagues objectAtIndex:currLeagueIndexRow] leagueTeam] allObjects];
    
    arrDraftOrder = [arrTeams mutableCopy];
    
    //shuffle players
    for (int i = 0; i < 7; i++)
    {
        [self setDraftOrder];
    }
    
    //NSLog(@"Leagues Count: %d", [arrLeagues count]);
    //NSLog(@"Teams Count: %d", [arrTeams count]);
    //NSLog(@"Draft Order Count: %d", [arrDraftOrder count]);
    
    //start draft at first position
    currDrafter = 0;
    
    //show first drafter and currency, show next drafter
    lblCurrDrafter.text = [[arrDraftOrder objectAtIndex:currDrafter] name];
    lblBudget.text = [[NSString alloc] initWithFormat:@"%@",[[arrDraftOrder objectAtIndex:currDrafter] teamBudget]];
    lblNextDrafter.text = [[arrDraftOrder objectAtIndex:currDrafter+1] name];
}

- (void)createDraftList
{
    availableMovies = [[NSMutableArray alloc] init];
    
    //Get the reference to the application to access the DB (uses appdelegate.h)
    appD = [[UIApplication sharedApplication] delegate];
    
    [appD networkCheck];
    
    //NSLog(@"Reachability: %d", appD.isConnected);
    
    //get path of json file
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"movies" ofType:@"json"];
    
    //store json file contents as string
    NSString *myJsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    //parse the string into json
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[myJsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    
    NSArray *items = [json valueForKeyPath:@"movies"];
    
    NSEnumerator *enumerator = [items objectEnumerator];
    NSDictionary *item;
    
    //set movie values
    while (item = (NSDictionary*)[enumerator nextObject])
    {
        MovieInfo *newMovie = [[MovieInfo alloc] init];
        
        newMovie.strTitle = [item objectForKey:@"title"];
        newMovie.budget = [[item objectForKey:@"budget"] intValue];
        newMovie.strReleaseDate = [item objectForKey:@"Release Date:"];
        
        [availableMovies addObject:newMovie];
    }
}

- (void)setDraftOrder
{
    NSUInteger count = [arrDraftOrder count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = (arc4random() % nElements) + i;
        [arrDraftOrder exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch(component) {
        case 0: return 250;
        case 1: return 44;
        default: return 22;
    }
    
    //NOT REACHED
    return 22;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component==0)
    {
        return [availableMovies count];
    }
    else
    {
        return [[[availableMovies objectAtIndex:[pkrMovieList selectedRowInComponent:0]] arrPercentages] count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component==0)
    {
        return [[availableMovies objectAtIndex:row] strTitle];
    }
    else
    {
        return [[[availableMovies objectAtIndex:[pkrMovieList selectedRowInComponent:0]] arrPercentages] objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [pkrMovieList reloadAllComponents];
    
    if (component == 0)
    {
        [pkrMovieList selectRow:0 inComponent:1 animated:YES];
    }
}

- (IBAction)pickMovie:(id)sender
{
    //NSLog(@"Clicked Pick Movie");
    
    if (!draftingUp)
    {
        //do logic with current player
        [self addPickToDrafter];
        
        //next player logic
        int playerPos = 0;
        currDrafter--;
        if(extraTurn)
        {
            currDrafter++;
            extraTurn = NO;
            
            //repeat last drafter if just 1 left
            if ([arrDraftOrder count] == 1)
            {
                extraTurn = YES;
            }
        }
        
        //NSLog(@"Current Drafter: %d", currDrafter);
        
        if (currDrafter == playerPos)
        {
            lblCurrDrafter.text = [[arrDraftOrder objectAtIndex:currDrafter] name];
            lblNextDrafter.text = [[arrDraftOrder objectAtIndex:currDrafter] name];
            lblBudget.text = [[NSString alloc] initWithFormat:@"%@", [[arrDraftOrder objectAtIndex:currDrafter] teamBudget]];
            //NSLog(@"First Drafter")
            
            snakeAgain = YES;
            extraTurn = YES;
        }
        else
        {
            int nextDrafter = currDrafter-1;
            lblCurrDrafter.text = [[arrDraftOrder objectAtIndex:currDrafter] name];
            lblNextDrafter.text = [[arrDraftOrder objectAtIndex:nextDrafter] name];
            lblBudget.text = [[NSString alloc] initWithFormat:@"%@", [[arrDraftOrder objectAtIndex:currDrafter] teamBudget]];
            
            snakeAgain = NO;
            extraTurn = NO;
        }
    }
    
    if (draftingUp)
    {
        //do logic with current player
        [self addPickToDrafter];
        
        //next player logic
        int playerPos = [arrDraftOrder count] -1;
        currDrafter++;
        if(extraTurn)
        {
            currDrafter--;
            extraTurn = NO;
            
            //repeat last drafter if just 1 left
            if ([arrDraftOrder count] == 1)
            {
                extraTurn = YES;
            }
        }
        
        //NSLog(@"Current Drafter: %d", currDrafter);
        
        if (currDrafter == playerPos)
        {
            lblCurrDrafter.text = [[arrDraftOrder objectAtIndex:currDrafter] name];
            lblNextDrafter.text = [[arrDraftOrder objectAtIndex:currDrafter] name];
            lblBudget.text = [[NSString alloc] initWithFormat:@"%@", [[arrDraftOrder objectAtIndex:currDrafter] teamBudget]];
            //NSLog(@"Last Drafter");
            
            draftingUp = NO;
            extraTurn = YES;
        }
        else
        {
            int nextDrafter = currDrafter+1;
            lblCurrDrafter.text = [[arrDraftOrder objectAtIndex:currDrafter] name];
            lblNextDrafter.text = [[arrDraftOrder objectAtIndex:nextDrafter] name];
            lblBudget.text = [[NSString alloc] initWithFormat:@"%@", [[arrDraftOrder objectAtIndex:currDrafter] teamBudget]];
            
            extraTurn = NO;
        }
    }
    
    if (snakeAgain)
    {
        draftingUp = YES;
        snakeAgain = NO;
    }
    
    //removes current movie percentage
    [[[availableMovies objectAtIndex:[pkrMovieList selectedRowInComponent:0]] arrPercentages] removeObjectAtIndex:[pkrMovieList selectedRowInComponent:1]];
    
    //removes movie if no percentages
    if ([[[availableMovies objectAtIndex:[pkrMovieList selectedRowInComponent:0]] arrPercentages] count] < 1)
    {
        [availableMovies removeObjectAtIndex:[pkrMovieList selectedRowInComponent:0]];
    }
    
    [pkrMovieList reloadAllComponents];
    
    if (endDraft)
    {
        btnPickMovie.hidden = YES;
        lblCurrDrafter.text = @"";
        lblNextDrafter.text = @"";
        lblBudget.text = @"0";
        lblDraftComplete.hidden = NO;
    }
}

- (void)addPickToDrafter
{
    //NSLog(@"%@", lblCurrDrafter.text);
    
    //Get the reference to the application to access the DB (uses appdelegate.h)
    appD = [[UIApplication sharedApplication] delegate];
    
    //Access to the data through the reference of the application
    NSManagedObjectContext *context = [appD managedObjectContext];
    
    //used to check if team exists already
    //************************************
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *fetchEntity = [NSEntityDescription entityForName:@"Team" inManagedObjectContext:context];
    NSError *error;
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"(name = %@)",lblCurrDrafter.text];
    
    [request setEntity:fetchEntity];
    [request setPredicate:namePredicate];
    
    //NSManagedObject *matches = nil;
    NSArray *objects = [context executeFetchRequest:request error:&error];

    //if player is found
    if ([objects count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hmm." message:@"Your team does not exist." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        //cycle through players and find player that is in current league
        for (int i = 0; i < [objects count]; i++)
        {
            Team *playerInfo = [objects objectAtIndex:i];
            //NSLog(@"Player Name: %@", playerInfo.name);
            
            if ([playerInfo.teamLeague.name isEqualToString:currLeague])
            {
                bool ownsMovie;
                ownsMovie = NO;
                
                //check to see if movie already exists in team -- curr iETS selected
                for (int e = 0; e < [playerInfo.movieCount intValue];e++)
                {
                    if ([[[[[playerInfo teamMovie] allObjects] objectAtIndex:e] title] isEqualToString:[[availableMovies objectAtIndex:[pkrMovieList selectedRowInComponent:0]] strTitle]])
                    {
                        //NSLog(@"Current: %@", [[[[playerInfo teamMovie] allObjects] objectAtIndex:e] title]);
                        //NSLog(@"Selected: %@", [[availableMovies objectAtIndex:[pkrMovieList selectedRowInComponent:0]] strTitle]);
                        
                        Movie *specificMovie = [[[playerInfo teamMovie] allObjects] objectAtIndex:e];
                        
                        //deduct percentage from team budget
                        if ([specificMovie.movieTeam.teamBudget intValue] < [[[[availableMovies objectAtIndex:[pkrMovieList selectedRowInComponent:0]] arrPercentages] objectAtIndex:[pkrMovieList selectedRowInComponent:1]] intValue])
                        {
                            allowanceOn = YES;
                            allowance = [specificMovie.movieTeam.teamBudget intValue];
                        }
                        
                        int specificBudget = [specificMovie.movieTeam.teamBudget intValue] - [[[[availableMovies objectAtIndex:[pkrMovieList selectedRowInComponent:0]] arrPercentages] objectAtIndex:[pkrMovieList selectedRowInComponent:1]] intValue];
                        //NSLog(@"old: %d", [specificMovie.movieTeam.teamBudget intValue]);
                        //NSLog(@"selected: %d", [[[[availableMovies objectAtIndex:[pkrMovieList selectedRowInComponent:0]] arrPercentages] objectAtIndex:[pkrMovieList selectedRowInComponent:1]] intValue]);
                        //NSLog(@"New Budget: %d", specificBudget);
                        
                        specificMovie.movieTeam.teamBudget = [NSNumber numberWithInt:specificBudget];
                        
                        //check to end draft
                        if ([specificMovie.movieTeam.teamBudget intValue] <= 0)
                        {
                            if ([arrDraftOrder count] > 1)
                            {
                                [arrDraftOrder removeObjectAtIndex:currDrafter];
                            }
                            else
                            {
                                endDraft = YES;
                            }
                        }
                        
                        //update team's movie count
                        int tempMovieCount = [playerInfo.teamMovie count];
                        playerInfo.movieCount = [NSNumber numberWithInt:tempMovieCount];
                        
                        //add new percentage to movie
                        Percentage *percentInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Percentage" inManagedObjectContext:context];
                    
                        [specificMovie addMoviePercentageObject:percentInfo];
                        
                        
                        
                        
                        if (allowanceOn)
                        {
                            percentInfo.value = [NSNumber numberWithInt:allowance];
                        }
                        else
                        {
                            percentInfo.value = [NSNumber numberWithInt:[[[[availableMovies objectAtIndex:[pkrMovieList selectedRowInComponent:0]] arrPercentages] objectAtIndex:[pkrMovieList selectedRowInComponent:1]] intValue]];
                        }
                        
                        percentInfo.percentageMovie.title = [[availableMovies objectAtIndex:[pkrMovieList selectedRowInComponent:0]] strTitle];
                        //NSLog(@"Percentage Count: %d", specificMovie.moviePercentage.allObjects.count);
                        
                        ownsMovie = YES;
                    }
                }
                
                //add movie to player if it hasn't been added yet
                if (!ownsMovie)
                {
                    //add movie to player
                    Movie *movieInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:context];
                    
                    //NSLog(@"Hasn't been picked yet");
                    
                    [playerInfo addTeamMovieObject:movieInfo];
                
                    //NSLog(@"Movie Title: %@", [[availableMovies objectAtIndex:[pkrMovieList selectedRowInComponent:0]] strTitle]);
                    movieInfo.title = [[availableMovies objectAtIndex:[pkrMovieList selectedRowInComponent:0]] strTitle];
                    movieInfo.movieTeam.name = playerInfo.name;
                    
                    //deduct percentage from team budget
                    
                    if ([movieInfo.movieTeam.teamBudget intValue] < [[[[availableMovies objectAtIndex:[pkrMovieList selectedRowInComponent:0]] arrPercentages] objectAtIndex:[pkrMovieList selectedRowInComponent:1]] intValue])
                    {
                        allowanceOn = YES;
                        allowance = [movieInfo.movieTeam.teamBudget intValue];
                    }

                    int newBudget = [movieInfo.movieTeam.teamBudget intValue] - [[[[availableMovies objectAtIndex:[pkrMovieList selectedRowInComponent:0]] arrPercentages] objectAtIndex:[pkrMovieList selectedRowInComponent:1]] intValue];
                    //NSLog(@"old: %d", [movieInfo.movieTeam.teamBudget intValue]);
                    //NSLog(@"selected: %d", [[[[availableMovies objectAtIndex:[pkrMovieList selectedRowInComponent:0]] arrPercentages] objectAtIndex:[pkrMovieList selectedRowInComponent:1]] intValue]);
                    //NSLog(@"New Budget: %d", newBudget);
                    
                    movieInfo.movieTeam.teamBudget = [NSNumber numberWithInt:newBudget];
                    
                    //check to end draft
                    if ([movieInfo.movieTeam.teamBudget intValue] <= 0)
                    {
                        if ([arrDraftOrder count] > 1)
                        {
                            [arrDraftOrder removeObjectAtIndex:currDrafter];
                        }
                        else
                        {
                            endDraft = YES;
                        }
                    }
                
                    //update team's movie count
                    int tempMovieCount = [playerInfo.teamMovie count];
                    movieInfo.movieTeam.movieCount = [NSNumber numberWithInt:tempMovieCount];
                    
                    //add new percentage to movie
                    Percentage *percentInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Percentage" inManagedObjectContext:context];
                    
                    [movieInfo addMoviePercentageObject:percentInfo];
                    
                    if (allowanceOn)
                    {
                        percentInfo.value = [NSNumber numberWithInt:allowance];
                    }
                    else
                    {
                        percentInfo.value = [NSNumber numberWithInt:[[[[availableMovies objectAtIndex:[pkrMovieList selectedRowInComponent:0]] arrPercentages] objectAtIndex:[pkrMovieList selectedRowInComponent:1]] intValue]];
                    }
                    
                    percentInfo.percentageMovie.title = [[availableMovies objectAtIndex:[pkrMovieList selectedRowInComponent:0]] strTitle];
                    //NSLog(@"Percentage Count: %d", movieInfo.moviePercentage.allObjects.count);
                }
                    
                //assign this to percentage
                //movieInfo.title = [[[availableMovies objectAtIndex:[pkrMovieList selectedRowInComponent:0]] arrPercentages] objectAtIndex:[pkrMovieList selectedRowInComponent:1]];
                
                //try for error
                if (![context save:&error])
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save failed" message:[NSString stringWithFormat:@"Save core data failed %@", [error localizedDescription]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
            }
        }
    }
}

- (IBAction)showPicks:(id)sender
{
    //NSLog(@"Clicked My Draft Picks");
    
    for (int i = 0; i < [arrDraftOrder count]; i++)
    {
        //NSLog(@"Drafter: %@ -- Position: %d", [[arrDraftOrder objectAtIndex:i] name], i);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
