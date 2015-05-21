//
//  REDHTTPLogsViewController.m
//  Pods
//
//  Created by Red Davis on 28/03/2015.
//
//

#import "REDHTTPLogsViewController.h"
#import "REDHTTPLogger.h"
#import "REDHTTPLogTableViewCell.h"
#import "REDHTTPLogDetailsViewController.h"


@interface REDHTTPLogsViewController () <UITableViewDataSource, UITableViewDelegate, REDHTTPLoggerObserver>

@property (strong, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSArray *logs;

- (void)doneButtonTapped:(id)sender;

@end


@implementation REDHTTPLogsViewController

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.title = @"HTTP Logs";
    }

    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.navigationController.viewControllers.firstObject == self)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.logs = [REDHTTPLogger sharedLogger].logs.reverseObjectEnumerator.allObjects;
    [self.tableView reloadData];
    
    [[REDHTTPLogger sharedLogger] addObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[REDHTTPLogger sharedLogger] removeObserver:self];
}

- (void)viewDidLayoutSubviews
{
    CGRect bounds = self.view.bounds;
    self.tableView.frame = bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (void)doneButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - REDHTTPLoggerObserver

- (void)HTTPLogger:(REDHTTPLogger *)logger didLogNewRequest:(REDHTTPLog *)log
{
    NSMutableArray *mutableLogs = [NSMutableArray arrayWithArray:self.logs];
    [mutableLogs insertObject:log atIndex:0];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.tableView beginUpdates];
    self.logs = [NSArray arrayWithArray:mutableLogs];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

- (void)HTTPLogger:(REDHTTPLogger *)logger didUpdateLog:(REDHTTPLog *)log
{
    NSUInteger row = [self.logs indexOfObject:log];
    if (row != NSNotFound)
    {
        NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
        
        REDHTTPLogTableViewCell *cell = (REDHTTPLogTableViewCell *)[self.tableView cellForRowAtIndexPath:cellIndexPath];
        [cell reloadData];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.logs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const REDCellIdentifier = @"REDCellIdentifier";
    
    REDHTTPLogTableViewCell *cell = (REDHTTPLogTableViewCell *)[tableView dequeueReusableCellWithIdentifier:REDCellIdentifier];
    if (!cell)
    {
        cell = [[REDHTTPLogTableViewCell alloc] initWithReuseIdentifier:REDCellIdentifier];
    }
    
    REDHTTPLog *log = [self.logs objectAtIndex:indexPath.row];
    cell.log = log;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return REDHTTPLogTableViewCellHeight;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    REDHTTPLog *log = [self.logs objectAtIndex:indexPath.row];
    REDHTTPLogDetailsViewController *logDetailsViewController = [[REDHTTPLogDetailsViewController alloc] initWithHTTPLog:log];
    [self presentViewController:logDetailsViewController animated:YES completion:nil];
}

@end
