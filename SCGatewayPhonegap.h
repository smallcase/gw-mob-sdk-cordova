#import <Cordova/CDV.h>

@interface SCGatewayPhonegap : CDVPlugin
- (void)setConfigEnvironment:(CDVInvokedUrlCommand*)command;
- (void)initSCGateway:(CDVInvokedUrlCommand*)command;
- (void)triggerTransaction:(CDVInvokedUrlCommand*)command;
- (void)triggerLeadGen:(CDVInvokedUrlCommand*)command;
- (void)triggerLeadGenWithStatus:(CDVInvokedUrlCommand*)command;
- (void)logout:(CDVInvokedUrlCommand*)command;
- (void)launchSmallplug:(CDVInvokedUrlCommand*)command;
- (void)setCordovaSdkVersion:(CDVInvokedUrlCommand*)command;
- (void)showOrders:(CDVInvokedUrlCommand*)command;
- (void)isUserConnected:(CDVInvokedUrlCommand*)command;
@end

