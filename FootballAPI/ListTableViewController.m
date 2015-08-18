//
//  ListTableViewController.m
//  FootballAPI
//
//  Created by Adromil Balais on 8/16/15.
//  Copyright (c) 2015 Tau Gamma Phi. All rights reserved.
//

#import "ListTableViewController.h"

NSArray *fixturesArray;
NSMutableArray *searchedArray;

@interface ListTableViewController ()

@end

@implementation ListTableViewController

@synthesize fixturesURL;
@synthesize hud;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"League Season";
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.fixturesTableView setHidden:YES];
    if (fixturesURL != nil) {
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus internetStatus = [reachability currentReachabilityStatus];
        [self initializeHUDWithMode:MBProgressHUDModeIndeterminate andLabel:@"Please Wait..."];
        [hud showAnimated:YES whileExecutingBlock:^{
            if (internetStatus != NotReachable) {
                NSArray *seasonArray = [appDelegate httpCallForJSONToURL:fixturesURL withParameters:nil usingMethod:@"GET"];
                fixturesArray = [seasonArray valueForKey:@"fixtures"];
                NSLog(@"%i", (int)fixturesArray.count);
                NSLog(@"%@", fixturesArray);
            }
        } completionBlock:^{
            BOOL shouldAlert = NO;
            UIAlertView *serverErrorAlert = [[UIAlertView alloc] initWithTitle:@"Server Response" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            if ([fixturesArray isKindOfClass:[NSDictionary class]]) {
                [serverErrorAlert setMessage:[fixturesArray valueForKey:@"error"]];
                shouldAlert = YES;
            } else if ([[fixturesArray objectAtIndex:0] valueForKey:@"xError"]) {
                [serverErrorAlert setMessage:[[fixturesArray objectAtIndex:0] valueForKey:@"xError"]];
                shouldAlert = YES;
            } else {
                if (fixturesArray.count > 0) {
                    [self.fixturesTableView reloadData];
                } else {
                    [serverErrorAlert setMessage:@"Unable to Retrieve Correct Server Response."];
                    shouldAlert = YES;
                }
            }
            if (shouldAlert) {
                [serverErrorAlert show];
            }
        }];
    }
    
    searchedArray = [NSMutableArray arrayWithCapacity:fixturesArray.count];
    
    self.resultSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.resultSearchController.searchResultsUpdater = self;
    self.resultSearchController.dimsBackgroundDuringPresentation = NO;
    self.resultSearchController.hidesNavigationBarDuringPresentation = NO;
    self.resultSearchController.searchBar.frame = CGRectMake(self.resultSearchController.searchBar.frame.origin.x, self.resultSearchController.searchBar.frame.origin.y, self.resultSearchController.searchBar.frame.size.width, 44.0);
    self.fixturesTableView.tableHeaderView = self.resultSearchController.searchBar;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.fixturesTableView setHidden:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.fixturesTableView setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UItableView datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (self.resultSearchController.active) {
        NSLog(@"searchedArray:");
        NSLog(@"%i", (int)[searchedArray count]);
        return [searchedArray count];
    } else {
        NSLog(@"fixturesArray:");
        NSLog(@"%i", (int)[fixturesArray count]);
        return [fixturesArray count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"FixturesCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    // Configure the cell...
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSLog(@"%@", tableView);
//    
    if (self.resultSearchController.active) {
        NSString *homeTeam = [[searchedArray objectAtIndex:indexPath.row] valueForKey:@"homeTeamName"];
        NSString *awayTeam = [NSString stringWithFormat:@"vs %@", [[searchedArray objectAtIndex:indexPath.row] valueForKey:@"awayTeamName"]];
        cell.textLabel.text = homeTeam;
        cell.detailTextLabel.text = awayTeam;
    } else {
        NSString *homeTeam = [[fixturesArray objectAtIndex:indexPath.row] valueForKey:@"homeTeamName"];
        NSString *awayTeam = [NSString stringWithFormat:@"vs %@", [[fixturesArray objectAtIndex:indexPath.row] valueForKey:@"awayTeamName"]];
        cell.textLabel.text = homeTeam;
        cell.detailTextLabel.text = awayTeam;
    }
    
    return cell;
}


#pragma mark - UItableView delegate methods
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UISearchBarDelegate methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"Search: %@", searchText);
}


#pragma mark - UISearchResultsUpdating methods
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [self.resultSearchController.searchBar text];
    
    [self updateFilteredContentForTeamName:searchString];
    
    [self.tableView reloadData];
}

#pragma mark - Custom methods
- (void)initializeHUDWithMode:(MBProgressHUDMode)hudMode andLabel:(NSString *)labelText {
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.dimBackground = YES;
    hud.delegate = self;
    hud.mode = hudMode;
    hud.labelText = labelText;
}

- (void)updateFilteredContentForTeamName:(NSString *)teamName {
    NSLog(@"%@", teamName);
    // Update the filtered array based on the search text and scope.
    if ((teamName == nil) || [teamName length] == 0) {
            // If there is no search string and the scope is chosen.
        searchedArray = [fixturesArray mutableCopy];
        return;
    }
    
    
    [searchedArray removeAllObjects]; // First clear the filtered array.
    
    /*  Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
     */
    for (NSDictionary *fixture in fixturesArray) {
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSString *homeTeamNameString = (NSString *)[fixture objectForKey:@"homeTeamName"];
        NSRange homeTeamNameRange = NSMakeRange(0, homeTeamNameString.length);
        NSRange homeTeamNameFoundRange = [homeTeamNameString rangeOfString:teamName options:searchOptions range:homeTeamNameRange];
        
        NSString *awayTeamNameString = (NSString *)[fixture objectForKey:@"awayTeamName"];
        NSRange awayTeamNameRange = NSMakeRange(0, awayTeamNameString.length);
        NSRange awayTeamNameFoundRange = [awayTeamNameString rangeOfString:teamName options:searchOptions range:awayTeamNameRange];
        
        if (homeTeamNameFoundRange.length > 0 || awayTeamNameFoundRange.length > 0) {
            [searchedArray addObject:fixture];
        }
    }
}

@end
