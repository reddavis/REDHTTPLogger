//
//  REDResponseViewController.m
//  Pods
//
//  Created by Red Davis on 04/04/2015.
//
//

#import "REDResponseViewController.h"


@interface REDResponseViewController ()

@property (copy, nonatomic) NSString *responseString;
@property (strong, nonatomic) UIWebView *webView;

@end


@implementation REDResponseViewController

#pragma mark - Initialization

- (instancetype)initWithResponseString:(NSString *)responseString
{
    self = [self init];
    if (self)
    {
        self.responseString = [NSString stringWithFormat:@"<xmp>%@</xmp>", responseString];
    }
    
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] init];
    [self.view addSubview:self.webView];
    
    [self.webView loadHTMLString:self.responseString baseURL:nil];
}

- (void)viewDidLayoutSubviews
{
    CGRect bounds = self.view.bounds;
    self.webView.frame = bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
