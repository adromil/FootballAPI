//
//  AppDelegate.m
//  FootballAPI
//
//  Created by Adromil Balais on 8/16/15.
//  Copyright (c) 2015 Tau Gamma Phi. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
        
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Custom Methods

- (NSArray *)httpCallForJSONToURL:(NSURL *)wsURL withParameters:(NSDictionary *)params usingMethod:(NSString *)callMethod {
    __block NSArray *jsonResponse = @[@{@"xError":@"Unable to Retrieve Server Response."}];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    if ([callMethod isEqualToString:@"POST"]) {
        NSString *fParam = (params != nil) ? [params uq_URLQueryString]:@"";
        
        NSData *fParamData = [fParam dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *fParamLength = [NSString stringWithFormat:@"%lu", (unsigned long)[fParamData length]];
        
        [request setURL:wsURL];
        [request setHTTPMethod:@"POST"];
        [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
        [request setTimeoutInterval:10.0];
        [request setValue:@"1c3f9a0f684c4695b7a3ef53b9e50812" forHTTPHeaderField:@"X-Auth-Token"];
        [request setValue:fParamLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:fParamData];
        
        NSURLResponse *response = nil;
        NSError *connectionError = nil;
        NSLog(@"%@", request);
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&connectionError];
        if (!connectionError) {
            NSError *error = nil;
            //            NSLog(@"response:");
            //            NSLog(@"%@", response);
            NSLog(@"Response as String:");
            NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            //            NSLog(@"Response as JSON[Assoc Array]:");
            //            NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error]);
            
            jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            //            NSLog(@"error:");
            //            NSLog(@"%@", error);
            if (error != nil) {
                jsonResponse = @[@{@"xError":error.localizedDescription}];
            }
        } else {
            //            NSLog(@"%@", connectionError.localizedDescription);
            jsonResponse = @[@{@"xError":connectionError.localizedDescription}];
        }
        
        //        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //            NSLog(@"connectionError");
        //            NSLog(@"%@", connectionError);
        //            if (!connectionError) {
        //                NSLog(@"response:");
        //                NSLog(@"%@", response);
        //                NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        //
        //                NSError *error = nil;
        //                jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        //
        //                NSLog(@"error:");
        //                NSLog(@"%@", error);
        //                if (error != nil) {
        //                    jsonResponse = @[@{@"xError":error.localizedDescription}];
        //                }
        //            } else {
        //                NSLog(@"%@", connectionError.localizedDescription);
        //                jsonResponse = @[@{@"xError":connectionError.localizedDescription}];
        //            }
        //
        //        }];
        
    } else {
        
        NSError *requestError;
        NSURLResponse *urlResponse = nil;
        
//        NSURL *apiURL = [NSURL URLWithString:[NSString stringWithFormat:@"?%@", fParam] relativeToURL:wsURL];
        NSURL *apiURL = [wsURL uq_URLByAppendingQueryDictionary:params];
        
//        NSURLRequest *requestURL = [NSURLRequest requestWithURL:apiURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        [request setURL:apiURL];
        [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
        [request setTimeoutInterval:10.0];
        [request setValue:@"1c3f9a0f684c4695b7a3ef53b9e50812" forHTTPHeaderField:@"X-Auth-Token"];
        NSLog(@"%@", request.URL.absoluteString);
        NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
        
        if (requestError == nil) {
            
            if ([jsonData length] > 0) {
                @try {
                    jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&requestError];
                    if (requestError != nil) {
                        jsonResponse = @[@{@"xError":requestError.localizedDescription}];
                    }
                }
                @catch (NSError *exError) {
                    jsonResponse = @[@{@"xError":exError.localizedDescription}];
                }
                
            }
        } else {
            jsonResponse = @[@{@"xError":requestError.localizedDescription}];
        }
        /*
         NSURL *requestURL = [NSURL URLWithString:fParam relativeToURL:wsURL];
         NSString *responseText = [NSString stringWithContentsOfURL:requestURL encoding:NSUTF8StringEncoding error:&requestError];
         
         NSData *responseData = [responseText dataUsingEncoding:NSUTF8StringEncoding];
         jsonResponse = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&requestError];
         */
        
    }
    
    return jsonResponse;
}

@end
