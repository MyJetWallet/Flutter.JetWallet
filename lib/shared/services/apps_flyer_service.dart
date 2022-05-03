import 'dart:convert';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:crypto/crypto.dart';

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

  void register(String email) {
    final bytes = utf8.encode(email);
    final hashEmail = sha256.convert(bytes).toString();

    appsflyerSdk.logEvent('af_complete_registration', {
      'af_registration_method': 'email',
      'af_email': hashEmail,
    });
  }
}
