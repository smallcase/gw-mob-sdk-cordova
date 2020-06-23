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
        try{
            JSONArray jsonBrokerList = (JSONArray)args.get(3);
            if (jsonBrokerList != null) { 
                int len = jsonBrokerList.length();
                for (int i=0;i<len;i++){ 
                 brokerList.add(jsonBrokerList.get(i).toString());
                } 
             } 
        }catch(JSONException e){}
       
        SmallcaseGatewaySdk.INSTANCE.setConfigEnvironment(new Environment(buildType,args.getString(1),(Boolean)args.get(2),brokerList),new SmallcaseGatewayListeners(){
            @Override
            public void onGatewaySetupSuccessfull() {
                JSONObject jo = new JSONObject();
                try{
                    jo.put("success",true);
                    callbackContext.success(jo);
                }catch(JSONException e){
                    callbackContext.success();
                }
            
            }

            @Override
            public void onGatewaySetupFailed(String error) {
                JSONObject jo = new JSONObject();
                try{
                    jo.put("success",false);
                    jo.put("error",error);
                    callbackContext.error(jo);
                }catch(JSONException e){
                    callbackContext.error("JSONException");
                }
                
            }
        });
        return true;
    } else if (action.equals("initSDK")) {
        SmallcaseGatewaySdk.INSTANCE.init(new InitRequest(args.getString(0)),new DataListener<InitialisationResponse>() {
            @Override
            public void onSuccess(InitialisationResponse response) {
                
                    JSONObject jo = new JSONObject();
                   
                        try{
                        jo.put("success", true);
                        } catch(JSONException e)
                        {
                            
                        }
                    
                    
                callbackContext.success(jo);
                
            }
 
            @Override
            public void onFailure(int errorCode, String errorMessage) {
                try{
                    JSONObject jo = new JSONObject();
                    jo.put("success",false);
                    jo.put("errorCode", errorCode);
                    jo.put("errorMessage", errorMessage);
                    callbackContext.error(jo);
                } catch(JSONException e)
                {
                    callbackContext.error("JSONException");
                }
              
            }
        });
        return true;
    }else if(action.equals("triggerTransaction"))
    {
        SmallcaseGatewaySdk.INSTANCE.triggerTransaction(this.cordova.getActivity(),args.getString(0),new TransactionResponseListener() {
            @Override
            public void onSuccess(TransactionResult transactionResult) { 
                callbackContext.success(convertToJson(transactionResult));
            }
 
            @Override
            public void onError(int errorCode, String errorMessage) {
                try{
                    JSONObject jo = new JSONObject();
                    jo.put("errorCode", errorCode);
                    jo.put("errorMessage", errorMessage);
                    callbackContext.error(jo);
                } catch(JSONException e)
                {
                    callbackContext.error("JSONException");
                }
            }
        }); 
        return true;
    }

return false;
}

private JSONObject convertToJson(TransactionResult transactionResult)
{
    JSONObject jsonObj = new JSONObject();
    if(transactionResult.getData()!=null)
    {
        try {
            JSONObject jsonObject = new JSONObject(transactionResult.getData());
            jsonObj.put("data",jsonObject);
         }catch (JSONException err){
            try {
                jsonObj.put("data",transactionResult.getData());
             }catch (JSONException err1){
                
             }
             
         }
    }
    if(transactionResult.getTransaction()!=null)
    {
        try {
            jsonObj.put("transaction",transactionResult.getTransaction().toString()); 
         }catch (JSONException err){}
      
    }
    try {
        jsonObj.put("success",transactionResult.getSuccess()); 
     }catch (JSONException err){}
    

    if(transactionResult.getErrorCode()!=null)
    {
        try {
            jsonObj.put("errorCode",transactionResult.getErrorCode());
         }catch (JSONException err){}
        
    }
    if(transactionResult.getError()!=null)
    {
        try {
            jsonObj.put("error",transactionResult.getError());
         }catch (JSONException err){}
       
    }

    return jsonObj;
}

/**private void showToast(String msg)
{
    Context context = this.cordova.getActivity().getApplicationContext();
    int duration = Toast.LENGTH_SHORT;

    Toast toast = Toast.makeText(context, msg, duration);
    toast.show();
}*/
}