

#import "SCGatewayPhonegap.h"
#import <SCGateway/SCGateway.h>
#import <Cordova/CDV.h>
#import <SCGateway/SCGateway-Swift.h>


@implementation SCGatewayPhonegap

- (void)setCordovaSdkVersion:(CDVInvokedUrlCommand*)command{
    NSLog(@"setting SDK version");
    
    [SCGateway.shared setSDKTypeWithType:@"cordova"];
    
    NSString *versionString = [command.arguments objectAtIndex:0];
    [SCGateway.shared setHybridSDKVersionWithVersion: versionString];
}

-(void)getSdkVersion:(CDVInvokedUrlCommand*)command {
    
    __block CDVPluginResult *pluginResult = nil;
    
    NSString *nativeSdkString = [NSString stringWithFormat: @"ios:%@", [SCGateway.shared getSdkVersion]];
    NSString *cordovaSdkString = [NSString stringWithFormat: @",cordova:%@", [command.arguments objectAtIndex:0]];
    
    NSString *result = [nativeSdkString stringByAppendingString: cordovaSdkString];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void)isUserConnected:(CDVInvokedUrlCommand *)command {
    
    __block CDVPluginResult *pluginResult = nil;
    
    BOOL isUserConneced = [SCGateway.shared isUserConnected];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:isUserConneced];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void)triggerTransaction:(CDVInvokedUrlCommand*)command{
    NSLog(@"transaction triggered");
        __block CDVPluginResult *pluginResult = nil;
        NSString *tranxId = [command.arguments objectAtIndex:0];
      [SCGateway.shared triggerTransactionFlowWithTransactionId: tranxId presentingController:[[[UIApplication sharedApplication] keyWindow] rootViewController] completion:^(id response, NSError * error) {
        
        
        if (error != nil) {
            NSLog(@"%@", error.domain);
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
            [responseDict setValue:[NSNumber numberWithBool:false] forKey:@"success"];
            [responseDict setValue:[NSNumber numberWithInteger:error.code]  forKey:@"errorCode"];
            [responseDict setValue:error.domain  forKey:@"error"];
            [responseDict setValue:[error.userInfo objectForKey: @"data"] forKey:@"data"];
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
            
            NSMutableDictionary *responseDict =  [[NSMutableDictionary alloc] init]; 
            [responseDict setObject:dict forKey:@"data"];
            [responseDict setValue:[NSNumber numberWithBool:true] forKey:@"success"];
            [responseDict setObject:@"TRANSACTION"  forKey:@"transaction"];
            //[dict setValue:tranxId  forKey:@"transactionId"];
            // NSMutableDictionary *responseData = [NSDictionary dictionaryWithObjectsAndKeys:dict , @"data", nil];
            // [responseData setValue:@"TRANSACTION"  forKey:@"transaction"];
            // [responseData setValue:[NSNumber numberWithBool:true] forKey:@"success"];
            NSLog(@"Decoded response %@", decodedResponse);
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:responseDict];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            });
        } 
        // Handle ObjcMfTransactionIntentTransaction
        else if ([response isKindOfClass: [ObjcMfTransactionIntentTransaction class]]) {
            ObjcMfTransactionIntentTransaction *trxResponse = response;
            NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
            [responseDict setValue:@"MF_TRANSACTION" forKey:@"transaction"];
            [responseDict setValue:[NSNumber numberWithBool:true] forKey:@"success"];
            [responseDict setValue:trxResponse.data forKey:@"data"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:responseDict];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            });
        }
        // Handle ObjCTransactionIntentOnboarding
        else if([response isKindOfClass: [ObjCTransactionIntentOnboarding class]]) {
            ObjCTransactionIntentOnboarding *trxResponse = response;
            NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
            [responseDict setValue:@"ONBOARDING" forKey:@"transaction"];
            [responseDict setValue:[NSNumber numberWithBool:true] forKey:@"success"];
            if (trxResponse.response != nil) {
                [responseDict setValue:trxResponse.response forKey:@"data"];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:responseDict];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            });
        }
        
        else if([response isKindOfClass: [ObjCTransactionIntentConnect class]]) {
            ObjCTransactionIntentConnect *res = response;
            NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
            [responseDict setValue:@"CONNECT"  forKey:@"transaction"];
            [responseDict setValue:[NSNumber numberWithBool:true] forKey:@"success"];
            if (res.response != nil) {
                 [responseDict setValue:res.response forKey:@"data"];
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
            [dict setValue: trxResponse.transactionId forKey:@"transactionId"];
            [dict setValue: trxResponse.broker forKey:@"broker"];
            [dict setValue: trxResponse.signup forKey:@"signup"];
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
        //MARK: intent - mf holdings import
        else if ([response isKindOfClass: [ObjCTransactionIntentMfHoldingsImport class]]) {
            ObjCTransactionIntentMfHoldingsImport *trxResponse = response;
            NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
            [responseDict setValue:[NSNumber numberWithBool:true] forKey:@"success"];
            [responseDict setValue:@"MF_HOLDINGS_IMPORT" forKey:@"transaction"];
            if (trxResponse.data != nil && trxResponse.data.length > 0) {
                [responseDict setObject:trxResponse.data forKey:@"data"];
            } else {
                [responseDict setObject:@"" forKey:@"data"];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:responseDict];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            });
        }

    }];
}

