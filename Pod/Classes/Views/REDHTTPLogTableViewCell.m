//
//  REDHTTPLogTableViewCell.m
//  Pods
//
//  Created by Red Davis on 31/03/2015.
//
//

#import "REDHTTPLogTableViewCell.h"
#import "REDHTTPLog.h"


@interface REDHTTPLogTableViewCell ()

@property (strong, nonatomic) UILabel *baseURLLabel;

- (UILabel *)constructLabelWithStatusCode:(NSInteger)statusCode;

@end


CGFloat const REDHTTPLogTableViewCellHeight = 50.0;


@implementation REDHTTPLogTableViewCell

#pragma mark - Initialize

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [self initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.baseURLLabel = [[UILabel alloc] init];
        self.baseURLLabel.font = self.detailTextLabel.font;
        [self.contentView addSubview:self.baseURLLabel];
    }
    
    return self;
}

#pragma mark - View Setup

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect detailLabelFrame = self.detailTextLabel.frame;
    self.baseURLLabel.frame = CGRectMake(CGRectGetMaxX(detailLabelFrame) + 10.0, detailLabelFrame.origin.y, 0.0, 0.0);
    [self.baseURLLabel sizeToFit];
}

#pragma mark -

- (void)reloadData
{
    NSURLRequest *request = self.log.request;
    self.textLabel.text = request.URL.path;
    self.detailTextLabel.text = request.HTTPMethod;
    self.baseURLLabel.text = request.URL.host;
    
    if (self.log.requestComplete)
    {
        UILabel *label = [self constructLabelWithStatusCode:self.log.responseStatusCode];
        [label sizeToFit];
        
        self.accessoryView = label;
    }
    else
    {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.accessoryView = spinner;
        [spinner startAnimating];
    }
    
    [self layoutSubviews];
}

- (void)prepareForReuse
{
    self.log = nil;
}

#pragma mark - Helpers

- (UILabel *)constructLabelWithStatusCode:(NSInteger)statusCode
{
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"%@", @(statusCode)];
    label.textColor = statusCode == 200 ? [UIColor greenColor] : [UIColor redColor];
    
    return label;
}

#pragma mark -

- (void)setLog:(REDHTTPLog *)log
{
    if (_log == log)
        return;
    
    _log = log;
    [self reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
