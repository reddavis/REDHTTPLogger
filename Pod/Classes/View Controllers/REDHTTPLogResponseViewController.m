//
//  REDHTTPLogResponseViewController.m
//  Pods
//
//  Created by Red Davis on 31/03/2015.
//
//

#import "REDHTTPLogResponseViewController.h"
#import "REDHTTPLog.h"
#import "REDResponseViewController.h"

#import <AFNetworking/AFHTTPRequestOperation.h>


@interface REDHTTPLogResponseViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) REDHTTPLog *HTTPLog;
@property (strong, nonatomic) UITableView *tableView;

- (void)doneButtonTapped:(id)sender;

@end


typedef NS_ENUM(NSUInteger, REDTableSection)
{
    REDTableSectionStatusCode = 0,
    REDTableSectionResponseTime,
    REDTableSectionBody
};


@implementation REDHTTPLogResponseViewController

#pragma mark - Initialization

- (instancetype)initWithHTTPLog:(REDHTTPLog *)HTTPLog
{
    self = [super init];
    if (self)
    {
        self.title = @"Response";
        self.HTTPLog = HTTPLog;
    }
    
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger numberOfRows = 0;
    switch (section)
    {
        case REDTableSectionStatusCode:
            numberOfRows = 1;
            break;
        case REDTableSectionResponseTime:
            numberOfRows = 1;
            break;
        case REDTableSectionBody:
            numberOfRows = 1;
            break;
        default:
            break;
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const REDDefaultCellIdentifier = @"REDDefaultCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REDDefaultCellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:REDDefaultCellIdentifier];
    }
    
    switch (indexPath.section)
    {
        case REDTableSectionStatusCode:
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", @(self.HTTPLog.responseStatusCode)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        case REDTableSectionResponseTime:
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", @(self.HTTPLog.responseTime)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        case REDTableSectionBody:
        {
            cell.textLabel.text = @"Body";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
            
        default:
            break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header = nil;
    switch (section)
    {
        case REDTableSectionStatusCode:
            header = @"Status Code";
            break;
        case REDTableSectionResponseTime:
            header = @"Response Time";
            break;
        default:
            break;
    }
    
    return header;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == REDTableSectionBody)
    {
        REDResponseViewController *responseViewController = [[REDResponseViewController alloc] initWithResponseString:self.HTTPLog.responseBodyString];
        [self.navigationController pushViewController:responseViewController animated:YES];
    }
}

@end
