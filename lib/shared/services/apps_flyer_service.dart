import 'package:appsflyer_sdk/appsflyer_sdk.dart';

class AppsFlyerService {
  AppsFlyerService.create({
    required this.devKey,
    required this.iosAppId,
  }) {
    final options = AppsFlyerOptions(
      afDevKey: devKey,
      appId: iosAppId,
      disableAdvertisingIdentifier: true,
      timeToWaitForATTUserAuthorization: 30,
    );

    appsflyerSdk = AppsflyerSdk(options);
  }

  final String devKey;
  final String iosAppId;

  late AppsflyerSdk appsflyerSdk;

  Future<void> init() async {
    await appsflyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );
  }
}
