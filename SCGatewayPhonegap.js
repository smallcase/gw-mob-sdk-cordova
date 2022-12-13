var exec = require('cordova/exec');
var plugin_list = require('cordova/plugin_list');

exports.getSdkVersion = function(successCallback, failureCallback) 
{
    cordova.exec(
        successCallback,
        failureCallback,
        "SCGatewayPhonegap",
        "getSdkVersion",
        [plugin_list.metadata['com.scgateway.phonegap']]
    );
}

exports.setConfigEnvironment = function(successCallback,failureCallback,args)
{   
    cordova.exec(
        {},
        {},
        "SCGatewayPhonegap",
        "setCordovaSdkVersion",
        [plugin_list.metadata['com.scgateway.phonegap']]
    );

    cordova.exec(
        successCallback,
        failureCallback,
        "SCGatewayPhonegap",
        "setConfigEnvironment",
        args);
};

exports.initSCGateway = function(successCallback,failureCallback,args)
{
    cordova.exec(
        successCallback,
        failureCallback,
        "SCGatewayPhonegap",
        "initSDK",
        args);
};
exports.triggerTransaction = function(successCallback,failureCallback,args)
{
    cordova.exec(
        successCallback,
        failureCallback,
        "SCGatewayPhonegap",
        "triggerTransaction",
        args);
};

exports.triggerMfTransaction = function(successCallback,failureCallback,args)
{
    cordova.exec(
        successCallback,
        failureCallback,
        "SCGatewayPhonegap",
        "triggerMfTransaction",
        args);
};

exports.triggerLeadGen = function(args)
{
    cordova.exec(
        function(winParam){},
        function(error){},
        "SCGatewayPhonegap",
        "triggerLeadGen",
        args);
};

exports.triggerLeadGenWithStatus = function(successCallback, failureCallback, args)
{
    cordova.exec(
        successCallback,
        failureCallback,
        "SCGatewayPhonegap",
        "triggerLeadGenWithStatus",
        args);
};

exports.triggerLeadGenWithLoginCta = function(successCallback, failureCallback, args)
{
    cordova.exec(
        successCallback,
        failureCallback,
        "SCGatewayPhonegap",
        "triggerLeadGenWithLoginCta",
        args);
};

exports.getUserInvestments = function(successCallback, failureCallback, args)
{
    cordova.exec(
        successCallback,
        failureCallback,
        "SCGatewayPhonegap",
        "getUserInvestments",
        args);
};

exports.logout = function(successCallback,failureCallback,args)
{
    cordova.exec(
        successCallback,
        failureCallback,
        "SCGatewayPhonegap",
        "logout",
        args
        );
};

exports.showOrders = function(successCallback, failureCallback, args) {
    cordova.exec(
        successCallback,
        failureCallback,
        "SCGatewayPhonegap",
        "showOrders",
        args
    );
};

exports.launchSmallplug = function(successCallback, failureCallback, args) {
    cordova.exec(
        successCallback,
        failureCallback,
        "SCGatewayPhonegap",
        "launchSmallplug",
        args
    );
};

exports.launchSmallplugWithBranding = function(successCallback, failureCallback, args) {
    cordova.exec(
        successCallback,
        failureCallback,
        "SCGatewayPhonegap",
        "launchSmallplugWithBranding",
        args
    );
};

exports.isUserConnected = function(successCallback, failureCallback) {
    cordova.exec(
        successCallback,
        failureCallback,
        "SCGatewayPhonegap",
        "isUserConnected"
    );
};

exports.ENVIRONMENT = {
    PRODUCTION: 'production',
    DEVELOPMENT: 'development',
    STAGING: 'staging'
};

exports.TRANSACTION_INTENT = {
    CONNECT: 'CONNECT',
    TRANSACTION: 'TRANSACTION',
    HOLDINGS_IMPORT: 'HOLDINGS_IMPORT',
    FETCH_FUNDS: 'FETCH_FUNDS'
};