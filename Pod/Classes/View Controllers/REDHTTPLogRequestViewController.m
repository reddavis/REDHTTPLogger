//
//  REDHTTPLogRequestViewController.m
//  Pods
//
//  Created by Red Davis on 31/03/2015.
//
//

#import "REDHTTPLogRequestViewController.h"
#import "REDHTTPLog.h"
#import "REDResponseViewController.h"


@interface REDHTTPLogRequestViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) REDHTTPLog *HTTPLog;
@property (strong, nonatomic) NSURLRequest *request;
@property (strong, nonatomic) UITableView *tableView;

- (void)doneButtonTapped:(id)sender;

@end


typedef NS_ENUM(NSUInteger, REDTableSection)
{
    REDTableSectionDetails = 0,
    REDTableSectionHeaders,
    REDTableSectionBody
};

typedef NS_ENUM(NSUInteger, REDTableDetailsRow)
{
    REDTableDetailsRowMethod = 0,
    REDTableDetailsRowBaseURL,
    REDTableDetailsRowPath
};


@implementation REDHTTPLogRequestViewController

#pragma mark - Initialization

- (instancetype)initWithHTTPLog:(REDHTTPLog *)log
{
    self = [super init];
    if (self)
    {
        self.title = @"Request";
        self.HTTPLog = log;
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
        case REDTableSectionDetails:
            numberOfRows = 3;
            break;
        case REDTableSectionHeaders:
            numberOfRows = self.HTTPLog.requestHTTPHeaderFields.count;
            break;
        case REDTableSectionBody:
            numberOfRows = self.HTTPLog.requestBodyString ? 1 : 0;
            break;
        default:
            break;
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == REDTableSectionBody)
    {
        static NSString *const REDCellDefaultIdentifier = @"REDCellDefaultIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:REDCellDefaultIdentifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:REDCellDefaultIdentifier];
        }
        
        cell.textLabel.text = @"Body";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        static NSString *const REDCellIdentifier = @"REDCellIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:REDCellIdentifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:REDCellIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        switch (indexPath.section)
        {
            case REDTableSectionDetails:
            {
                switch (indexPath.row)
                {
                    case REDTableDetailsRowMethod:
                        cell.textLabel.text = @"Method";
                        cell.detailTextLabel.text = self.HTTPLog.HTTPMethod;
                        break;
                    case REDTableDetailsRowBaseURL:
                        cell.textLabel.text = @"Base URL";
                        cell.detailTextLabel.text = self.HTTPLog.requestURL.host;
                        break;
                    case REDTableDetailsRowPath:
                        cell.textLabel.text = @"Path";
                        cell.detailTextLabel.text = self.HTTPLog.requestURL.path;
                        break;
                    default:
                        break;
                }
                
                break;
            }
            case REDTableSectionHeaders:
            {
                NSDictionary *headers = self.HTTPLog.requestHTTPHeaderFields;
                NSArray *sortedKeys = [headers.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
                
                NSString *key = [sortedKeys objectAtIndex:indexPath.row];
                NSString *value = [headers objectForKey:key];
                
                cell.textLabel.text = key;
                cell.detailTextLabel.text = value;
                
                break;
            }
                
            default:
                break;
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header = nil;
    switch (section)
    {
        case REDTableSectionHeaders:
            header = @"Headers";
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
        REDResponseViewController *responseViewController = [[REDResponseViewController alloc] initWithResponseString:self.HTTPLog.requestBodyString];
        [self.navigationController pushViewController:responseViewController animated:YES];
    }
}

@end
