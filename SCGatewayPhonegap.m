

#import "SCGatewayPhonegap.h"
#import <SCGateway/SCGateway.h>
#import <Cordova/CDV.h>

@implementation SCGatewayPhonegap

– (void)init:(CDVInvokedUrlCommand*)command{
NSLog(@"init Called Ios");
/*NSMutableDictionary* options = [command.arguments objectAtIndex:0];
NSString* appToken = [options objectForKey:@”iosToken”];
[Instabug startWithToken:appToken captureSource:IBGCaptureSourceUIKit invocationEvent:IBGInvocationEventShake];

CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@”Initialization successful”];
[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];*/

}

/*– (void)invoke:(CDVInvokedUrlCommand*)command{
[Instabug invoke];

CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

– (void)invokeBugReporter:(CDVInvokedUrlCommand*)command{
[Instabug invokeBugReporter];

CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

– (void)invokeFeedbackSender:(CDVInvokedUrlCommand*)command{
[Instabug invokeFeedbackSender];

CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
*/
@end