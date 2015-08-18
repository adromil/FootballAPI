//
//  ListTableViewController.h
//  FootballAPI
//
//  Created by Adromil Balais on 8/16/15.
//  Copyright (c) 2015 Tau Gamma Phi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ListTableViewController : UITableViewController <MBProgressHUDDelegate, UISearchResultsUpdating, UISearchBarDelegate> {
    AppDelegate *appDelegate;
}

@property (strong, nonatomic) IBOutlet UITableView *fixturesTableView;
@property (strong, nonatomic) IBOutlet MBProgressHUD *hud;

@property (strong, nonatomic) UISearchController *resultSearchController;

@property (strong, nonatomic) NSURL *fixturesURL;

@end
