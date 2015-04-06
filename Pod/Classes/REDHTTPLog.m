//
//  REDHTTPLog.m
//  Pods
//
//  Created by Red Davis on 29/03/2015.
//
//

#import "REDHTTPLog.h"

#import <AFNetworking/AFNetworking.h>


@interface REDHTTPLog ()

@property (assign, nonatomic) BOOL requestComplete;
@property (strong, nonatomic) AFHTTPRequestOperation *requestOperation;

@property (copy, nonatomic) NSDate *startTime;
@property (assign, nonatomic) NSTimeInterval responseTime;

@end


@implementation REDHTTPLog

#pragma mark - Initialization

- (instancetype)initWithRequestOperation:(AFHTTPRequestOperation *)requestOperation
{
    self = [self init];
    if (self)
    {
        self.requestOperation = requestOperation;
        self.startTime = [NSDate date];
    }
    
    return self;
}

#pragma mark -

- (void)markAsComplete
{
    self.responseTime = [[NSDate date] timeIntervalSinceDate:self.startTime];
    self.requestComplete = YES;
}

#pragma mark - Request

- (NSURL *)requestURL
{
    return self.requestOperation.request.URL;
}

- (NSString *)HTTPMethod
{
    return [self.requestOperation.request.HTTPMethod copy];
}

- (NSDictionary *)requestHTTPHeaderFields
{
    return [self.requestOperation.request.allHTTPHeaderFields copy];
}

- (NSString *)requestBodyString
{
    NSData *bodyData = self.requestOperation.request.HTTPBody;
    NSString *bodyString = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    
    return bodyString;
}

#pragma mark - Request

- (NSInteger)responseStatusCode
{
    return self.requestOperation.response.statusCode;
}

- (NSString *)responseBodyString
{
    return self.requestOperation.responseString;
}

#pragma mark -

- (NSString *)description
{
    NSMutableString *description = [[NSMutableString alloc] init];
    [description appendFormat:@"--- Request ---\n\n"];
    [description appendFormat:@"HTTP Method: %@\n", self.HTTPMethod];
    [description appendFormat:@"URL: %@\n\n", self.requestURL];
    
    [description appendString:@"HTTP Headers:\n"];
    [description appendFormat:@"%@\n\n", self.requestHTTPHeaderFields];
    
    [description appendString:@"Body:\n"];
    [description appendFormat:@"%@\n\n\n", self.requestBodyString];
    
    [description appendFormat:@"--- Reponse ---\n\n"];
    [description appendFormat:@"Status code: %@\n", @(self.responseStatusCode)];
    [description appendFormat:@"Response Time: %@ seconds\n\n", @(self.responseTime)];
    
    [description appendString:@"Body:\n"];
    [description appendFormat:@"%@\n\n\n", self.responseBodyString];
    
    return description;
}

@end
