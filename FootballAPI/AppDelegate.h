//
//  AppDelegate.h
//  FootballAPI
//
//  Created by Adromil Balais on 8/16/15.
//  Copyright (c) 2015 Tau Gamma Phi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "NSURL+QueryDictionary.h"
#import "MBProgressHUD.h"

#define MAIN_URL @"http://api.football-data.org/alpha/soccerseasons"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (NSArray *)httpCallForJSONToURL:(NSURL *)wsURL withParameters:(NSDictionary *)params usingMethod:(NSString *)callMethod;

@end

