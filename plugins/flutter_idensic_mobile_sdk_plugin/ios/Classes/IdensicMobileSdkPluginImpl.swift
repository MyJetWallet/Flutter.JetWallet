import Flutter
import UIKit
import IdensicMobileSDK


public class IdensicMobileSdkPluginImpl: NSObject, FlutterPlugin {

    var channel: FlutterMethodChannel
    weak var sdk: SNSMobileSDK?

    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let channel = FlutterMethodChannel(name: "sumsub.com/flutter_idensic_mobile_sdk_plugin",
                                           binaryMessenger: registrar.messenger())
        
        let instance = IdensicMobileSdkPluginImpl(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

        if call.method == "dismiss" {
            self.sdk?.dismiss()
            return
        }
        
        if call.method != "onLaunchSDK" {
            result(FlutterMethodNotImplemented)
            return
        }
        
        let channel = self.channel
        
        let args = call.arguments as? Dictionary<String, Any>
        let baseUrl = args?["apiUrl"] as? String ?? ""
        let accessToken = args?["accessToken"] as? String ?? ""
        let locale = args?["languageCode"] as? String ?? ""
        let isDebug = args?["isDebug"] as? Bool ?? false
        let isAnalyticsEnabled = args?["isAnalyticsEnabled"] as? Bool ?? true
        let hasOnStatusChanged = args?["hasOnStatusChanged"] as? Bool ?? false
        let hasOnEvent = args?["hasOnEvent"] as? Bool ?? false
        let hasOnActionResult = args?["hasOnActionResult"] as? Bool ?? false
        let applicantConf = args?["applicantConf"] as? Dictionary<String, String>
        let strings = args?["strings"] as? Dictionary<String, String>
        let settings = args?["settings"] as? Dictionary<String, Any>
        let preferredDocumentDefinitions = args?["preferredDocumentDefinitions"] as? Dictionary<String, Any>
        let autoCloseOnApprove = args?["autoCloseOnApprove"] as? TimeInterval

        let environment = !baseUrl.isEmpty ? SNSEnvironment(baseUrl) : SNSEnvironment.production;
        
        let sdk = SNSMobileSDK(
            accessToken: accessToken,
            environment: environment
        )

        if !locale.isEmpty {
            sdk.locale = locale
        }
        
        guard sdk.isReady else {
            result(sdk.pluginResult)
            return
        }

        self.sdk = sdk
        
        if isDebug {
            sdk.logLevel = .debug
        }

        if !isAnalyticsEnabled {
            sdk.isAnalyticsEnabled = false
        }

        if let autoCloseOnApprove = autoCloseOnApprove {
            sdk.setOnApproveDismissalTimeInterval(autoCloseOnApprove)
        }

        if let strings = strings {
            sdk.strings = strings
        }

        if let settings = settings {
            sdk.settings = settings
        }
        
        if let email = applicantConf?["email"] {
            sdk.initialEmail = email
        }
        if let phone = applicantConf?["phone"] {
            sdk.initialPhone = phone
        }
        
        if let preferredDocumentDefinitions = preferredDocumentDefinitions {
            sdk.setPreferredDocumentDefinitions(json: preferredDocumentDefinitions)
        }

        sdk.tokenExpirationHandler { (onComplete) in
            channel.invokeMethod("onTokenExpiration", arguments: nil) { (newToken) in
                onComplete(newToken as? String)
            }
        }
        
        if hasOnStatusChanged {
            sdk.onStatusDidChange { (sdk, prevStatus) in
                channel.invokeMethod("onStatusChanged", arguments: [
                    sdk.description(for: sdk.status),
                    sdk.description(for: prevStatus)
                ])
            }
        }
        
        if hasOnEvent {
            sdk.onEvent { (sdk, event) in
                channel.invokeMethod("onEvent", arguments: [event.asDict])
            }
        }

        if hasOnActionResult {
            sdk.actionResultHandler { (sdk, result, onComplete) in

                channel.invokeMethod("onActionResult", arguments: [result.asDict]) { (reaction) in
                    if let reaction = reaction as? String, reaction == "cancel" {
                        onComplete(.cancel)
                    } else {
                        onComplete(.continue)
                    }
                }
            }
        }

        sdk.onDidDismiss { (sdk) in
            result(sdk.pluginResult)
        }
        
        if let theme = args?["theme"] as? [String:Any] {
            sdk.theme = SNSTheme(
                fromJSON: theme,
                assetsPath: FlutterDartProject.lookupKey(forAsset: ""),
                assetNameHandler: { assetName in
                    return assetName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                }
            )
        }

        applyCustomizationIfAny()
        
        sdk.present()
    }
}

extension IdensicMobileSdkPluginImpl {
    
    /**
     * Usage:
     *
     * Add a class named `IdensicMobileSDKCustomization` into the main project
     * and define a static method named `apply:` that will take an instance of `SNSMobileSDK`
     *
     * For example, in Swift:
     *
     * import IdensicMobileSDK
     *
     * class IdensicMobileSDKCustomization: NSObject {
     *   @objc static func apply(_ sdk: SNSMobileSDK) {
     *   }
     * }
     *
     */
    
    func applyCustomizationIfAny() {
        
        let className = "IdensicMobileSDKCustomization"
        let selector = Selector(("apply:"))
        
        var customization: AnyClass? = Bundle.main.classNamed(className)
        if customization == nil {
            if let classPrefix = Bundle.main.object(forInfoDictionaryKey: kCFBundleExecutableKey as String) {
                customization = Bundle.main.classNamed("\(classPrefix).\(className)")
            }
        }
        
        if let customization = customization as? NSObject.Type, customization.responds(to: selector) {
            customization.perform(selector, with: sdk)
        }
    }
}

typealias Dict = [String:Any]

extension SNSMobileSDK {
        
    var pluginResult: Dict {

        var result = Dict()
        
        result["success"] = status != .failed
        result["status"] = description(for: status)
        
        if (status == .failed) {
            result["errorType"] = description(for: failReason)
            result["errorMsg"] = verboseStatus
        }
        
        if let actionResult = actionResult, status == .actionCompleted {
            result["actionResult"] = actionResult.asDict
        }

        return result
    }
}

extension SNSActionResult {

    var asDict: Dict {

        var result = Dict()
        
        let actionId: String? = self.actionId
        let actionType: String? = self.actionType

        result["actionId"] = actionId ?? ""
        result["actionType"] = actionType ?? ""
        result["answer"] = answer ?? ""
        result["allowContinuing"] = allowContinuing

        return result
    }
}

extension SNSEvent {

    var asDict: Dict {

        var result = Dict()

        result["eventType"] = description(for: eventType)
        result["payload"] = payload

        return result
    }
}
