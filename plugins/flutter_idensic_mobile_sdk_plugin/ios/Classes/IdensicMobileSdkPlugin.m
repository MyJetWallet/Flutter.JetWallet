#import "IdensicMobileSdkPlugin.h"
#if __has_include(<flutter_idensic_mobile_sdk_plugin/flutter_idensic_mobile_sdk_plugin-Swift.h>)
#import <flutter_idensic_mobile_sdk_plugin/flutter_idensic_mobile_sdk_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_idensic_mobile_sdk_plugin-Swift.h"
#endif

@implementation IdensicMobileSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [IdensicMobileSdkPluginImpl registerWithRegistrar:registrar];
}
@end
