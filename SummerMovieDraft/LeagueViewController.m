//
//  LeagueViewController.m
//  SummerMovieDraft
//
//  Created by Chris Tot on 6/15/13.
//  Copyright (c) 2013 christurnage. All rights reserved.
//

#import "LeagueViewController.h"
#import "AppDelegate.h"
#import "League.h"
#import "PlayerViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface LeagueViewController ()

//League Objects
@property (strong, nonatomic) NSArray *arrLeagues;
@property (weak, nonatomic) IBOutlet UITableView *tblLeagues;

- (IBAction)showAddLeagueContainer:(id)sender;

//Add League Objects
@property (weak, nonatomic) IBOutlet UIView *addLeagueContainer;
@property (weak, nonatomic) IBOutlet UITextField *txtAddedLeague;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;


- (IBAction)submitLeague:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)clickedOutsideTextField:(id)sender;

@end

@implementation LeagueViewController
@synthesize arrLeagues, tblLeagues;
@synthesize addLeagueContainer, txtAddedLeague;

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
    arrLeagues = [[NSArray alloc] init];
    
    //set keyboard capitalization
    txtAddedLeague.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
}

-(void)customizeButtons
{
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

}

- (void)viewWillAppear:(BOOL)animated
{
    //reloads table
    [self loadReloadLeaguesArray];
}

- (void)loadReloadLeaguesArray
{
    //Get the reference to the application to access the DB (uses appdelegate.h)
    AppDelegate *appD = [[UIApplication sharedApplication] delegate];
    
    //Access to the data through the reference of the application
    NSManagedObjectContext *context = [appD managedObjectContext];
    
    //fetch leagues
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"League" inManagedObjectContext:context];

    [fetchRequest setEntity:entity];
    NSError *error;
    
    arrLeagues = [context executeFetchRequest:fetchRequest error:&error];
    
    [tblLeagues reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrLeagues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"League Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    League *info = [arrLeagues objectAtIndex:indexPath.row];
    cell.textLabel.text = info.name;
    cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"Players: %@", info.teamCount];
    
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
    
    NSString *tempName = [[arrLeagues objectAtIndex:indexPath.row] name];
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"(name = %@)", tempName];
    
    [request setEntity:fetchEntity];
    [request setPredicate:namePredicate];
    
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    //if team is found
    if ([objects count] != 0)
    {
        [context deleteObject:[objects objectAtIndex:0]];
        
        [context save:&error];
    }
    else
    {
        //NSLog(@"The league did not exist.");
    }
    
    [self loadReloadLeaguesArray];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueLeagueToTeam"])
    {
        //Get reference to the destination view controller
        PlayerViewController *vc = [segue destinationViewController];
        
        //note that "sender" will be the tableView cell that was selected
        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [tblLeagues indexPathForCell:cell];

        vc.currLeague = [[arrLeagues objectAtIndex:indexPath.row] name];
        vc.currLeagueIndexRow = indexPath.row;
    }
}

- (IBAction)cancel:(id)sender
{
    //clear text field
    [txtAddedLeague setText:@""];
    
    [self hideKeyboards];
    [self.view sendSubviewToBack:addLeagueContainer];
}

- (IBAction)clickedOutsideTextField:(id)sender
{
    [self hideKeyboards];
}

- (void)hideKeyboards
{
    if (txtAddedLeague.isFirstResponder)
    {
        [txtAddedLeague resignFirstResponder];
    }
}

- (IBAction)showAddLeagueContainer:(id)sender
{
    [self.view bringSubviewToFront:addLeagueContainer];
    [txtAddedLeague becomeFirstResponder];
}

- (IBAction)submitLeague:(id)sender
{
    //alert when added league text field is empty
    if ([txtAddedLeague.text isEqualToString:@""])
    {
        UIAlertView *myAlert = [[UIAlertView alloc]
                                initWithTitle:@""
                                message:@"Please enter the league name."
                                delegate:self
                                cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [myAlert show];
        
        //bring the user back to the added league text field
        [txtAddedLeague becomeFirstResponder];

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
        NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"(name = %@)",[txtAddedLeague.text uppercaseString]];
        
        [request setEntity:fetchEntity];
        [request setPredicate:namePredicate];
        
        NSArray *objects = [context executeFetchRequest:request error:&error];
        
        //if team is found
        if ([objects count] != 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add failed." message:@"Please enter a league that does not already exist." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            [txtAddedLeague becomeFirstResponder];
        }
        else
        {
            League *leagueInfo = [NSEntityDescription insertNewObjectForEntityForName:@"League" inManagedObjectContext:context];
            
            //set the values entered before and after creating subclass
            leagueInfo.name = [txtAddedLeague.text uppercaseString];
            leagueInfo.teamCount = [NSNumber numberWithInt:0];
            
            //try for error
            if (![context save:&error])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save failed" message:[NSString stringWithFormat:@"Save core data failed %@", [error localizedDescription]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            
            //clear text field
            [txtAddedLeague setText:@""];
            
            [self hideKeyboards];
            
            //reload league table
            [self loadReloadLeaguesArray];
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
