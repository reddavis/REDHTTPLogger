//
//  REDHTTPLog.h
//  Pods
//
//  Created by Red Davis on 29/03/2015.
//
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPRequestOperation.h>


@interface REDHTTPLog : NSObject

@property (strong, nonatomic, readonly) AFHTTPRequestOperation *requestOperation;
@property (assign, nonatomic, readonly) BOOL requestComplete;

// Request
@property (copy, nonatomic, readonly) NSURL *requestURL;
@property (copy, nonatomic, readonly) NSString *HTTPMethod;
@property (copy, nonatomic, readonly) NSDictionary *requestHTTPHeaderFields;
@property (copy, nonatomic, readonly) NSString *requestBodyString;

// Response
@property (assign, nonatomic, readonly) NSInteger responseStatusCode;
@property (assign, nonatomic, readonly) NSTimeInterval responseTime;
@property (copy, nonatomic, readonly) NSString *responseBodyString;

- (instancetype)initWithRequestOperation:(AFHTTPRequestOperation *)requestOperation;

- (void)markAsComplete;

@end
