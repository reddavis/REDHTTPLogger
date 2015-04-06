//
//  REDHTTPLogger.h
//  Pods
//
//  Created by Red Davis on 29/03/2015.
//
//

#import <Foundation/Foundation.h>
#import "REDHTTPLog.h"


@protocol REDHTTPLoggerObserver;


@interface REDHTTPLogger : NSObject

@property (copy, nonatomic, readonly) NSArray *logs;
@property (assign, nonatomic) NSUInteger maximumNumberOfLogs;

+ (instancetype)sharedLogger;

- (void)startLogging;
- (void)stopLogging;

- (void)addObserver:(id<REDHTTPLoggerObserver>)observer;
- (void)removeObserver:(id<REDHTTPLoggerObserver>)observer;

@end


@protocol REDHTTPLoggerObserver <NSObject>
- (void)HTTPLogger:(REDHTTPLogger *)logger didLogNewRequest:(REDHTTPLog *)log;
- (void)HTTPLogger:(REDHTTPLogger *)logger didUpdateLog:(REDHTTPLog *)log;
@end
