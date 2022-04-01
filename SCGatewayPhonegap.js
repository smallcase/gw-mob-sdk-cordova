var exec = require('cordova/exec');
var plugin_list = require('cordova/plugin_list');

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

// exports.triggerLeadGen = function(args)
// {
//     cordova.exec(
//         function(winParam){},
//         function(error){},
//         "SCGatewayPhonegap",
//         "triggerLeadGen",
//         args);
// };

exports.triggerLeadGen = function(successCallback, failureCallback, args)
{
    cordova.exec(
        successCallback,
        failureCallback,
        "SCGatewayPhonegap",
        "triggerLeadGen",
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

exports.launchSmallplug = function(successCallback, failureCallback, args) {
    cordova.exec(
        successCallback,
        failureCallback,
        "SCGatewayPhonegap",
        "launchSmallplug",
        args
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