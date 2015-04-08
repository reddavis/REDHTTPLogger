//
//  REDHTTPLog.m
//  Pods
//
//  Created by Red Davis on 29/03/2015.
//
//

#import "REDHTTPLog.h"


@interface REDHTTPLog ()

@property (assign, nonatomic) BOOL requestComplete;
@property (strong, nonatomic) NSURLRequest *request;
@property (strong, nonatomic) NSHTTPURLResponse *response;
@property (copy, nonatomic) NSString *responseBodyString;

@property (copy, nonatomic) NSDate *startTime;
@property (assign, nonatomic) NSTimeInterval responseTime;

@end


@implementation REDHTTPLog

#pragma mark - Initialization

- (instancetype)initWithRequest:(NSURLRequest *)request
{
    self = [self init];
    if (self)
    {
        self.request = request;
        self.startTime = [NSDate date];
    }
    
    return self;
}

#pragma mark -

- (void)markAsCompleteWithResponse:(NSHTTPURLResponse *)response responseBodyString:(NSString *)bodyString
{
    self.response = response;
    self.responseTime = [[NSDate date] timeIntervalSinceDate:self.startTime];
    self.requestComplete = YES;
    self.responseBodyString = bodyString;
}

#pragma mark - Request

- (NSURL *)requestURL
{
    return self.request.URL;
}

- (NSString *)HTTPMethod
{
    return [self.request.HTTPMethod copy];
}

- (NSDictionary *)requestHTTPHeaderFields
{
    return [self.request.allHTTPHeaderFields copy];
}

- (NSString *)requestBodyString
{
    NSData *bodyData = self.request.HTTPBody;
    NSString *bodyString = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    
    return bodyString;
}

#pragma mark - Request

- (NSInteger)responseStatusCode
{
    return self.response.statusCode;
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
