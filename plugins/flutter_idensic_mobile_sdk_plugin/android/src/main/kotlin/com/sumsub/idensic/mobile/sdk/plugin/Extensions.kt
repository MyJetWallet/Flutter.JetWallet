package com.sumsub.idensic.mobile.sdk.plugin

import io.flutter.plugin.common.MethodChannel
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
import kotlin.coroutines.suspendCoroutine

suspend fun MethodChannel.invokeMethodBlock(method: String, arguments: Any? = null): Any? = suspendCoroutine { continuation ->
    invokeMethod(method, arguments, object : MethodChannel.Result {
        override fun notImplemented() { }

        override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
            continuation.resumeWithException(Exception(errorMessage))
        }

        override fun success(response: Any?) {
            continuation.resume(response)
        }
    })
}