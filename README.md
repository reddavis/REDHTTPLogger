# REDHTTPLogger

[![CI Status](http://img.shields.io/travis/Red Davis/REDHTTPLogger.svg?style=flat)](https://travis-ci.org/Red Davis/REDHTTPLogger)
[![Version](https://img.shields.io/cocoapods/v/REDHTTPLogger.svg?style=flat)](http://cocoapods.org/pods/REDHTTPLogger)
[![License](https://img.shields.io/cocoapods/l/REDHTTPLogger.svg?style=flat)](http://cocoapods.org/pods/REDHTTPLogger)
[![Platform](https://img.shields.io/cocoapods/p/REDHTTPLogger.svg?style=flat)](http://cocoapods.org/pods/REDHTTPLogger)

REDHTTPLogger makes it easy to inspect HTTP requests happening inside your iOS app without needed the debugger attached.

### Features
- Integrates with AFNetworking
- Shows state and response time of a request
- Share request log via email, sms etc.

## How To Use

### To Start The Logger

```
#import “REDAppDelegate.h”

#import <REDHTTPLogger/REDHTTPLogger.h>


@implementation REDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
		…

    [[REDHTTPLogger sharedLogger] startLogging];
    
		…
    
    return YES;
}

@end
```

### To Present Logger

```
- (void)someAction:(id)sender
{
    REDHTTPLogsViewController *logsViewController = [[REDHTTPLogsViewController alloc] init];
    UINavigationController *logsNavigationController = [[UINavigationController alloc] initWithRootViewController:logsViewController];
    [self.navigationController presentViewController:logsNavigationController animated:YES completion:nil];
}
```

## Example

[View video](http://up.red.to/smdi0LSdNn)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

REDHTTPLogger is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "REDHTTPLogger"
```

## Author

Red Davis, me@red.to

## License

REDHTTPLogger is available under the MIT license. See the LICENSE file for more info.
