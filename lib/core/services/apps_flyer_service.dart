import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AppsFlyerService {
  AppsFlyerService.create({
    required this.devKey,
    required this.iosAppId,
  }) {
    final options = AppsFlyerOptions(
      afDevKey: devKey,
      appId: iosAppId,
      disableCollectASA: false,
      disableAdvertisingIdentifier: false,
      timeToWaitForATTUserAuthorization: 60,
    );

    appsflyerSdk = AppsflyerSdk(options);
  }

  final String devKey;
  final String iosAppId;

  late AppsflyerSdk appsflyerSdk;

  String tempInstallConversionData = '';

  Future<void> init() async {
    await appsflyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );

    appsflyerSdk.onInstallConversionData((value) {
      tempInstallConversionData = value.toString();
    });
  }

  Future<void> updateServerUninstallToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      appsflyerSdk.updateServerUninstallToken(token);
    }
  }
}
