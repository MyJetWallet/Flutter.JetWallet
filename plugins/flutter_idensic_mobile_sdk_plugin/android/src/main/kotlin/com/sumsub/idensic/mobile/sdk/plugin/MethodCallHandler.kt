package com.sumsub.idensic.mobile.sdk.plugin

import android.annotation.SuppressLint
import android.app.Activity
import android.util.Log
import com.sumsub.sns.core.SNSActionResult
import com.sumsub.sns.core.SNSCoreModule
import com.sumsub.sns.core.SNSMobileSDK
import com.sumsub.sns.core.SNSModule
import com.sumsub.sns.core.data.listener.SNSActionResultHandler
import com.sumsub.sns.core.data.listener.SNSCompleteHandler
import com.sumsub.sns.core.data.listener.SNSErrorHandler
import com.sumsub.sns.core.data.listener.SNSEvent
import com.sumsub.sns.core.data.listener.SNSEventHandler
import com.sumsub.sns.core.data.listener.SNSStateChangedHandler
import com.sumsub.sns.core.data.listener.TokenExpirationHandler
import com.sumsub.sns.core.data.model.*
import com.sumsub.sns.core.theme.SNSCustomizationFileFormat
import com.sumsub.sns.prooface.SNSProoface
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.runBlocking
import java.util.*

class MethodCallHandler(var activity: Activity?) : MethodChannel.MethodCallHandler {

    private var methodChannel: MethodChannel? = null
    private var snsSdk: SNSMobileSDK.SDK? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "dismiss") {
            snsSdk?.dismiss();
        } else if (call.method == "onLaunchSDK") {
            val apiUrl = call.argument("apiUrl") ?: ""
            val accessToken = call.argument("accessToken") ?: ""
            val languageCode = call.argument("languageCode") ?: ""
            val appConf = call.argument("applicantConf") as? Map<String, String>
            val settings = call.argument("settings") as? Map<String, String>
            val theme = call.argument("theme") as? Map<String, Any>

            val strings = call.argument("strings") as? Map<String, String>
            val isAnalyticsEnabled = call.argument("isAnalyticsEnabled") ?: true
            val isDebug = call.argument("isDebug") ?: false
            val modules: MutableList<SNSModule> = mutableListOf(SNSProoface())
            val preferredDocumentDefinitions = call.argument("preferredDocumentDefinitions") as? Map<String, Any>
            val autoCloseOnApprove = call.argument("autoCloseOnApprove") as? Int

            val onTokenExpirationHandler = object : TokenExpirationHandler {
                override fun onTokenExpired(): String? = runBlocking(Dispatchers.Main.immediate) {
                    return@runBlocking methodChannel?.invokeMethodBlock("onTokenExpiration") as? String
                }
            }

            val errorHandler: SNSErrorHandler = object : SNSErrorHandler {
                override fun onError(exception: SNSException) {
                    activity?.runOnUiThread {
                        methodChannel?.invokeMethod("onError", exception.toMap())!!
                    }
                }
            }

            val stateHandler: SNSStateChangedHandler? = if (call.argument("hasOnStatusChanged") as? Boolean == true) {
                object : SNSStateChangedHandler {
                    override fun onStateChanged(previousState: SNSSDKState, currentState: SNSSDKState) {
                        activity?.runOnUiThread {
                            methodChannel?.invokeMethod(
                                "onStatusChanged",
                                listOf(currentState.toStateString(), previousState.toStateString())
                            )!!
                        }
                    }
                }
            } else {
                null
            }

            val eventHandler: SNSEventHandler? = if (call.argument("hasOnEvent") as? Boolean == true) {
                object : SNSEventHandler {
                    override fun onEvent(event: SNSEvent) {
                        activity?.runOnUiThread {
                            val eventType = event.eventType.capitalize()
                            val params = event.payload?.mapKeys {
                                if (it.key == "isCanceled") "isCancelled" else it.key
                            }
                            methodChannel?.invokeMethod(
                                "onEvent", listOf(
                                    mapOf(
                                        "eventType" to eventType,
                                        "payload" to params
                                    )
                                )
                            )
                        }
                    }
                }
            } else {
                null
            }

            val completeHandler: SNSCompleteHandler = object : SNSCompleteHandler {
                override fun onComplete(r: SNSCompletionResult, state: SNSSDKState) {
                    result.success(r.toMap(state))
                }
            }

            val actionResultHandler: SNSActionResultHandler? =
                if (call.argument("hasOnActionResult") as? Boolean == true) {
                    object : SNSActionResultHandler {
                        override fun onActionResult(
                            actionId: String,
                            actionType: String,
                            answer: String?,
                            allowContinuing: Boolean
                        ): SNSActionResult {
                            return runBlocking(Dispatchers.Main.immediate) {
                                return@runBlocking try {
                                    val arguments = listOf(
                                        mapOf(
                                            "actionId" to actionId,
                                            "answer" to answer,
                                            "actionType" to actionType,
                                            "allowContinuing" to allowContinuing
                                        )
                                    )
                                    val reaction =
                                        methodChannel?.invokeMethodBlock("onActionResult", arguments) as? String
                                    if (reaction == "cancel") SNSActionResult.Cancel else SNSActionResult.Continue
                                } catch (e: Exception) {
                                    Log.d("FLU", Log.getStackTraceString(e))
                                    SNSActionResult.Continue
                                }
                            }
                        }
                    }
                } else {
                    null
                }

            val builder = SNSMobileSDK.Builder(activity!!)

            if (apiUrl.isNotEmpty()) builder.withBaseUrl(apiUrl)

            builder.withAccessToken(accessToken, onTokenExpiration = onTokenExpirationHandler)
                .withCompleteHandler(completeHandler)
                .withStateChangedHandler(stateHandler)
                .withActionResultHandler(actionResultHandler)
                .withEventHandler(eventHandler)
                .withErrorHandler(errorHandler)
                .withConf(SNSInitConfig(appConf?.get("email"), appConf?.get("phone"), strings))
                .withSettings(settings)
                .withModules(modules)
                .withDebug(isDebug)
                .withAnalyticsEnabled(isAnalyticsEnabled)
            theme?.let {
                builder.withMappedTheme(it, SNSCustomizationFileFormat.FLUTTER)
            }

            preferredDocumentDefinitions?.let {
                val docs = it.entries.mapNotNull { entry ->
                    (entry.value as? Map<String, Any>)?.let { doc ->
                        entry.key to SNSDocumentDefinition(
                            idDocType = doc["idDocType"] as? String,
                            country = doc["country"] as? String
                        )
                    }
                }.toMap()
                builder.withPreferredDocumentDefinitions(docs)
            }

            autoCloseOnApprove?.also {
                builder.withAutoCloseOnApprove(autoCloseOnApprove)
            }

            if (languageCode.isNotEmpty()) {
                builder.withLocale(Locale(languageCode))
            }

            try {
                snsSdk = builder.build()
                snsSdk?.launch()
            } catch (e: Exception) {
                Log.e(TAG, e.toString(), e)
                result.error("", e.message, null)
            }
        } else {
            result.notImplemented()
        }
    }

    /**
     * Registers this instance as a method call handler on the given {@code messenger}.
     *
     * <p>Stops any previously started and unstopped calls.
     *
     * <p>This should be cleaned with {@link #stopListening} once the messenger is disposed of.
     */
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
        private const val CHANNEL_NAME = "sumsub.com/flutter_idensic_mobile_sdk_plugin"
    }
}

