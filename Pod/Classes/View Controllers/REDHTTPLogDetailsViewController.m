//
//  REDHTTPLogDetailsViewController.m
//  Pods
//
//  Created by Red Davis on 31/03/2015.
//
//

#import "REDHTTPLogDetailsViewController.h"
#import "REDHTTPLog.h"
#import "REDHTTPLogRequestViewController.h"
#import "REDHTTPLogResponseViewController.h"


@interface REDHTTPLogDetailsViewController ()

@property (strong, nonatomic) REDHTTPLog *log;

@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) REDHTTPLogRequestViewController *requestViewController;
@property (strong, nonatomic) REDHTTPLogResponseViewController *responseViewController;

- (void)shareLogButtonTapped:(id)sender;

@end


@implementation REDHTTPLogDetailsViewController

#pragma mark - Initialization

- (instancetype)initWithHTTPLog:(REDHTTPLog *)log
{
    self = [self init];
    if (self)
    {
        self.log = log;
        
        self.requestViewController = [[REDHTTPLogRequestViewController alloc] initWithHTTPLog:self.log];
        UINavigationController *requestNavigationController = [[UINavigationController alloc] initWithRootViewController:self.requestViewController];
        
        self.requestViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareLogButtonTapped:)];
        
        self.responseViewController = [[REDHTTPLogResponseViewController alloc] initWithHTTPLog:self.log];
        UINavigationController *responseNavigationController = [[UINavigationController alloc] initWithRootViewController:self.responseViewController];
        
        self.responseViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareLogButtonTapped:)];
        
        self.tabBarController = [[UITabBarController alloc] init];
        self.tabBarController.viewControllers = @[requestNavigationController, responseNavigationController];
        [self addChildViewController:self.tabBarController];
    }
    
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tabBarController.view];
}

- (void)viewDidLayoutSubviews
{
    CGRect bounds = self.view.bounds;
    self.tabBarController.view.frame = bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (void)shareLogButtonTapped:(id)sender
{
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.log.description] applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

@end
