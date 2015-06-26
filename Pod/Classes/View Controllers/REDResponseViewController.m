//
//  REDResponseViewController.m
//  Pods
//
//  Created by Red Davis on 04/04/2015.
//
//

#import "REDResponseViewController.h"
#import <SBJson4/SBJson4.h>

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
        self.responseString = [NSString stringWithFormat:@"<xmp>%@</xmp>", [self humanReadableJSONFromString:responseString]];
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

#pragma mark - Private 

- (NSString *)humanReadableJSONFromString:(NSString *)string
{
	SBJson4Writer *writer = [[SBJson4Writer alloc] init];
	writer.humanReadable = YES;
	writer.sortKeys = YES;
	
	__block NSString *output = nil;

	SBJson4Parser *parser = [SBJson4Parser parserWithBlock:^(id item, BOOL *stop) {
		id data = [writer dataWithObject:item];
		output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	}
											allowMultiRoot:YES
										   unwrapRootArray:NO
											  errorHandler:^(NSError *error) {
		output = error.description;
	}];

	[parser parse:[string dataUsingEncoding:NSUTF8StringEncoding]];
	return output;
}



@end
