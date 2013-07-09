//
//  MainScreenViewController.m
//  SummerMovieDraft
//
//  Created by Chris Tot on 6/15/13.
//  Copyright (c) 2013 christurnage. All rights reserved.
//

#import "MainScreenViewController.h"
#import "WebViewController.h"
#import "AppDelegate.h"
#import "MovieInfo.h"
#import "MBProgressHUD.h"

@interface MainScreenViewController ()
{
    NSString *currURL;
}

@property AppDelegate *appD;
@property (strong, nonatomic) NSMutableArray *movieCollection;
@property (weak, nonatomic) IBOutlet UILabel *lblReleaseDate;
@property (weak, nonatomic) IBOutlet UILabel *lblBoxOfficeSales;
@property (weak, nonatomic) IBOutlet UIImageView *imgPoster;

@end

@implementation MainScreenViewController
@synthesize appD;
@synthesize movieCollection;
@synthesize tblMoviesList;
@synthesize lblBoxOfficeSales, lblReleaseDate, imgPoster;

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
    
    NSLog(@"Made a change to git");
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    //initialize first movie art
    currURL = @"http://ia.media-imdb.com/images/M/MV5BMjIzMzAzMjQyM15BMl5BanBnXkFtZTcwNzM2NjcyOQ@@._V1_SX214_.jpg";
    
    movieCollection = [[NSMutableArray alloc] init];
    
    //Get the reference to the application to access the DB (uses appdelegate.h)
    appD = [[UIApplication sharedApplication] delegate];
    
    //load first movie art
    [appD networkCheck];
    
    if (appD.isConnected)
    {
        [MBProgressHUD showHUDAddedTo:imgPoster animated:YES];
        
        //load image on background thread
        NSOperationQueue *queue = [NSOperationQueue new];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadImage) object:nil];
        
        [queue addOperation:operation];
    }
    
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
        newMovie.strReleaseDate = [item objectForKey:@"Release Date"];
        newMovie.strImdb = [item objectForKey:@"imdb"];
        newMovie.strUrl = [item objectForKey:@"img"];
        
        if ([[item objectForKey:@"wk4_gross"] intValue] > 0)
        {
            newMovie.gross = [[item objectForKey:@"wk4_gross"] intValue];
        }
        else if ([[item objectForKey:@"wk3_gross"] intValue] > 0)
        {
            newMovie.gross = [[item objectForKey:@"wk3_gross"] intValue];

        }
        else if ([[item objectForKey:@"wk2_gross"] intValue] > 0)
        {
            newMovie.gross = [[item objectForKey:@"wk2_gross"] intValue];

        }
        else if ([[item objectForKey:@"wk1_gross"] intValue] > 0)
        {
            newMovie.gross = [[item objectForKey:@"wk1_gross"] intValue];

        }
        else
        {
            newMovie.gross = 0;
        }
        
        //NSLog(@"%d", [[item objectForKey:@"id"] intValue]);
        //NSLog(@"%@",[item objectForKey:@"Release Date"]);
        //NSLog(@"%@",[[item objectForKey:@"cold_water"] stringValue]);
        
        [movieCollection addObject:newMovie];
    }
    
    [tblMoviesList reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [tblMoviesList selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"Draftable Movies List";
    return title;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [movieCollection count];
    return 400;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MovieInfo Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.height, cell.frame.size.width)];
    [bgView setBackgroundColor:[UIColor blackColor]];
    [cell setSelectedBackgroundView:bgView];
    
    NSString *movieTitle = [[movieCollection objectAtIndex:indexPath.row] strTitle];
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@", movieTitle];
    
    float movieBudget = [[movieCollection objectAtIndex:indexPath.row] budget] / 1000000.0;
    cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"Budget: $%g Million", movieBudget];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    float currentEarnings = [[movieCollection objectAtIndex:indexPath.row] gross] / 1000000.0;
    
    lblReleaseDate.text = [[movieCollection objectAtIndex:indexPath.row] strReleaseDate];
    lblBoxOfficeSales.text = [NSString stringWithFormat:@"$%0.1f Million", currentEarnings];
    
    currURL = [[movieCollection objectAtIndex:indexPath.row] strUrl];

    [appD networkCheck];
    if (appD.isConnected)
    {
        [MBProgressHUD showHUDAddedTo:imgPoster animated:YES];
    
        //load image on background thread
        NSOperationQueue *queue = [NSOperationQueue new];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadImage) object:nil];
    
        [queue addOperation:operation];
    }
    else
    {
        imgPoster.image = [UIImage imageNamed:@"blankPoster.png"];
    }
}

- (void)loadImage
{
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:currURL]];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    
    [self performSelectorOnMainThread:@selector(displayImage:) withObject:image waitUntilDone:NO];
    
    }

- (void)displayImage:(UIImage *)image
{
    [imgPoster setImage:image];
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [MBProgressHUD hideHUDForView:imgPoster animated:YES];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"showIMDB"])
    {
        // Get reference to the destination view controller
        WebViewController *vc = [segue destinationViewController];
        
        //NSIndexPath *path = [tblMoviesList indexPathForSelectedRow];
        NSIndexPath *path = [tblMoviesList indexPathForCell:sender];
        
        //NSLog(@"%ld", (long)path.row);
        
        // Pass title and url
        vc.storedMovieTitle = [[movieCollection objectAtIndex:path.row] strTitle];
        vc.urlAddress = [[movieCollection objectAtIndex:path.row] strImdb];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
