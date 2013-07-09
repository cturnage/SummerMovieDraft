//
//  PlayerViewController.m
//  SummerMovieDraft
//
//  Created by Chris Tot on 6/16/13.
//  Copyright (c) 2013 christurnage. All rights reserved.
//

#import "PlayerViewController.h"
#import "AppDelegate.h"
#import "League.h"
#import "Team.h"
#import "Movie.h"
#import "Percentage.h"
#import <QuartzCore/QuartzCore.h>

@interface PlayerViewController ()

//Team Objects
@property (strong, nonatomic) NSArray *arrLeagues;
@property (strong, nonatomic) NSArray *arrTeams;
@property (weak, nonatomic) IBOutlet UITableView *tblTeams;
@property (weak, nonatomic) IBOutlet UIButton *btnStartDraft;
@property (weak, nonatomic) IBOutlet UIButton *btnViewResults;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnAddPlayers;

- (IBAction)showAddTeamContainer:(id)sender;

//Add Team Objects
@property (weak, nonatomic) IBOutlet UIView *addTeamContainer;
@property (weak, nonatomic) IBOutlet UITextField *txtAddedTeam;
@property (nonatomic) BOOL playerFound;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

- (IBAction)submitTeam:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)clickedOutsideTextField:(id)sender;

@end

@implementation PlayerViewController
@synthesize arrLeagues, arrTeams, tblTeams, currLeague, currLeagueIndexRow;
@synthesize addTeamContainer, txtAddedTeam, playerFound;

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
    
    [self customizeButtons];
    
    //initialize leagues
    arrTeams = [[NSArray alloc] init];
    
    //set keyboard capitalization
    txtAddedTeam.autocapitalizationType = UITextAutocapitalizationTypeWords;
}

- (void)customizeButtons
{
    //self.btnCancel;
    //self.btnSubmit;
    //self.btnStartDraft;
    //self.btnViewResults;
    
    //**************************
    // Set the button Text Color
    [self.btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnCancel setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [[self.btnCancel titleLabel] setFont:[UIFont fontWithName:@"Knewave" size:18.0f]];
    // Draw a custom gradient
    // Set the button Background Color
    //[self.btnCancel setBackgroundColor:[UIColor blackColor]];
    // Draw a custom gradient
    CAGradientLayer *btnGradient = [CAGradientLayer layer];
    btnGradient.frame = self.btnCancel.bounds;
    btnGradient.colors = [NSArray arrayWithObjects:
                          (id)[[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] CGColor],
                          (id)[[UIColor colorWithRed:51.0f / 255.0f green:51.0f / 255.0f blue:51.0f / 255.0f alpha:1.0f] CGColor],
                          nil];
    [self.btnCancel.layer insertSublayer:btnGradient atIndex:0];
    
    // Round button corners
    CALayer *btnLayer = [self.btnCancel layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    
    // Apply a 1 pixel, black border
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor blackColor] CGColor]];
    
    //**************************
    // Set the button Text Color
    [self.btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSubmit setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [[self.btnSubmit titleLabel] setFont:[UIFont fontWithName:@"Knewave" size:18.0f]];
    // Draw a custom gradient
    // Set the button Background Color
    //[self.btnSubmit setBackgroundColor:[UIColor blackColor]];
    // Draw a custom gradient
    btnGradient = [CAGradientLayer layer];
    btnGradient.frame = self.btnSubmit.bounds;
    btnGradient.colors = [NSArray arrayWithObjects:
                          (id)[[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] CGColor],
                          (id)[[UIColor colorWithRed:51.0f / 255.0f green:51.0f / 255.0f blue:51.0f / 255.0f alpha:1.0f] CGColor],
                          nil];
    [self.btnSubmit.layer insertSublayer:btnGradient atIndex:0];
    
    // Round button corners
    btnLayer = [self.btnSubmit layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    
    // Apply a 1 pixel, black border
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor blackColor] CGColor]];
    
    //**************************
    // Set the button Text Color
    [self.btnStartDraft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnStartDraft setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [[self.btnStartDraft titleLabel] setFont:[UIFont fontWithName:@"Knewave" size:18.0f]];
    // Draw a custom gradient
    // Set the button Background Color
    //[self.btnStartDraft setBackgroundColor:[UIColor blackColor]];
    // Draw a custom gradient
    btnGradient = [CAGradientLayer layer];
    btnGradient.frame = self.btnStartDraft.bounds;
    btnGradient.colors = [NSArray arrayWithObjects:
                          (id)[[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] CGColor],
                          (id)[[UIColor colorWithRed:51.0f / 255.0f green:51.0f / 255.0f blue:51.0f / 255.0f alpha:1.0f] CGColor],
                          nil];
    [self.btnStartDraft.layer insertSublayer:btnGradient atIndex:0];
    
    // Round button corners
    btnLayer = [self.btnStartDraft layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    
    // Apply a 1 pixel, black border
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor blackColor] CGColor]];
    
    //**************************
    // Set the button Text Color
    [self.btnViewResults setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnViewResults setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [[self.btnViewResults titleLabel] setFont:[UIFont fontWithName:@"Knewave" size:18.0f]];
    // Draw a custom gradient
    // Set the button Background Color
    //[self.btnViewResults setBackgroundColor:[UIColor blackColor]];
    // Draw a custom gradient
    btnGradient = [CAGradientLayer layer];
    btnGradient.frame = self.btnViewResults.bounds;
    btnGradient.colors = [NSArray arrayWithObjects:
                          (id)[[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] CGColor],
                          (id)[[UIColor colorWithRed:51.0f / 255.0f green:51.0f / 255.0f blue:51.0f / 255.0f alpha:1.0f] CGColor],
                          nil];
    [self.btnViewResults.layer insertSublayer:btnGradient atIndex:0];
    
    // Round button corners
    btnLayer = [self.btnViewResults layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    
    // Apply a 1 pixel, black border
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor blackColor] CGColor]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadReloadTeamsArray];
    //NSLog(@"League Name: %@, League Index: %d", currLeague, currLeagueIndexRow);
    
    self.btnStartDraft.hidden = NO;
    //NSLog(@"Team Count: %d", [arrTeams count]);
    
    for (int i = 0; i < [arrTeams count]; i++)
    {
        if ([[arrTeams objectAtIndex:i] movieCount] > 0)
        {
            //hides start draft button
            //self.btnStartDraft.hidden = YES;
            //self.btnAddPlayers.enabled = NO;
        }
        else
        {
            //self.btnStartDraft.hidden = NO;
            //self.btnAddPlayers.enabled = YES;
        }
    }
}

