#import "SiftPlugin.h"
#import "Sift/Sift.h"

@implementation SiftPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"sift"
            binaryMessenger:[registrar messenger]];
  SiftPlugin* instance = [[SiftPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"setSiftConfig" isEqualToString:call.method]) {
    NSString *accountId = call.arguments[@"accountId"];
    NSString *beaconKey = call.arguments[@"beaconKey"];

    Sift *sift = [Sift sharedInstance];
    [sift setAccountId:accountId];
    [sift setBeaconKey:beaconKey];
    [sift upload];

    result([@"Success sift"]);
  } else if ([@"setUserID" isEqualToString:call.method]) {
    NSString *userId = call.arguments[@"id"];

    [[Sift sharedInstance] setUserId:userId];
  } else if ([@"unsetUserID" isEqualToString:call.method]) {
    [[Sift sharedInstance] unsetUserId];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end