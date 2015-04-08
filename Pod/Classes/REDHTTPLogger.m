//
//  REDHTTPLogger.m
//  Pods
//
//  Created by Red Davis on 29/03/2015.
//
//

#import "REDHTTPLogger.h"
#import "REDHTTPLog.h"

#import <AFNetworking/AFNetworking.h>


@interface REDHTTPLogger ()

@property (strong, nonatomic) NSMutableArray *mutableLogs;
@property (strong, nonatomic) NSMutableSet *observers;

- (REDHTTPLog *)findLogWithRequest:(NSURLRequest *)request;

- (void)networkingOperationDidStartNotification:(NSNotification *)notification;
- (void)networkingOperationDidFinishNotification:(NSNotification *)notification;

@end


static NSURLRequest *requestFromNotificationObject(id object)
{
    NSURLRequest *request = nil;
    if ([object respondsToSelector:@selector(originalRequest)])
    {
        request = [object originalRequest];
    }
    else if ([object respondsToSelector:@selector(request)])
    {
        request = [object request];
    }
    
    return request;
}


static NSString *responseStringFromNotification(NSNotification *notification)
{
    NSString *responseString = nil;
    if ([notification.object respondsToSelector:@selector(responseString)])
    {
        responseString = [notification.object responseString];
    }
    else if (notification.userInfo) {
        responseString = notification.userInfo[AFNetworkingTaskDidCompleteSerializedResponseKey];
    }
    
    return responseString;
}


@implementation REDHTTPLogger

#pragma mark -

+ (instancetype)sharedLogger
{
    static REDHTTPLogger *sharedLogger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLogger = [[REDHTTPLogger alloc] init];
    });
    
    return sharedLogger;
}

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.mutableLogs = [NSMutableArray array];
        self.observers = [NSMutableSet set];
        self.maximumNumberOfLogs = 100;
    }
    
    return self;
}

- (void)dealloc
{
    [self stopLogging];
}

#pragma mark -

- (NSArray *)logs
{
    return [NSArray arrayWithArray:self.mutableLogs];
}

#pragma mark -

- (void)startLogging
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkingOperationDidStartNotification:) name:AFNetworkingOperationDidStartNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkingOperationDidFinishNotification:) name:AFNetworkingOperationDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkingOperationDidStartNotification:) name:AFNetworkingTaskDidResumeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkingOperationDidFinishNotification:) name:AFNetworkingTaskDidCompleteNotification object:nil];
}

- (void)stopLogging
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Observers

- (void)addObserver:(id<REDHTTPLoggerObserver>)observer
{
    [self.observers addObject:observer];
}

- (void)removeObserver:(id<REDHTTPLoggerObserver>)observer
{
    [self.observers removeObject:observer];
}

#pragma mark - Helpers

- (REDHTTPLog *)findLogWithRequest:(NSURLRequest *)request
{
    REDHTTPLog *log = nil;
    NSArray *recordedLogs = [NSArray arrayWithArray:self.logs];
    
    for (REDHTTPLog *recordedLog in recordedLogs)
    {
        if (recordedLog.request == request)
        {
            log = recordedLog;
            break;
        }
    }
    
    return log;
}

#pragma mark - Notifications

- (void)networkingOperationDidStartNotification:(NSNotification *)notification
{
    NSURLRequest *request = requestFromNotificationObject(notification.object);
    if (!request)
    {
        return;
    }
    
    REDHTTPLog *log = [[REDHTTPLog alloc] initWithRequest:request];
    [self.mutableLogs addObject:log];
    
    if (self.mutableLogs.count > self.maximumNumberOfLogs)
    {
        [self.mutableLogs removeObjectAtIndex:0];
    }
    
    NSSet *observers = [NSSet setWithSet:self.observers];
    for (id<REDHTTPLoggerObserver> observer in observers)
    {
        [observer HTTPLogger:self didLogNewRequest:log];
    }
}

- (void)networkingOperationDidFinishNotification:(NSNotification *)notification
{
    NSURLResponse *response = nil;
    id object = notification.object;
    if ([object respondsToSelector:@selector(response)])
    {
        response = [object response];
    }
    else
    {
        return;
    }
    
    NSURLRequest *request = requestFromNotificationObject(notification.object);
    REDHTTPLog *log = [self findLogWithRequest:request];
    
    NSString *responseString = responseStringFromNotification(notification);
    [log markAsCompleteWithResponse:response responseBodyString:responseString];
    
    NSSet *observers = [NSSet setWithSet:self.observers];
    for (id<REDHTTPLoggerObserver> observer in observers)
    {
        [observer HTTPLogger:self didUpdateLog:log];
    }
}

@end
