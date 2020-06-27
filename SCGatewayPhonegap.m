

#import "SCGatewayPhonegap.h"
#import <SCGateway/SCGateway.h>
#import <Cordova/CDV.h>
#import <SCGateway/SCGateway-Swift.h>


@implementation SCGatewayPhonegap

-(void)triggerTransaction:(CDVInvokedUrlCommand*)command{
    NSLog(@"transaction triggered");
        __block CDVPluginResult *pluginResult = nil;
        NSString *tranxId = [command.arguments objectAtIndex:0];
      [SCGateway.shared triggerTransactionFlowWithTransactionId: tranxId presentingController:[[[UIApplication sharedApplication] keyWindow] rootViewController] completion:^(id response, NSError * error) {
        
        
        if (error != nil) {
            NSLog(@"%@", error.domain);
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
            [responseDict setValue:[NSNumber numberWithBool:false] forKey:@"success"];
            [responseDict setValue:[NSNumber numberWithInteger:error.code]  forKey:@"errorCode"];
            [responseDict setValue:error.domain  forKey:@"error"];
             [responseDict setValue:@"ERROR"  forKey:@"transaction"];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:responseDict];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            });
            
        }
        
        if ([response isKindOfClass: [ObjcTransactionIntentTransaction class]]) {
    
            ObjcTransactionIntentTransaction *trxResponse = response ;
    
            NSLog(@"response: %@", trxResponse.transaction);
             //Decode Base64 encoded string response
            NSData *decodedStringData = [[NSData alloc] initWithBase64EncodedString:trxResponse.transaction options: 0];
            NSString *decodedResponse = [[NSString alloc] initWithData:decodedStringData encoding:1];
            NSMutableDictionary *dict=[NSJSONSerialization JSONObjectWithData:[decodedResponse dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
            //[dict setValue:tranxId  forKey:@"transactionId"];
            NSMutableDictionary *responseData = [NSDictionary dictionaryWithObjectsAndKeys:dict , @"data", trxResponse.authToken , @"smallcaseAuthToken", nil];
            NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
            [responseDict setValue:responseData  forKey:@"data"];
            [responseDict setValue:@"TRANSACTION"  forKey:@"transaction"];
            [responseDict setValue:[NSNumber numberWithBool:true] forKey:@"success"];
            NSLog(@"Decoded response %@", decodedResponse);
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:responseDict];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            });
        } else if([response isKindOfClass: [ObjCTransactionIntentConnect class]]) {
            ObjCTransactionIntentConnect *res = response;
            NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
            [responseDict setValue:@"CONNECT"  forKey:@"transaction"];
            [responseDict setValue:[NSNumber numberWithBool:true] forKey:@"success"];
            if (res.authToken != nil)
            {
                 [responseDict setValue:res.authToken forKey:@"data"];
            }
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:responseDict];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            });
        } else if([response isKindOfClass: [ObjcTransactionIntentHoldingsImport class]]) {
            ObjcTransactionIntentHoldingsImport *trxResponse = response ;
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue: trxResponse.authToken  forKey:@"smallcaseAuthToken"];
            [dict setValue:[NSNumber numberWithBool:true] forKey:@"success"];
            //[dict setValue:tranxId forKey:@"transactionId"];
            NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
            [responseDict setValue:@"HOLDING_IMPORT"  forKey:@"transaction"];
            [responseDict setValue:[NSNumber numberWithBool:true] forKey:@"success"];
            [responseDict setValue:dict forKey:@"data"];
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:responseDict];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            });
        }

    }];
}
-(void)initSDK:(CDVInvokedUrlCommand*)command{
    __block CDVPluginResult *pluginResult = nil;
         NSString *authToken = [command.arguments objectAtIndex:0];
         NSLog(@"SdkToken %@", authToken);
     [SCGateway.shared initializeGatewayWithSdkToken:authToken completion:^( BOOL success, NSError * error) {
                     if(success){
                         NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
                        [responseDict setValue:[NSNumber numberWithBool:true] forKey:@"success"];
                        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:responseDict];
                        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                     } else {
                         NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
                        [responseDict setValue:[NSNumber numberWithBool:false] forKey:@"success"];
                        if(error != nil)
                        {
                            [responseDict setValue:[NSNumber numberWithInteger:error.code]  forKey:@"errorCode"];
                        [responseDict setValue:error.domain  forKey:@"error"];
                        }
                        
                        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:responseDict];
                        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                     }
                 }];

                 
}

- (void)setConfigEnvironment:(CDVInvokedUrlCommand*)command{
NSLog(@"init Called Ios");
NSString  *environmentStr = [command.arguments objectAtIndex:0];
NSString *gatewayName = [command.arguments objectAtIndex:1];
BOOL isLeprechaun = [[command.arguments objectAtIndex:2] boolValue];
NSInteger environment = EnvironmentProduction;
NSArray *brokerConfig = nil;
//NSLog(@"isLeprechaun %@",[command.arguments objectAtIndex:2]);
NSLog(isLeprechaun ? @"true" : @"false");
@try {
    brokerConfig = [command.arguments objectAtIndex:3];
}
@catch (NSException *exception) {

}

if([environmentStr isEqualToString:@"production"]) {
        environment = EnvironmentProduction;
       }
else if([environmentStr isEqualToString:@"development"]) {
       environment = EnvironmentDevelopment;
       } else {
        environment = EnvironmentStaging;
       }
GatewayConfig *config = [[GatewayConfig alloc] initWithGatewayName:gatewayName brokerConfig:brokerConfig  apiEnvironment:environment isLeprechaunActive: isLeprechaun ? true : false];
[SCGateway.shared setupWithConfig:config ];
            double delayInSeconds = 1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId]; 
            });

}
@end