//MARK: Trigger Mf Transaction
-(void)triggerMfTransaction:(CDVInvokedUrlCommand*)command {
     NSLog(@"transaction triggered");
    __block CDVPluginResult *pluginResult = nil;
    NSString *transactionId = [command.arguments objectAtIndex:0];
    [SCGateway.shared
         triggerMfTransactionWithPresentingController:
         [[[UIApplication sharedApplication] keyWindow] rootViewController]
         transactionId: transactionId
         completion: ^(id response, NSError *error) {
                if (error != nil) {
                    NSLog(@"%@", error.domain);
                double delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
                [responseDict setValue:[NSNumber numberWithBool:false] forKey:@"success"];
                [responseDict setValue:[NSNumber numberWithInteger:error.code]  forKey:@"errorCode"];
                [responseDict setValue:error.domain  forKey:@"error"];
                [responseDict setValue:[error.userInfo objectForKey: @"data"] forKey:@"data"];
                [responseDict setValue:@"ERROR"  forKey:@"transaction"];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:responseDict];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                });
            }

            //MARK: intent - mf transaction
            if ([response isKindOfClass: [ObjCTransactionIntentMfHoldingsImport class]]) {
                NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
                ObjCTransactionIntentMfHoldingsImport *trxResponse = response;
                NSData *decodedStringData = [[NSData alloc] initWithBase64EncodedString:trxResponse.data options: 0];
                NSString *decodedResponse = [[NSString alloc] initWithData:decodedStringData encoding:1];
                NSMutableDictionary *dict=[NSJSONSerialization JSONObjectWithData:[trxResponse.data dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
                [responseDict setObject:dict forKey:@"data"];
                [responseDict setValue:[NSNumber numberWithBool:true] forKey:@"success"];
                [responseDict setObject:@"TRANSACTION"  forKey:@"transaction"];
                [responseDict setObject:@"TRANSACTION"  forKey:@"transaction"];

                [responseDict setObject:trxResponse.data forKey:@"data"];
                NSLog(@"Decoded response %@", decodedResponse);
                NSLog(@"TrxResponse data %@", trxResponse.data);
                double delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:responseDict];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            });
                return;
            }
         }];

                 }

