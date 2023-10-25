package com.example.sift

import androidx.annotation.NonNull
import android.util.Log
import android.app.Activity

import androidx.lifecycle.Lifecycle;
import android.annotation.SuppressLint
import io.flutter.plugin.common.BinaryMessenger

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import siftscience.android.Sift;

class MethodCallHandler(var activity: Activity?) : MethodChannel.MethodCallHandler {
    private var methodChannel: MethodChannel? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "getPlatformVersion") {
          result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else if (call.method == "setUserID") {
          val userId = call.argument("id") ?: ""
    
          try {
            Sift.setUserId(userId)

            result.success(true)
          } catch (e: Exception) {
            result.error("", e.message, null)
          }
        } else if (call.method == "unsetUserID") {
          try {
            Sift.unsetUserId()

            result.success(true)
          } catch (e: Exception) {
            result.error("", e.message, null)
          }
        } else {
          result.notImplemented()
        }
      }

        @SuppressLint("LogNotTimber")
        fun startListening(messenger: BinaryMessenger) {
            if (methodChannel != null) {
                Log.wtf(TAG, "Setting a method call handler before the last was disposed.")
                stopListening()
            }
            methodChannel = MethodChannel(messenger, CHANNEL_NAME)
            methodChannel?.setMethodCallHandler(this)
        }

        /**
         * Clears this instance from listening to method calls.
         *
         * <p>Does nothing is {@link #startListening} hasn't been called, or if we're already stopped.
         */
        @SuppressLint("LogNotTimber")
        fun stopListening() {
            if (methodChannel == null) {
                Log.d(TAG, "Tried to stop listening when no methodChannel had been initialized.")
                return
            }

            methodChannel?.setMethodCallHandler(null)
            methodChannel = null
        }

      companion object {

        private const val TAG = "MethodCallHandler"
        private const val CHANNEL_NAME = "sift"
    }
}