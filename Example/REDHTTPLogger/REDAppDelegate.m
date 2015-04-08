//
//  REDAppDelegate.m
//  REDHTTPLogger
//
//  Created by CocoaPods on 03/28/2015.
//  Copyright (c) 2014 Red Davis. All rights reserved.
//

#import "REDAppDelegate.h"

#import <AFNetworking/AFNetworking.h>
#import <REDHTTPLogger/REDHTTPLogger.h>
#import <REDHTTPLogger/REDHTTPLogsViewController.h>


@interface REDAppDelegate ()

- (void)dispatchHTTPRequest;

@end


@implementation REDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[REDHTTPLogsViewController alloc] init]];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];

    [[REDHTTPLogger sharedLogger] startLogging];
    
    [self dispatchHTTPRequest];
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(dispatchHTTPRequest) userInfo:nil repeats:YES];
    
    return YES;
}

#pragma mark -

- (void)dispatchHTTPRequest
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    // GET JSON
    [manager GET:@"http://demo1289807.mockable.io/200JSON" parameters:@{@"param1":@"value1"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // GET XML
        [manager GET:@"http://demo1289807.mockable.io/200XML" parameters:@{@"param1":@"value1"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
    
    // POST JSON
    [sessionManager POST:@"http://demo1289807.mockable.io/200JSON" parameters:@{@"param1":@"value1"} success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    // GET JSON
    [sessionManager GET:@"http://demo1289807.mockable.io/200JSON" parameters:@{@"param1":@"value1", @"session-manager":@YES} success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    // 404
    [manager POST:@"http://demo1289807.mockable.io/404" parameters:@{@"param1":@"value1"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark -

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
