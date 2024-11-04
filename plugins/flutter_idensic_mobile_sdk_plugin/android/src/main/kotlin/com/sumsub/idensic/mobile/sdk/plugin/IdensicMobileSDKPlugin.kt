package com.sumsub.idensic.mobile.sdk.plugin

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry.Registrar

/** IdensicMobileSDKPlugin */
class IdensicMobileSDKPlugin: FlutterPlugin, ActivityAware {

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

    /**
     * Registers a plugin implementation that uses the stable `io.flutter.plugin.common`
     * package.
     *
     *
     * Calling this automatically initializes the plugin. However plugins initialized this way
     * won't react to changes in activity or context.
     */
    fun registerWith(registrar: Registrar) {
      val handler = MethodCallHandler(registrar.activity())
      handler.startListening(registrar.messenger())
    }
  }
}
