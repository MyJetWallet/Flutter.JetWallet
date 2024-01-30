package dev.app.simple.com

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import android.app.Application
import io.maido.intercom.IntercomFlutterPlugin
import android.os.Build

class MainActivity: FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }
}

class MyApp : Application() {
  override fun onCreate() {
    super.onCreate()
    
    IntercomFlutterPlugin.initSdk(this, 
      // appId = BuildConfig.INTERCOM_APP_ID, 
      // androidApiKey = BuildConfig.INTERCOM_ANDROID_KEY)
      appId = "lci42mfw", 
      androidApiKey = "android_sdk-684bae5a9d75b05e583aeb048fbfa1be7774247c")
  }
}