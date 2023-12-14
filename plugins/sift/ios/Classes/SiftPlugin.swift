/*
import Flutter
import UIKit
import Sift

public class SiftPluginImpl: NSObject, FlutterPlugin {

  var channel: FlutterMethodChannel

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "sift", binaryMessenger: registrar.messenger())
    let instance = SiftPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  init(channel: FlutterMethodChannel) {
    self.channel = channel
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let channel = self.channel

    switch call.method {
      case "getPlatformVersion":
        result("iOS " + UIDevice.current.systemVersion)
      default:
        result(FlutterMethodNotImplemented)
    }
  }
}
*/