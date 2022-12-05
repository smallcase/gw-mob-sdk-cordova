package com.scgateway.phonegap;

import com.smallcase.gateway.data.listeners.LeadGenResponseListener;
import com.smallcase.gateway.data.models.SmallplugData;
import com.smallcase.gateway.portal.SmallcaseGatewaySdk;
import org.apache.cordova.*;
import org.jetbrains.annotations.NotNull;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import java.util.*;

/*For toast and context*/
import java.util.ArrayList;
import android.content.Context;
import android.util.Log;
import android.
widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.smallcase.gateway.data.models.Environment;
import com.smallcase.gateway.data.SmallcaseLogoutListener;
import com.smallcase.gateway.data.SmallcaseGatewayListeners;
import com.smallcase.gateway.data.requests.InitRequest;
import com.smallcase.gateway.data.models.InitialisationResponse;
import com.smallcase.gateway.data.listeners.DataListener;
import com.google.gson.Gson;
import com.smallcase.gateway.data.models.SmallcaseGatewayDataResponse;
import com.smallcase.gateway.data.listeners.TransactionResponseListener;
import com.smallcase.gateway.data.listeners.MFHoldingsResponseListener;
import com.smallcase.gateway.data.models.TransactionResult;
import com.smallcase.gateway.data.listeners.SmallPlugResponseListener;
import com.smallcase.gateway.data.models.SmallPlugResult;
import com.smallcase.gateway.portal.SmallplugPartnerProps;

