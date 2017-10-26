package com.gangguwang.yewugo;

import android.app.Application;

import com.facebook.react.ReactApplication;
import com.facebook.react.ReactNativeHost;
import com.facebook.react.ReactPackage;
import com.facebook.react.shell.MainReactPackage;
import com.facebook.soloader.SoLoader;

import java.util.Arrays;
import java.util.List;

import com.youku.cloud.player.YoukuPlayerConfig;

public class MainApplication extends Application implements ReactApplication {

  //请在这里输入你的应用的clientId，clientSecret
  public static final String CLIENT_ID_WITH_AD = "e7e4d0ee1591b0bf";
  public static final String CLIENT_SECRET_WITH_AD = "1fbf633f8a55fa1bfabf95729d8e259a";

  private final ReactNativeHost mReactNativeHost = new ReactNativeHost(this) {
    @Override
    public boolean getUseDeveloperSupport() {
      return BuildConfig.DEBUG;
    }

    @Override
    protected List<ReactPackage> getPackages() {
      return Arrays.<ReactPackage>asList(
          new MainReactPackage(),
          new IntentReactPackage()
      );
    }

    @Override
    protected String getJSMainModuleName() {
      return "index";
    }

  };

  @Override
  public ReactNativeHost getReactNativeHost() {
    return mReactNativeHost;
  }

  @Override
  public void onCreate() {
    super.onCreate();
    SoLoader.init(this, /* native exopackage */ false);

    YoukuPlayerConfig.setClientIdAndSecret(CLIENT_ID_WITH_AD,CLIENT_SECRET_WITH_AD);
    YoukuPlayerConfig.onInitial(this);
    YoukuPlayerConfig.setLog(false);
  }

}