- (void)launchSmallplug:(CDVInvokedUrlCommand *)command {
    __block CDVPluginResult *pluginResult = nil;
    
    NSString  *targetEndpoint = [command.arguments objectAtIndex:0];
    NSString *params = [command.arguments objectAtIndex:1];
    
    SmallplugData *smallplugData = [[SmallplugData alloc] init:targetEndpoint :params];
    
    [SCGateway.shared launchSmallPlugWithPresentingController:[[[UIApplication sharedApplication] keyWindow] rootViewController] smallplugData:smallplugData completion:^(id smallplugResponse, NSError * error) {
        
        NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
        
        if (error != nil) {
            NSLog(@"%@", error.domain);
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
                [responseDict setValue:[NSNumber numberWithBool:false] forKey:@"success"];
                [responseDict setValue:[NSNumber numberWithInteger:error.code]  forKey:@"errorCode"];
                [responseDict setValue:error.domain  forKey:@"error"];
                
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:responseDict];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            });
        } else {
            
            if ([smallplugResponse isKindOfClass:[SmallPlugResult class]]) {
                SmallPlugResult *result = (SmallPlugResult *)smallplugResponse;
                
                [responseDict setValue:[NSNumber numberWithBool:true] forKey:@"success"];
                
                if (result.smallcaseAuthToken) {
                    [responseDict setValue:result.smallcaseAuthToken forKey:@"smallcaseAuthToken"];
                }
                
                NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
                if (result.userInfo) {
                    NSMutableDictionary *userInfoDict = [[NSMutableDictionary alloc] init];
                    if (result.userInfo.number) {
                        [userInfoDict setValue:result.userInfo.number forKey:@"number"];
                    }
                    if (result.userInfo.countryCode) {
                        [userInfoDict setValue:result.userInfo.countryCode forKey:@"countryCode"];
                    }
                    [dataDict setValue:userInfoDict forKey:@"userInfo"];
                }
                
                if ([dataDict count] > 0) {
                    [responseDict setValue:dataDict forKey:@"data"];
                }
                
                double delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                    
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:responseDict];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                    
                });
            }
        }
        
    }];
}

- (void)launchSmallplugWithBranding:(CDVInvokedUrlCommand *)command {
    __block CDVPluginResult *pluginResult = nil;
    
    NSString  *targetEndpoint = [command.arguments objectAtIndex:0];
    NSString *params = [command.arguments objectAtIndex:1];
    NSString *headerColor = [command.arguments objectAtIndex:2];
    NSNumber *headerOpacity = [command.arguments objectAtIndex:3];
    NSString *backIconColor = [command.arguments objectAtIndex:4];
    NSNumber *backIconOpacity = [command.arguments objectAtIndex:5];
    
    SmallplugData *smallplugData = [[SmallplugData alloc] init:targetEndpoint :params];
    SmallplugUiConfig *smallplugUiConfig = [[SmallplugUiConfig alloc] initWithSmallplugHeaderColor:headerColor headerColorOpacity:headerOpacity backIconColor:backIconColor backIconColorOpacity:backIconOpacity];
    
    
    [SCGateway.shared launchSmallPlugWithPresentingController:[[[UIApplication sharedApplication] keyWindow] rootViewController] smallplugData:smallplugData smallplugUiConfig: smallplugUiConfig completion:^(id smallplugResponse, NSError * error) {
        
        NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
        
        if (error != nil) {
            NSLog(@"%@", error.domain);
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
                [responseDict setValue:[NSNumber numberWithBool:false] forKey:@"success"];
                [responseDict setValue:[NSNumber numberWithInteger:error.code]  forKey:@"errorCode"];
                [responseDict setValue:error.domain  forKey:@"error"];
                
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:responseDict];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            });
        } else {
            
            if ([smallplugResponse isKindOfClass:[SmallPlugResult class]]) {
                SmallPlugResult *result = (SmallPlugResult *)smallplugResponse;
                
                [responseDict setValue:[NSNumber numberWithBool:true] forKey:@"success"];
                
                if (result.smallcaseAuthToken) {
                    [responseDict setValue:result.smallcaseAuthToken forKey:@"smallcaseAuthToken"];
                }
                
                NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
                if (result.userInfo) {
                    NSMutableDictionary *userInfoDict = [[NSMutableDictionary alloc] init];
                    if (result.userInfo.number) {
                        [userInfoDict setValue:result.userInfo.number forKey:@"number"];
                    }
                    if (result.userInfo.countryCode) {
                        [userInfoDict setValue:result.userInfo.countryCode forKey:@"countryCode"];
                    }
                    [dataDict setValue:userInfoDict forKey:@"userInfo"];
                }
                
                if ([dataDict count] > 0) {
                    [responseDict setValue:dataDict forKey:@"data"];
                }
                
                double delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                    
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:responseDict];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                    
                });
            }
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
 __block CDVPluginResult *pluginResult = nil;
