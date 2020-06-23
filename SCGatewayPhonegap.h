#import <Cordova/CDV.h>

@interface SCGatewayPhonegap : CDVPlugin
- (void)setConfigEnvironment:(CDVInvokedUrlCommand*)command;
- (void)initSCGateway:(CDVInvokedUrlCommand*)command;
- (void)triggerTransaction:(CDVInvokedUrlCommand*)command;
@end

