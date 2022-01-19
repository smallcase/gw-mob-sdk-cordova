#import <Cordova/CDV.h>

@interface SCGatewayPhonegap : CDVPlugin
- (void)setConfigEnvironment:(CDVInvokedUrlCommand*)command;
- (void)initSCGateway:(CDVInvokedUrlCommand*)command;
- (void)triggerTransaction:(CDVInvokedUrlCommand*)command;
- (void)triggerLeadGen:(CDVInvokedUrlCommand*)command;
- (void)logout:(CDVInvokedUrlCommand*)command;
- (void)launchSmallplug:(CDVInvokedUrlCommand*)command;
@end