- (void)loadReloadTeamsArray
{
    //Get the reference to the application to access the DB (uses appdelegate.h)
    AppDelegate *appD = [[UIApplication sharedApplication] delegate];
    
    //Access to the data through the reference of the application
    NSManagedObjectContext *context = [appD managedObjectContext];
    
    //fetch teams
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"League" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSError *error;
    
    arrLeagues = [context executeFetchRequest:fetchRequest error:&error];
    arrTeams = [[[arrLeagues objectAtIndex:currLeagueIndexRow] leagueTeam] allObjects];
    
    [tblTeams reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrTeams count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Team Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@", [[arrTeams objectAtIndex:indexPath.row] name]];
    cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"Movies: %@", [[arrTeams objectAtIndex:indexPath.row] movieCount]];
    
    return cell;
}

//enable editing of table view
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//deleting object at row deleted
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get the reference to the application to access the DB (uses appdelegate.h)
    AppDelegate *appD = [[UIApplication sharedApplication] delegate];
    
    //Access to the data through the reference of the application
    NSManagedObjectContext *context = [appD managedObjectContext];
    
    //used to check if team exists already
    //************************************
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *fetchEntity = [NSEntityDescription entityForName:@"League" inManagedObjectContext:context];
    NSError *error;
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"(name = %@)", currLeague];
    
    [request setEntity:fetchEntity];
    [request setPredicate:namePredicate];
    
    NSArray *objects = [context executeFetchRequest:request error:&error];
    //NSLog(@"LeagueCount: %d", [objects count]);
    
    //if team is found
    if ([objects count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hmm." message:@"Your league does not exist." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    else
    {
        League *leagueInfo = [objects objectAtIndex:0];
        //NSLog(@"%@", [NSNumber numberWithInt:[objects count]]);
        
        //NSString *myName = [[[[[objects objectAtIndex:0] leagueTeam] allObjects] objectAtIndex:indexPath.row] name];
        //NSLog(@"MyName (currIndexRow): %@", myName);
    
        [leagueInfo removeLeagueTeamObject:[[[leagueInfo leagueTeam] allObjects] objectAtIndex:indexPath.row]];
    
        leagueInfo.teamCount = [NSNumber numberWithInt:[[[[objects objectAtIndex:0] leagueTeam] allObjects] count]];
    
        [context save:&error];
    
        [self loadReloadTeamsArray];
    }
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"seguePlayersToDraft"])
    {
        if ([arrTeams count] < 2)
        {
            UIAlertView *myAlert = [[UIAlertView alloc]
                                    initWithTitle:@""
                                    message:@"A draft cannot consist of less than 2 players."
                                    delegate:self
                                    cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [myAlert show];

            return NO;
        }
        
        if ([arrTeams count] > 12)
        {
            UIAlertView *myAlert = [[UIAlertView alloc]
                                    initWithTitle:@""
                                    message:@"A draft cannot consist of more than 12 players."
                                    delegate:self
                                    cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [myAlert show];
            
            return NO;
        }
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *team = [[NSString alloc] initWithFormat:@"%@", [[arrTeams objectAtIndex:indexPath.row] name]];
    
    NSString *postText = [[NSString alloc] initWithFormat:@"I\'m not saying that Team %@ will win the %@ Movie Draft, but that\'s what I\'m saying. #face", team, currLeague];
    
    NSArray *activityItems = @[postText];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    [self presentViewController:activityController animated:YES completion:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"seguePlayersToDraft"])
    {
        //Get reference to the destination view controller
        PlayerViewController *vc = [segue destinationViewController];
        
        vc.currLeague = currLeague;
        vc.currLeagueIndexRow = currLeagueIndexRow;
    }
}

- (IBAction)cancel:(id)sender
{
    //clear text field
    [txtAddedTeam setText:@""];
    
    [self hideKeyboards];
    [self.view sendSubviewToBack:addTeamContainer];
}

- (IBAction)clickedOutsideTextField:(id)sender
{
    [self hideKeyboards];
}

- (void)hideKeyboards
{
    if (txtAddedTeam.isFirstResponder)
    {
        [txtAddedTeam resignFirstResponder];
    }
}

- (IBAction)showAddTeamContainer:(id)sender
{
    [self.view bringSubviewToFront:addTeamContainer];
    [txtAddedTeam becomeFirstResponder];
}

- (IBAction)submitTeam:(id)sender
{
    //alert when name text Field is empty
    if ([txtAddedTeam.text isEqualToString:@""])
    {
        UIAlertView *myAlert = [[UIAlertView alloc]
                                initWithTitle:@""
                                message:@"Please enter the name of the team."
                                delegate:self
                                cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [myAlert show];
        
        //bring the user back to the first text field
        [txtAddedTeam becomeFirstResponder];
    }
    else
    {
        //Get the reference to the application to access the DB (uses appdelegate.h)
        AppDelegate *appD = [[UIApplication sharedApplication] delegate];
        
        //Access to the data through the reference of the application
        NSManagedObjectContext *context = [appD managedObjectContext];
        
        //used to check if team exists already
        //************************************
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *fetchEntity = [NSEntityDescription entityForName:@"League" inManagedObjectContext:context];
        NSError *error;
        NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"(name = %@)",currLeague];
        
        [request setEntity:fetchEntity];
        [request setPredicate:namePredicate];
        
        //NSManagedObject *matches = nil;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        
        //if team is found
        if ([objects count] == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hmm." message:@"Your league does not exist." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];

        }
        else
        {
            League *leagueInfo = [objects objectAtIndex:0];
            
            //declare player not found
            playerFound = NO;
            
            for (int i=0; i < [leagueInfo.teamCount intValue]; i++)
            {
                //NSLog(@"%@", [[[[leagueInfo leagueTeam] allObjects] objectAtIndex:i] name]);
                
                NSString *thisTeam = (NSString *)[[[[leagueInfo leagueTeam] allObjects] objectAtIndex:i] name];
                
                if ([txtAddedTeam.text.capitalizedString isEqualToString:thisTeam.capitalizedString])
                {
                    playerFound = YES;
                }
            }
            
            if (playerFound == YES)
            {
                UIAlertView *myAlert = [[UIAlertView alloc]
                                        initWithTitle:@""
                                        message:@"The team already exists. Please choose a different team name."
                                        delegate:self
                                        cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [myAlert show];
                
                //[txtAddedTeam becomeFirstResponder];
            }
            else
            {
                Team *teamInfo = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"Team"
                                  inManagedObjectContext:context];
                
                [leagueInfo addLeagueTeamObject:teamInfo];
                
                teamInfo.name = [txtAddedTeam.text capitalizedString];
                teamInfo.teamLeague.name = currLeague;
                teamInfo.teamBudget = [NSNumber numberWithInt:250];
                
                leagueInfo.teamCount = [NSNumber numberWithInt:[leagueInfo.leagueTeam count]];
                
                //try for error
                if (![context save:&error])
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save failed" message:[NSString stringWithFormat:@"Save core data failed %@", [error localizedDescription]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                
                //clear text field
                [txtAddedTeam setText:@""];
                
                //reload player table
                [self loadReloadTeamsArray];
            }
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
