package com.example.sift

import android.app.Activity
import android.text.TextUtils
import android.content.Context
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

import java.util.*

import siftscience.android.Sift;

public class SiftPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private var siftConfig: Sift.Config? = null

  private lateinit var context: Context
  private lateinit var activity: Activity

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "sift")
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if(call.method == "setSiftConfig") {
      val accountId = call.argument<String>("accountId")
      val beaconKey = call.argument<String>("beaconKey")
      val serverUrlFormat = call.argument<String>("serverUrlFormat")

      try {
        if (accountId != null && beaconKey != null) {
          siftConfig = if (TextUtils.isEmpty(serverUrlFormat)) {
            Sift.Config.Builder()
              .withAccountId(accountId)
              .withBeaconKey(beaconKey)
              .build()
          } else {
              Sift.Config.Builder()
                .withAccountId(accountId)
                .withBeaconKey(beaconKey)
                .withServerUrlFormat(serverUrlFormat)
                .build()
          }
          Sift.open(context, siftConfig)
          Sift.collect()

          result.success("Sift config set successfully.")
        } else {
          result.success("Sift error")
        }
      } catch (e: Exception) {
        result.error("Sift error", e.message, null)
      }
  } else if(call.method == "setUserID") {
    val userId = call.argument("id") ?: ""

    try {
      Sift.setUserId(userId)
    } catch (e: Exception) {
      result.error("", e.message, null)
    }
  } else if(call.method == "unsetUserID") {
    try {
      Sift.unsetUserId()
    } catch (e: Exception) {
      result.error("", e.message, null)
    }
  } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

    override fun onDetachedFromActivity() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity;
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }
}

/*
class SiftPlugin(private val context: Context, private val flutterEngine: FlutterEngine) : MethodChannel.MethodCallHandler {

      private var siftConfig: Sift.Config? = null

      companion object {
          const val CHANNEL = "sift"
      }

      init {
          val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
          channel.setMethodCallHandler(this)
      }


      override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
              result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "setSiftConfig" -> {
                val accountId = call.argument<String>("accountId")
                val beaconKey = call.argument<String>("beaconKey")
                val disallowCollectingLocationData = call.argument<Boolean>("disallowCollectingLocationData")
                val serverUrlFormat = call.argument<String>("serverUrlFormat")

                if (accountId != null && beaconKey != null && disallowCollectingLocationData != null) {
                    siftConfig = if (TextUtils.isEmpty(serverUrlFormat)) {
                        Sift.Config.Builder()
                            .withAccountId(accountId)
                            .withBeaconKey(beaconKey)
                            .withDisallowLocationCollection(disallowCollectingLocationData)
                            .build()
                    } else {
                        Sift.Config.Builder()
                            .withAccountId(accountId)
                            .withBeaconKey(beaconKey)
                            .withDisallowLocationCollection(disallowCollectingLocationData)
                            .withServerUrlFormat(serverUrlFormat)
                            .build()
                    }
                    Sift.open(context, siftConfig)
                    Sift.collect()
                    result.success("Sift config set successfully.")
                } else {
                    result.error("INVALID_PARAMETERS", "Invalid parameters provided.", null)
                }
            }
            else -> result.notImplemented()
        }
    }
}
*/

/** SiftPlugin 
import androidx.lifecycle.Lifecycle;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter;
import io.flutter.plugin.common.PluginRegistry.Registrar

import java.util.*

import siftscience.android.Sift;

class SiftPlugin: FlutterPlugin, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private val handler: MethodCallHandler = MethodCallHandler(null)

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    handler.activity = null
    handler.startListening(binding.binaryMessenger)

  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    handler.activity = null
    handler.stopListening()
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    handler.activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    handler.activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }

  companion object {
    fun registerWith(registrar: Registrar) {
      val handler = MethodCallHandler(registrar.activity())
      handler.startListening(registrar.messenger())
    }
  }
}
*/