var exec = require('cordova/exec');

exports.callInit = function()
{
    console.log('Called init');
    cordova.exec(function(winParam) {},
    function(error) {},
    "SCGatewayPhonegap",
    "init",
    []);
};

exports.setConfigEnvironment = function(successCallback,failureCallback,args)
{
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

exports.ENVIRONMENT = {
    PRODUCTION: 'production',
    DEVELOPMENT: 'development',
    STAGING: 'staging'
};

exports.TRANSACTION_INTENT = {
    CONNECT: 'CONNECT',
    TRANSACTION: 'TRANSACTION',
    HOLDINGS_IMPORT: 'HOLDINGS_IMPORT'
};
/*var SCGatewayPhonegap = {

    init: function() {
    
    },
    
    invoke: function() {
    cordova.exec(function(winParam) {},
    function(error) {},
    “InstabugPhoneGap”,
    “invoke”,
    []);
    
    },
    
    invokeBugReporter: function() {
    cordova.exec(function(winParam) {},
    function(error) {},
    “InstabugPhoneGap”,
    “invokeBugReporter”,
    []);
    },
    
    invokeFeedbackSender: function() {
    cordova.exec(function(winParam) {},
    function(error) {},
    “InstabugPhoneGap”,
    “invokeFeedbackSender”,
    []);
    },
    }*/