fun SNSException.toMap(): Map<String, Any> {
    val type = when (this) {
        is SNSException.Api -> "Api"
        is SNSException.Network -> "Network"
        is SNSException.Unknown -> "Unknown"
    }

    val payload = when (this) {
        is SNSException.Api -> mapOf("code" to code, "description" to description, "correlationId" to correlationId)
        is SNSException.Network -> mapOf("message" to (message ?: ""))
        is SNSException.Unknown -> mapOf("message" to (message ?: ""))
    }

    return mapOf("type" to type, "payload" to payload)
}

fun SNSCompletionResult.toMap(state: SNSSDKState): Map<String, Any?> {
    val success = this is SNSCompletionResult.SuccessTermination
    var errorType: String? = null
    var errorMsg: String? = null
    if (state is SNSSDKState.Failed) {
        errorType = when (state) {
            is SNSSDKState.Failed.ApplicantNotFound -> "ApplicantNotFound"
            is SNSSDKState.Failed.ApplicantMisconfigured -> "ApplicantMisconfigured"
            is SNSSDKState.Failed.InitialLoadingFailed -> "InitialLoadingFailed"
            is SNSSDKState.Failed.InvalidParameters -> "InvalidParameters"
            is SNSSDKState.Failed.NetworkError -> "NetworkError"
            is SNSSDKState.Failed.Unauthorized -> "Unauthorized"
            else -> "Unknown"
        }

        errorMsg = state.message
        if (state.exception?.message != null) {
            errorMsg += ". ${state.exception?.message}"
        }
    }

    val actionResult = if (state is SNSSDKState.ActionCompleted) {
        mapOf("actionId" to state.actionId, "answer" to state.answer)
    } else {
        null
    }

    return mapOf(
        "success" to success,
        "status" to state.toStateString(),
        "errorType" to errorType,
        "errorMsg" to errorMsg,
        "actionResult" to actionResult
    )
}

fun SNSSDKState.toStateString(): String {
    return when (this) {
        is SNSSDKState.Approved -> "Approved"
        is SNSSDKState.Failed -> "Failed"
        is SNSSDKState.FinallyRejected -> "FinallyRejected"
        is SNSSDKState.Incomplete -> "Incomplete"
        is SNSSDKState.Initial -> "Initial"
        is SNSSDKState.Pending -> "Pending"
        is SNSSDKState.Ready -> "Ready"
        is SNSSDKState.TemporarilyDeclined -> "TemporarilyDeclined"
        is SNSSDKState.ActionCompleted -> "ActionCompleted"
        else -> "<unknown>"
    }
}