public class SCGatewayPhonegap extends CordovaPlugin {

CordovaInterface mCordova;

@Override
public void initialize(CordovaInterface cordova, CordovaWebView webView) {
super.initialize(cordova, webView);
mCordova = cordova;
}
@Override
public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException{
    switch (action) {
        case "setCordovaSdkVersion":
            SmallcaseGatewaySdk.INSTANCE.setSDKType("cordova");
            SmallcaseGatewaySdk.INSTANCE.setHybridSDKVersion(String.valueOf(args.get(0)));
        case "getSdkVersion":
            String nativeSdkVersion = "android:" + SmallcaseGatewaySdk.INSTANCE.getSdkVersion();
            String cordovaSdkVersion = ",cordova:" + String.valueOf(args.get(0));
            callbackContext.success(nativeSdkVersion+cordovaSdkVersion);
        case "isUserConnected":
            callbackContext.success(String.valueOf(SmallcaseGatewaySdk.INSTANCE.isUserConnected()));
        case "setConfigEnvironment":
            Environment.PROTOCOL buildType;
            switch (args.getString(0)) {
                case "production":
                    buildType = Environment.PROTOCOL.PRODUCTION;
                    break;
                case "development":
                    buildType = Environment.PROTOCOL.DEVELOPMENT;
                    break;
                default:
                    buildType = Environment.PROTOCOL.STAGING;
                    break;
            }
            ArrayList<String> brokerList = new ArrayList<String>();
            try {
                JSONArray jsonBrokerList = (JSONArray) args.get(3);
                if (jsonBrokerList != null) {
                    int len = jsonBrokerList.length();
                    for (int i = 0; i < len; i++) {
                        brokerList.add(jsonBrokerList.get(i).toString());
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            Boolean isAmoEnabled = true;

            try {
                if (args.get(3) instanceof Boolean) {
                    isAmoEnabled = (Boolean) args.get(3);
                } else if (args.get(4) instanceof Boolean) {
                    isAmoEnabled = (Boolean) args.get(4);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }


            SmallcaseGatewaySdk.INSTANCE.setConfigEnvironment(new Environment(buildType, args.getString(1), (Boolean) args.get(2), isAmoEnabled, brokerList), new SmallcaseGatewayListeners() {
                @Override
                public void onGatewaySetupSuccessfull() {
                    JSONObject jo = new JSONObject();
                    try {
                        jo.put("success", true);
                        callbackContext.success(jo);
                    } catch (JSONException e) {
                        e.printStackTrace();
                        callbackContext.success();
                    }

                }

                @Override
                public void onGatewaySetupFailed(String error) {
                    JSONObject jo = new JSONObject();
                    try {
                        jo.put("success", false);
                        jo.put("error", error);
                        callbackContext.error(jo);
                    } catch (JSONException e) {
                        e.printStackTrace();
                        callbackContext.error("JSONException");
                    }

                }
            });
            return true;

        case "initSDK":
            SmallcaseGatewaySdk.INSTANCE.init(new InitRequest(args.getString(0)), new DataListener<InitialisationResponse>() {
                @Override
                public void onSuccess(InitialisationResponse response) {

                    JSONObject jo = new JSONObject();

                    try {
                        jo.put("success", true);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                    callbackContext.success(jo);
                }

                @Override
                public void onFailure(int errorCode, String errorMessage, String data) {
                    try {
                        JSONObject jo = new JSONObject();
                        jo.put("success", false);
                        jo.put("errorCode", errorCode);
                        jo.put("errorMessage", errorMessage);
                        jo.put("data", data);
                        callbackContext.error(jo);
                    } catch (JSONException e) {
                        e.printStackTrace();
                        callbackContext.error("JSONException");
                    }

                }
            });
            return true;
        case "triggerTransaction":
            SmallcaseGatewaySdk.INSTANCE.triggerTransaction(this.cordova.getActivity(), args.getString(0), new TransactionResponseListener() {
                @Override
                public void onSuccess(@NonNull TransactionResult transactionResult) {
                    callbackContext.success(convertToJson(transactionResult));
                }

                @Override
                public void onError(int errorCode, @NonNull String errorMessage, @Nullable String data) {

                    try {
                        JSONObject jo = new JSONObject();
                        jo.put("errorCode", errorCode);
                        jo.put("errorMessage", errorMessage);

                        if (data != null && !data.isEmpty()) {
                            jo.put("data", new JSONObject(data));
                        }
                        callbackContext.error(jo);
                        
                    } catch (JSONException e) {
                        e.printStackTrace();
                        callbackContext.error("JSONException");
                    }
                }
            });
            return true;
        case "triggerMfTransaction":
            SmallcaseGatewaySdk.INSTANCE.triggerMfTransaction(this.cordova.getActivity(), args.getString(0), new MFHoldingsResponseListener() {
                @Override
                public void onSuccess(@NonNull TransactionResult transactionResult) {
                    callbackContext.success(convertToJson(transactionResult));
                }

                @Override
                public void onError(int errorCode, @NonNull String errorMessage, @Nullable String data) {

                    try {
                        JSONObject jo = new JSONObject();
                        jo.put("errorCode", errorCode);
                        jo.put("errorMessage", errorMessage);

                        if (data != null && !data.isEmpty()) {
                            jo.put("data", new JSONObject(data));
                        }
                        callbackContext.error(jo);
                        
                    } catch (JSONException e) {
                        e.printStackTrace();
                        callbackContext.error("JSONException");
                    }
                }
            });
            return true;
        case "launchSmallplug":

            SmallcaseGatewaySdk.INSTANCE.launchSmallPlug(this.cordova.getActivity(), new SmallplugData(args.getString(0), args.getString(1)), new SmallPlugResponseListener() {

                @Override
                public void onSuccess(@NotNull SmallPlugResult smallPlugResult) {

                    Log.d("SCGatewayPhoneGap", "smallplug onSuccess: " + smallPlugResult.toString());

                    try {
                        JSONObject jo = new JSONObject();
                        jo.put("success", smallPlugResult.getSuccess());
                        jo.put("smallcaseAuthToken", smallPlugResult.getSmallcaseAuthToken());
                        callbackContext.success(jo);
                    } catch (JSONException e) {
                        e.printStackTrace();
                        callbackContext.error("JSONException");
                    }
                }

                @Override
                public void onFailure(int i, @NotNull String s) {

                    Log.d("SCGatewayPhoneGap", "smallplug onFailure: " + i + s);

                    try {
                        JSONObject jo = new JSONObject();
                        jo.put("errorCode", i);
                        jo.put("errorMessage", s);
                        callbackContext.error(jo);
                    } catch (JSONException e) {
                        e.printStackTrace();
                        callbackContext.error("JSONException");
                    }

                }

            }, null);

            return true;

        case "launchSmallplugWithBranding":

            SmallcaseGatewaySdk.INSTANCE.launchSmallPlug(
                    this.cordova.getActivity(),
                    new SmallplugData(args.getString(0),
                            args.getString(1)), new SmallPlugResponseListener() {

                @Override
                public void onSuccess(@NotNull SmallPlugResult smallPlugResult) {

                    Log.d("SCGatewayPhoneGap", "smallplug onSuccess: " + smallPlugResult.toString());

                    try {
                        JSONObject jo = new JSONObject();
                        jo.put("success", smallPlugResult.getSuccess());
                        jo.put("smallcaseAuthToken", smallPlugResult.getSmallcaseAuthToken());
                        callbackContext.success(jo);
                    } catch (JSONException e) {
                        e.printStackTrace();
                        callbackContext.error("JSONException");
                    }
                }

                @Override
                public void onFailure(int i, @NotNull String s) {

                    Log.d("SCGatewayPhoneGap", "smallplug onFailure: " + i + s);

                    try {
                        JSONObject jo = new JSONObject();
                        jo.put("errorCode", i);
                        jo.put("errorMessage", s);
                        callbackContext.error(jo);
                    } catch (JSONException e) {
                        e.printStackTrace();
                        callbackContext.error("JSONException");
                    }

                }

            }, new SmallplugPartnerProps(
                        args.getString(2) == null || args.getString(2).length() < 6 ? "#2F363F" : args.getString(2),
                        args.getDouble(3),
                        args.getString(4) == null || args.getString(4).length() < 6 ? "#FFFFFF" : args.getString(4),
                        args.getDouble(5)
                    ));

            return true;    
        case "triggerLeadGenWithStatus":
            HashMap<String, String> map = new HashMap<String, String>();
            if (args.get(0) instanceof JSONObject) {
                JSONObject obj = (JSONObject) args.get(0);
                Iterator<String> keys = obj.keys();
                while (keys.hasNext()) {
                    String key = (String) keys.next(); // First key in your json object
                    String value = (String) obj.getString(key);
                    map.put(key, value);
                }
            }

            SmallcaseGatewaySdk.INSTANCE.triggerLeadGen(this.cordova.getActivity(), map, new LeadGenResponseListener() {
                @Override
                public void onSuccess(@NonNull String leadStatusResponse) {
                    callbackContext.success(leadStatusResponse);
                }
            });

            return true;

        case "triggerLeadGen":
            HashMap<String, String> leadGenMap = new HashMap<String, String>();
            if (args.get(0) instanceof JSONObject) {
                JSONObject obj = (JSONObject) args.get(0);
                Iterator<String> keys = obj.keys();
                while (keys.hasNext()) {
                    String key = (String) keys.next(); // First key in your json object
                    String value = (String) obj.getString(key);
                    leadGenMap.put(key, value);
                }
            }
            
            SmallcaseGatewaySdk.INSTANCE.triggerLeadGen(this.cordova.getActivity(), leadGenMap);

            return true;
            case "triggerLeadGenWithLoginCta":
            Log.d("SCGatewayPhoneGap", "triggerLeadGenWithLoginCta args: " + args);
            HashMap<String, String> leadGenMapUserDetails = new HashMap<String, String>();
            if (args.get(0) instanceof JSONObject) {
                JSONObject obj = (JSONObject) args.get(0);
                Iterator<String> keys = obj.keys();
                while (keys.hasNext()) {
                    String key = (String) keys.next(); // First key in your json object
                    String value = (String) obj.getString(key);
                    leadGenMapUserDetails.put(key, value);
                }
            }

            HashMap<String, String> utmMap = new HashMap<String, String>();
            if (args.get(1) instanceof JSONObject) {
                JSONObject obj = (JSONObject) args.get(1);
                Iterator<String> keys = obj.keys();
                while (keys.hasNext()) {
                    String key = (String) keys.next(); // First key in your json object
                    String value = (String) obj.getString(key);
                    utmMap.put(key, value);
                }
            }

            boolean showLoginCta = false;
            if (args.get(2) instanceof JSONObject) {
                JSONObject obj = (JSONObject) args.get(2);
                try {
                    showLoginCta = obj.getBoolean("showLoginCta");
                } catch (Exception e) {
                }
            }

            SmallcaseGatewaySdk.INSTANCE.triggerLeadGen(
                    this.cordova.getActivity(),
                    leadGenMapUserDetails,
                    utmMap,
                    null,
                    showLoginCta,
                    new LeadGenResponseListener() {
                        @Override
                        public void onSuccess(@NonNull String leadStatusResponse) {
                            callbackContext.success(leadStatusResponse);
                        }
                    });

            return true;
            case "getUserInvestments":
            ArrayList<String> iscidList = new ArrayList<String>();
            try {
                JSONArray jsonIscidList = (JSONArray) args.get(0);
                if (jsonIscidList != null) {
                    int len = jsonIscidList.length();
                    for (int i = 0; i < len; i++) {
                        iscidList.add(jsonIscidList.get(i).toString());
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            
            SmallcaseGatewaySdk.INSTANCE.getUserInvestments(iscidList, new DataListener<SmallcaseGatewayDataResponse>() {

                @Override
                public void onSuccess(SmallcaseGatewayDataResponse response) {
                    JSONObject jo = new JSONObject();
                    try {
                        callbackContext.success(response.getValue(new Gson()));
                    } catch (Exception e) {
                        e.printStackTrace();
                        callbackContext.error("JSONException");
                    }
                }

                @Override
                public void onFailure(int errorCode, String errorMessage, String data) {
                    try {
                        JSONObject jo = new JSONObject();
                        jo.put("errorCode", errorCode);
                        jo.put("errorMessage", errorMessage);
                        if(data != null) {
                            jo.put("data", data);
                        }
                        callbackContext.error(jo);
                    } catch (JSONException e) {
                        e.printStackTrace();
                        callbackContext.error("JSONException");
                    }

                }

            });

        return true;
        case "logout":

            SmallcaseGatewaySdk.INSTANCE.logoutUser(this.cordova.getActivity(), new SmallcaseLogoutListener() {

                @Override
                public void onLogoutSuccessfull() {
                    JSONObject jo = new JSONObject();
                    try {
                        jo.put("success", true);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                    callbackContext.success(jo);
                }

                @Override
                public void onLogoutFailed(int errorCode, String errorMessage) {
                    try {
                        JSONObject jo = new JSONObject();
                        jo.put("errorCode", errorCode);
                        jo.put("errorMessage", errorMessage);
                        callbackContext.error(jo);
                    } catch (JSONException e) {
                        e.printStackTrace();
                        callbackContext.error("JSONException");
                    }

                }

            });

            return true;
            
            case "showOrders":

            ArrayList<String> showOrdersBrokerList = new ArrayList<String>();
            try {
                JSONArray jsonBrokerList = (JSONArray) args.get(0);
                if (jsonBrokerList != null) {
                    for (int i = 0; i < jsonBrokerList.length(); i++) {
                        showOrdersBrokerList.add(jsonBrokerList.get(i).toString());
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            
            SmallcaseGatewaySdk.INSTANCE.showOrders(this.cordova.getActivity(), showOrdersBrokerList, new DataListener<Object>() {
                
                @Override
                public void onSuccess(Object o) {
                    JSONObject jo = new JSONObject();
                    try {
                        jo.put("success", true);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                    callbackContext.success(jo);
                }

                @Override
                public void onFailure(int errorCode, @NonNull String errorMessage, String data) {
                    try {
                        JSONObject jo = new JSONObject();
                        jo.put("errorCode", errorCode);
                        jo.put("errorMessage", errorMessage);
                        jo.put("data", data);
                        callbackContext.error(jo);
                    } catch (JSONException e) {
                        e.printStackTrace();
                        callbackContext.error("JSONException");
                    }
                }
                
            });

            return true;
    }

return false;
}

private JSONObject convertToJson(TransactionResult transactionResult) {
    JSONObject jsonObj = new JSONObject();
    if(transactionResult.getData()!=null) {
        try {
            JSONObject jsonObject = new JSONObject(transactionResult.getData());
            jsonObj.put("data",jsonObject);
         } catch (JSONException err){
            err.printStackTrace();
            try {
                jsonObj.put("data",transactionResult.getData());
             } catch (JSONException e){
                e.printStackTrace();
             }
             
         }
    }
    if(transactionResult.getTransaction()!=null) {
        try {
            jsonObj.put("transaction",transactionResult.getTransaction().toString()); 
         } catch (JSONException err){}
      
    }

    return jsonObj;
}

private void showToast(String msg)
{
    Context context = this.cordova.getActivity().getApplicationContext();
    int duration = Toast.LENGTH_SHORT;

    Toast toast = Toast.makeText(context, msg, duration);
    toast.show();
}
}