NSString  *environmentStr = [command.arguments objectAtIndex:0];
NSString *gatewayName = [command.arguments objectAtIndex:1];
BOOL isLeprechaun = [[command.arguments objectAtIndex:2] boolValue];
BOOL isAmoEnabled = YES;//[[command.arguments objectAtIndex:3] boolValue];
NSInteger environment = EnvironmentProduction;
NSArray *brokerConfig = nil;
//NSLog(@"isLeprechaun %@",[command.arguments objectAtIndex:2]);
NSLog(isLeprechaun ? @"true" : @"false");
@try {
    if([[command.arguments objectAtIndex:3] isKindOfClass:[NSArray class]]){
        brokerConfig = [command.arguments objectAtIndex:3];
    }
    
}
@catch (NSException *exception) {

}

@try {
    if([[command.arguments objectAtIndex:3] isKindOfClass:[NSArray class]]){
        BOOL newBOOl = [[command.arguments objectAtIndex:4] boolValue];
       isAmoEnabled = newBOOl;
    } else {
        BOOL newBOOl = [[command.arguments objectAtIndex:3] boolValue];
        isAmoEnabled = newBOOl;
    }
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
GatewayConfig *config = [[GatewayConfig alloc] initWithGatewayName:gatewayName brokerConfig:brokerConfig  apiEnvironment:environment isLeprechaunActive: isLeprechaun ? true : false isAmoEnabled:isAmoEnabled ? true : false];
[SCGateway.shared setupWithConfig:config completion:^(BOOL success,NSError * error){
    if(success)
    {
       CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
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

- (void)triggerLeadGenWithLoginCta:(CDVInvokedUrlCommand*)command{
    NSDictionary *userDetailsDict = [command.arguments objectAtIndex:0];
    NSDictionary *utmDict = [command.arguments objectAtIndex:1];
    NSDictionary *leadGenProps = [command.arguments objectAtIndex:2];

    BOOL showLoginCta = false;

    if([leadGenProps[@"showLoginCta"] boolValue] == 1) {
        showLoginCta = true;
    }

    [SCGateway.shared triggerLeadGenWithPresentingController:[[[UIApplication sharedApplication] keyWindow] rootViewController] params:userDetailsDict utmParams:utmDict retargeting:false showLoginCta:showLoginCta completion:^(NSString * leadStatusResponse) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:leadStatusResponse];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)triggerLeadGenWithStatus:(CDVInvokedUrlCommand*)command{
    NSDictionary *dict = [command.arguments objectAtIndex:0];
    [SCGateway.shared triggerLeadGenWithPresentingController:[[[UIApplication sharedApplication] keyWindow] rootViewController] params:dict completion:^(NSString * leadStatusResponse) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:leadStatusResponse];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)triggerLeadGen:(CDVInvokedUrlCommand*)command{
    NSDictionary *dict = [command.arguments objectAtIndex:0];
    [SCGateway.shared triggerLeadGenWithPresentingController:[[[UIApplication sharedApplication] keyWindow] rootViewController] params:dict];
}

//MARK: logout
- (void)logout:(CDVInvokedUrlCommand*)command{
    __block CDVPluginResult *pluginResult = nil;
    [SCGateway.shared logoutUserWithPresentingController:[[[UIApplication sharedApplication] keyWindow] rootViewController] completion:^(BOOL success, NSError * error) {
        if(success) {
           CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
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

//MARK: Show orders
- (void) showOrders:(CDVInvokedUrlCommand *)command {
    
    __block CDVPluginResult *pluginResult = nil;
    
    [SCGateway.shared showOrdersWithPresentingController:[[[UIApplication sharedApplication] keyWindow] rootViewController] completion:^(BOOL success, NSError * error) {
        
        if (success) {
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        } else {
            
            NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
            
            if(error != nil) {
                [responseDict setValue:[NSNumber numberWithInteger:error.code]  forKey:@"errorCode"];
                [responseDict setValue:error.domain  forKey:@"error"];
                [responseDict setValue:[error.userInfo objectForKey: @"data"] forKey:@"data"];
            }
            
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:responseDict];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }];
}
@end
