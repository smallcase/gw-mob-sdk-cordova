package com.scgateway.phonegap;

import com.smallcase.gateway.portal.SmallcaseGatewaySdk;
import org.apache.cordova.*;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/*For toast and context*/
import java.util.ArrayList;
import android.content.Context;
import android.widget.Toast;
import com.smallcase.gateway.data.models.Environment;
import com.smallcase.gateway.data.SmallcaseGatewayListeners;
import com.smallcase.gateway.data.requests.InitRequest;
import com.smallcase.gateway.data.models.InitialisationResponse;
import com.smallcase.gateway.data.listeners.DataListener;
import com.google.gson.Gson;
import com.smallcase.gateway.data.listeners.TransactionResponseListener;
import com.smallcase.gateway.data.models.TransactionResult;
public class SCGatewayPhonegap extends CordovaPlugin {

CordovaInterface mCordova;

@Override
public void initialize(CordovaInterface cordova, CordovaWebView webView) {
super.initialize(cordova, webView);
mCordova = cordova;
}
@Override
public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException{
    if (action.equals("setConfigEnvironment")){
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
        JSONArray jsonBrokerList = (JSONArray)args.get(3);
        if (jsonBrokerList != null) { 
            int len = jsonBrokerList.length();
            for (int i=0;i<len;i++){ 
             brokerList.add(jsonBrokerList.get(i).toString());
            } 
         } 
         showToast(args.toString());
        SmallcaseGatewaySdk.INSTANCE.setConfigEnvironment(new Environment(buildType,args.getString(1),(Boolean)args.get(2),brokerList),new SmallcaseGatewayListeners(){
            @Override
            public void onGatewaySetupSuccessfull() {
                showToast("init success");
            callbackContext.success("init success");
            }

            @Override
            public void onGatewaySetupFailed(String error) {
                showToast("init failed");
                callbackContext.error(error);
            }
        });
        return true;
    } else if (action.equals("initSDK")) {
        SmallcaseGatewaySdk.INSTANCE.init(new InitRequest(args.getString(0)),new DataListener<InitialisationResponse>() {
            @Override
            public void onSuccess(InitialisationResponse response) {
                   Gson gso = new Gson(); 
                callbackContext.success(gso.toJson(response));
                
            }
 
            @Override
            public void onFailure(int errorCode, String errorMessage) {
                try{
                    JSONObject jo = new JSONObject();
                    jo.put("errorCode", errorCode);
                    jo.put("errorMessage", errorMessage);
                    callbackContext.error(jo.toString());
                } catch(JSONException e)
                {
                    callbackContext.error(e.getMessage());
                }
              
            }
        });
        return true;
    }else if(action.equals("triggerTransaction"))
    {
        showToast(args.getString(0));
        SmallcaseGatewaySdk.INSTANCE.triggerTransaction(this.cordova.getActivity(),args.getString(0),new TransactionResponseListener() {
            @Override
            public void onSuccess(TransactionResult transactionResult) {
                Gson gso = new Gson(); 
                callbackContext.success(gso.toJson(transactionResult));
            }
 
            @Override
            public void onError(int errorCode, String errorMessage) {
                try{
                    JSONObject jo = new JSONObject();
                    jo.put("errorCode", errorCode);
                    jo.put("errorMessage", errorMessage);
                    callbackContext.error(jo.toString());
                } catch(JSONException e)
                {
                    callbackContext.error(e.getMessage());
                }
            }
        }); 
        return true;
    }
if("init".equals(action)) {
    Context context = this.cordova.getActivity().getApplicationContext();
    int duration = Toast.LENGTH_LONG;

    Toast toast = Toast.makeText(context, "Hello World!", duration);
    toast.show();
/**if(configJson == null) {
configJson = new JSONObject();
}

Instabug.initialize(mCordova.getActivity().getApplication(), configJson.getString(“androidToken”));
Instabug.getInstance().setActivity(mCordova.getActivity());
callbackContext.success();
} else if(“invoke”.equals(action)) {
Instabug.getInstance().invoke();
} else if(“invokeFeedbackSender”.equals(action)) {
Instabug.getInstance().invokeFeedbackSender();
} else if(“invokeBugReporter”.equals(action)) {
Instabug.getInstance().invokeBugReporter();*/
return true;
}

return false;
}

private void showToast(String msg)
{
    Context context = this.cordova.getActivity().getApplicationContext();
    int duration = Toast.LENGTH_SHORT;

    Toast toast = Toast.makeText(context, msg, duration);
    toast.show();
}
}