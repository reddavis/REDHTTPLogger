//
//  REDHTTPLogTableViewCell.h
//  Pods
//
//  Created by Red Davis on 31/03/2015.
//
//

#import <UIKit/UIKit.h>

@class REDHTTPLog;


extern CGFloat const REDHTTPLogTableViewCellHeight;


@interface REDHTTPLogTableViewCell : UITableViewCell

@property (strong, nonatomic) REDHTTPLog *log;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

- (void)reloadData;

@end
