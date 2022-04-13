import 'package:appsflyer_sdk/appsflyer_sdk.dart';

class AppsFlyerService {
  AppsFlyerService.create({
    required this.devKey,
    required this.iosAppId,
  }) {
    final appsFlyerOptions = {
      'afDevKey': devKey,
      'afAppId': iosAppId,
      'disableAdvertisingIdentifier': true
    };

    appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
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
