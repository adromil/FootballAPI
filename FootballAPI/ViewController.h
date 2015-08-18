//
//  ViewController.h
//  FootballAPI
//
//  Created by Adromil Balais on 8/16/15.
//  Copyright (c) 2015 Tau Gamma Phi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate> {
    AppDelegate *appDelegate;
}
@property (weak, nonatomic) IBOutlet UITableView *seasonTable;
@property (strong, nonatomic) IBOutlet MBProgressHUD *hud;

@end

