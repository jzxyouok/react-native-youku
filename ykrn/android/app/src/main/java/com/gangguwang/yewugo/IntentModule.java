package com.gangguwang.yewugo;

import android.app.Activity;
import android.content.Intent;
import android.text.TextUtils;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.JSApplicationIllegalArgumentException;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;


public class IntentModule  extends ReactContextBaseJavaModule {

    public IntentModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "IntentModule";
    }

    /**
     * Activtiy跳转到JS页面，传输数据
     * @param successBack
     * @param errorBack
     */
    @ReactMethod
    public void dataToJS(Callback successBack, Callback errorBack){
        try{
            Activity currentActivity = getCurrentActivity();
            String result = currentActivity.getIntent().getStringExtra("data");
            if (TextUtils.isEmpty(result)){
                result = "没有数据";
            }
            successBack.invoke(result);
        }catch (Exception e){
            errorBack.invoke(e.getMessage());
        }
    }
    /**
     * 从JS页面跳转到原生activity   同时也可以从JS传递相关数据到原生
     * @param className
     * @param params
     */
    @ReactMethod
    public void startActivityFromJS(String className, String params){
        try{
            Activity currentActivity = getCurrentActivity();
            if(null!=currentActivity){
                Class toActivity = Class.forName(className);
                Intent intent = new Intent(currentActivity,toActivity);
                //intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                intent.putExtra("params", params);
                currentActivity.startActivity(intent);
            }

        }catch(Exception e){
            throw new JSApplicationIllegalArgumentException("不能打开Activity : "+e.getMessage());
        }
    }

    /**
     * 从JS页面跳转到Activity界面，并且等待从Activity返回的数据给JS
     * @param className
     * @param params
     * @param requestCode
     * @param successBack
     * @param errorBack
     */
    @ReactMethod
    public void startActivityFromJSGetResult(String className, String params, int requestCode, Callback successBack, Callback errorBack){
        try {
            Activity currentActivity = getCurrentActivity();
            if(currentActivity != null) {
                Class toActivity = Class.forName(className);
                Intent intent = new Intent(currentActivity,toActivity);
                //intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                intent.putExtra("params", params);
                currentActivity.startActivityForResult(intent,requestCode);
                // //进行回调数据
                // successBack.invoke(MainActivity.mQueue.take());
            }
        } catch (Exception e) {
            errorBack.invoke(e.getMessage());
            e.printStackTrace();
        }
    }

    // /**
    //  * 必须添加反射注解不然会报错
    //  * 这个方法就是ReactNative将要调用的方法，会通过此类名字调用
    //  * @param msg
    //  */
    // @ReactMethod
    // public void callNativeMethod(String msg) {
    //     Toast.makeText(mContext, msg, Toast.LENGTH_SHORT).show();
    //     //startActivityForResult(myIntent, 1);
    // }

}
