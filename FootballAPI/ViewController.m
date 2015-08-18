//
//  ViewController.m
//  FootballAPI
//
//  Created by Adromil Balais on 8/16/15.
//  Copyright (c) 2015 Tau Gamma Phi. All rights reserved.
//

#import "ViewController.h"
#import "ListTableViewController.h"

NSArray *jsonArray;

@interface ViewController ()

@end

@implementation ViewController

@synthesize hud;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSURL *mainURL = [NSURL URLWithString:MAIN_URL];
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    [self initializeHUDWithMode:MBProgressHUDModeIndeterminate andLabel:@"Please Wait..."];
    [hud showAnimated:YES whileExecutingBlock:^{
        if (internetStatus != NotReachable) {
            jsonArray = [appDelegate httpCallForJSONToURL:mainURL withParameters:nil usingMethod:@"GET"];
            NSLog(@"%i", (int)jsonArray.count);
        }
    } completionBlock:^{
        NSLog(@"%@", jsonArray);
        BOOL shouldAlert = NO;
        UIAlertView *serverErrorAlert = [[UIAlertView alloc] initWithTitle:@"Server Response" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        if ([jsonArray isKindOfClass:[NSDictionary class]]) {
            [serverErrorAlert setMessage:[jsonArray valueForKey:@"error"]];
            shouldAlert = YES;
        } else if ([[jsonArray objectAtIndex:0] valueForKey:@"xError"]) {
            [serverErrorAlert setMessage:[[jsonArray objectAtIndex:0] valueForKey:@"xError"]];
            shouldAlert = YES;
        } else {
            if (jsonArray.count > 0) {
                [self.seasonTable reloadData];
            } else {
                [serverErrorAlert setMessage:@"Unable to Retrieve Correct Server Response."];
                shouldAlert = YES;
            }
        }
        if (shouldAlert) {
            [serverErrorAlert show];
        }
        
    }];
//    [hud hide:YES];
//    double interval = [[NSDate date] timeIntervalSinceNow];
//    double delayInSeconds = interval+1;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^{
//        
//    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"FixturesSegue"]) {
        NSIndexPath *indexPath = [self.seasonTable indexPathForSelectedRow];
        ListTableViewController *listViewCtrl = segue.destinationViewController;
        NSDictionary *linksDict = (NSDictionary *)[[jsonArray objectAtIndex:indexPath.row] objectForKey:@"_links"];
//        NSLog(@"%@", linksDict);
        NSString *href = [[linksDict objectForKey:@"fixtures"] valueForKey:@"href"];
//        NSLog(@"%@", href);
        listViewCtrl.fixturesURL = [NSURL URLWithString:href];
    }
}

#pragma mark - UITableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [jsonArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SeasonCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if (jsonArray.count > 0) {
        cell.textLabel.text = [[jsonArray objectAtIndex:indexPath.row] valueForKey:@"caption"];
        NSString *det = [NSString stringWithFormat:@"%@ %@ | %@ Teams, %@ Games", [[jsonArray objectAtIndex:indexPath.row] valueForKey:@"league"], [[jsonArray objectAtIndex:indexPath.row] valueForKey:@"year"], [[jsonArray objectAtIndex:indexPath.row] valueForKey:@"numberOfTeams"], [[jsonArray objectAtIndex:indexPath.row] valueForKey:@"numberOfGames"]];
        cell.detailTextLabel.text = det;
    }
    return cell;
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

@end
