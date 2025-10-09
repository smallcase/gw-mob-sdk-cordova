#import "SCGatewayPhonegap.h"
#import <SCGateway/SCGateway-Swift.h>
#import <Cordova/CDV.h>

@implementation SCGatewayPhonegap

// MARK: - SDK Version Management
- (void)setCordovaSdkVersion:(CDVInvokedUrlCommand*)command {
    NSLog(@"Setting Cordova SDK version");
    
    // Note: These methods may not exist in v6.0.1, keeping for compatibility
    if ([SCGateway.shared respondsToSelector:@selector(setSDKTypeWithType:)]) {
        [SCGateway.shared setSDKTypeWithType:@"cordova"];
    }
    
    NSString *versionString = [command.arguments objectAtIndex:0];
    if ([SCGateway.shared respondsToSelector:@selector(setHybridSDKVersionWithVersion:)]) {
        [SCGateway.shared setHybridSDKVersionWithVersion:versionString];
    }
}

- (void)getSdkVersion:(CDVInvokedUrlCommand*)command {
    __block CDVPluginResult *pluginResult = nil;
    
    // Try to get native SDK version, fallback to static string if method doesn't exist
    NSString *nativeSdkString = @"ios:6.0.1"; // Fallback version
    if ([SCGateway.shared respondsToSelector:@selector(getSdkVersion)]) {
        nativeSdkString = [NSString stringWithFormat:@"ios:%@", [SCGateway.shared getSdkVersion]];
    }
    
    NSString *cordovaSdkString = [NSString stringWithFormat:@",cordova:%@", [command.arguments objectAtIndex:0]];
    NSString *result = [nativeSdkString stringByAppendingString:cordovaSdkString];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

// MARK: - User Connection Status
- (void)isUserConnected:(CDVInvokedUrlCommand *)command {
    __block CDVPluginResult *pluginResult = nil;
    
    // This method may not exist in v6.0.1, provide fallback
    BOOL isUserConnected = NO;
    if ([SCGateway.shared respondsToSelector:@selector(isUserConnected)]) {
        isUserConnected = [SCGateway.shared isUserConnected];
    }
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:isUserConnected];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

// MARK: - Transaction Flow
- (void)triggerTransaction:(CDVInvokedUrlCommand*)command {
    NSLog(@"Transaction triggered");
    __block CDVPluginResult *pluginResult = nil;
    NSString *transactionId = [command.arguments objectAtIndex:0];
    
    // Get the root view controller safely
    UIViewController *presentingController = [self getRootViewController];
    
    [SCGateway.shared triggerTransactionFlowWithTransactionId:transactionId 
                                           presentingController:presentingController 
                                                     completion:^(id response, ObjcTransactionError *error) {
        
        if (error != nil) {
            NSLog(@"Transaction error: %@", error.domain);
            [self handleTransactionError:error callbackId:command.callbackId];
            return;
        }
        
        [self handleTransactionResponse:response callbackId:command.callbackId];
    }];
}

// MARK: - Configuration
- (void)setConfigEnvironment:(CDVInvokedUrlCommand*)command {
    NSLog(@"Setting config environment");
    __block CDVPluginResult *pluginResult = nil;
    
    NSString *environmentStr = [command.arguments objectAtIndex:0];
    NSString *gatewayName = [command.arguments objectAtIndex:1];
    BOOL isLeprechaun = [[command.arguments objectAtIndex:2] boolValue];
    BOOL isAmoEnabled = YES;
    NSArray *brokerConfig = nil;
    
    // Parse broker config if provided
    if (command.arguments.count > 3 && [[command.arguments objectAtIndex:3] isKindOfClass:[NSArray class]]) {
        brokerConfig = [command.arguments objectAtIndex:3];
    }
    
    // Parse AMO enabled flag
    if (command.arguments.count > 4) {
        isAmoEnabled = [[command.arguments objectAtIndex:4] boolValue];
    }
    
    // Map environment string to enum
    NSInteger environment = EnvironmentProduction;
    if ([environmentStr isEqualToString:@"development"]) {
        environment = EnvironmentDevelopment;
    } else if ([environmentStr isEqualToString:@"staging"]) {
        environment = EnvironmentStaging;
    }
    
    // Create gateway config
    GatewayConfig *config = [[GatewayConfig alloc] initWithGatewayName:gatewayName 
                                                          brokerConfig:brokerConfig 
                                                       apiEnvironment:environment 
                                                   isLeprechaunActive:isLeprechaun 
                                                         isAmoEnabled:isAmoEnabled];
    
    [SCGateway.shared setupWithConfig:config completion:^(BOOL success, NSError *error) {
        if (success) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
            [responseDict setValue:[NSNumber numberWithBool:NO] forKey:@"success"];
            if (error != nil) {
                [responseDict setValue:[NSNumber numberWithInteger:error.code] forKey:@"errorCode"];
                [responseDict setValue:error.domain forKey:@"error"];
            }
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:responseDict];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

// MARK: - SDK Initialization
- (void)initSCGateway:(CDVInvokedUrlCommand*)command {
    __block CDVPluginResult *pluginResult = nil;
    NSString *authToken = [command.arguments objectAtIndex:0];
    NSLog(@"Initializing SCGateway with token: %@", authToken);
    
    [SCGateway.shared initializeGatewayWithSdkToken:authToken completion:^(BOOL success, NSError *error) {
        if (success) {
            NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
            [responseDict setValue:[NSNumber numberWithBool:YES] forKey:@"success"];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:responseDict];
        } else {
            NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
            [responseDict setValue:[NSNumber numberWithBool:NO] forKey:@"success"];
            if (error != nil) {
                [responseDict setValue:[NSNumber numberWithInteger:error.code] forKey:@"errorCode"];
                [responseDict setValue:error.domain forKey:@"error"];
            }
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:responseDict];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

// MARK: - Lead Generation
- (void)triggerLeadGen:(CDVInvokedUrlCommand*)command {
    NSDictionary *userDetails = [command.arguments objectAtIndex:0];
    UIViewController *presentingController = [self getRootViewController];
    
    // Use the new API if available
    if ([SCGateway.shared respondsToSelector:@selector(triggerLeadGenWithPresentingController:params:completion:)]) {
        [SCGateway.shared triggerLeadGenWithPresentingController:presentingController 
                                                           params:userDetails 
                                                       completion:^(NSString *leadStatusResponse) {
            // Lead gen completion handled
        }];
    }
}

- (void)triggerLeadGenWithStatus:(CDVInvokedUrlCommand*)command {
    NSDictionary *userDetails = [command.arguments objectAtIndex:0];
    UIViewController *presentingController = [self getRootViewController];
    
    [SCGateway.shared triggerLeadGenWithPresentingController:presentingController 
                                                       params:userDetails 
                                                   completion:^(NSString *leadStatusResponse) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:leadStatusResponse];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

// MARK: - Logout
- (void)logout:(CDVInvokedUrlCommand*)command {
    __block CDVPluginResult *pluginResult = nil;
    UIViewController *presentingController = [self getRootViewController];
    
    [SCGateway.shared logoutUserWithPresentingController:presentingController completion:^(BOOL success, NSError *error) {
        if (success) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
            [responseDict setValue:[NSNumber numberWithBool:NO] forKey:@"success"];
            if (error != nil) {
                [responseDict setValue:[NSNumber numberWithInteger:error.code] forKey:@"errorCode"];
                [responseDict setValue:error.domain forKey:@"error"];
            }
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:responseDict];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

// MARK: - Show Orders
- (void)showOrders:(CDVInvokedUrlCommand *)command {
    __block CDVPluginResult *pluginResult = nil;
    UIViewController *presentingController = [self getRootViewController];
    
    [SCGateway.shared showOrdersWithPresentingController:presentingController completion:^(BOOL success, NSError *error) {
        if (success) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
            if (error != nil) {
                [responseDict setValue:[NSNumber numberWithInteger:error.code] forKey:@"errorCode"];
                [responseDict setValue:error.domain forKey:@"error"];
            }
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:responseDict];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

// MARK: - Helper Methods
- (UIViewController *)getRootViewController {
    // Safe way to get root view controller for iOS 13+
    UIWindow *window = nil;
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                window = windowScene.windows.firstObject;
                break;
            }
        }
    } else {
        window = [UIApplication sharedApplication].keyWindow;
    }
    return window.rootViewController;
}

- (void)handleTransactionError:(ObjcTransactionError *)error callbackId:(NSString *)callbackId {
    NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
    [responseDict setValue:[NSNumber numberWithBool:NO] forKey:@"success"];
    [responseDict setValue:[NSNumber numberWithInteger:error.code] forKey:@"errorCode"];
    [responseDict setValue:error.domain forKey:@"error"];
    [responseDict setValue:@"ERROR" forKey:@"transaction"];
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:responseDict];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

- (void)handleTransactionResponse:(id)response callbackId:(NSString *)callbackId {
    NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
    [responseDict setValue:[NSNumber numberWithBool:YES] forKey:@"success"];
    
    if ([response isKindOfClass:[ObjcTransactionIntentTransaction class]]) {
        ObjcTransactionIntentTransaction *trxResponse = response;
        [responseDict setValue:@"TRANSACTION" forKey:@"transaction"];
        
        // Handle transaction data
        if (trxResponse.transaction) {
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:trxResponse.transaction options:0];
            if (decodedData) {
                NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
                NSDictionary *transactionData = [NSJSONSerialization JSONObjectWithData:[decodedString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
                [responseDict setValue:transactionData forKey:@"data"];
            }
        }
        
    } else if ([response isKindOfClass:[ObjcTransactionIntentHoldingsImport class]]) {
        ObjcTransactionIntentHoldingsImport *trxResponse = response;
        [responseDict setValue:@"HOLDINGS_IMPORT" forKey:@"transaction"];
        
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        [data setValue:trxResponse.authToken forKey:@"smallcaseAuthToken"];
        [data setValue:[NSNumber numberWithBool:trxResponse.status] forKey:@"success"];
        [data setValue:trxResponse.transactionId forKey:@"transactionId"];
        [responseDict setValue:data forKey:@"data"];
        
    } else if ([response isKindOfClass:[ObjCTransactionIntentConnect class]]) {
        ObjCTransactionIntentConnect *trxResponse = response;
        [responseDict setValue:@"CONNECT" forKey:@"transaction"];
        
        if (trxResponse.transaction) {
            [responseDict setValue:trxResponse.transaction forKey:@"data"];
        }
    }
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:responseDict];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

@end
